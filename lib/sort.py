"""
http://www.djangosnippets.org/snippets/308/

Handles creation of order_by criteria based on GET parameters and provides context variables to be used when generating table header sort links which respect the current sort field and direction, reversing the direction when the same header is sorted by again.

Sample view:

from somewhere import SortHeaders
from django.contrib.auth.models import User
from django.shortcuts import render_to_response

LIST_HEADERS = (
    ('Username', 'username'),
    ('First Name', 'first_name'),
    ('Last Name', 'last_name'),
    ('Email', None),
)

def user_list(request):
    sort_headers = SortHeaders(request, LIST_HEADERS)
    users = User.objects.order_by(sort_headers.get_order_by())
    return render_to_response('users/user_list.html', {
        'users': users,
        'headers': list(sort_headers.headers()),
    })

Sample template:

{% load my_tags %}
<table cellspacing="0">
<thead>
  <tr>
{% table_header headers %}
  </tr>
</thead>
<tbody>
  {% for user in users %}<tr class="{% cycle odd,even %}">
    <td><a href="{{ user.get_absolute_url|escape }}">{{ user.username|escape }}</a></td>
    <td>{{ user.first_name|escape }}</td>
    <td>{{ user.last_name|escape }}</td>
    <td>{{ user.email|escape }}</td>
  </tr>
  {% endfor %}
</tbody>
</table>

Sample inclusion tag:

from django import template

def table_header(context, headers):
    return {
        'headers': headers,
    }

register = template.Library()
register.inclusion_tag('table_header.html', takes_context=True)(table_header)

Sample inclusion tag template:

{% for header in headers %}<th{{ header.class_attr }}>
  {% if header.sortable %}<a href="{{ header.url|escape }}">{% endif %}
  {{ header.text }}
  {% if header.sortable %}</a>{% endif %}
</th>{% endfor %}

"""

ORDER_VAR = 'o'
ORDER_TYPE_VAR = 'ot'

class SortHeaders:
    """
    Handles generation of an argument for the Django ORM's
    ``order_by`` method and generation of table headers which reflect
    the currently selected sort, based on defined table headers with
    matching sort criteria.

    Based in part on the Django Admin application's ``ChangeList``
    functionality.
    """
    def __init__(self, request, headers, default_order_field=None,
            default_order_type='asc', additional_params=None):
        """
        request
            The request currently being processed - the current sort
            order field and type are determined based on GET
            parameters.

        headers
            A list of two-tuples of header text and matching ordering
            criteria for use with the Django ORM's ``order_by``
            method. A criterion of ``None`` indicates that a header
            is not sortable.

        default_order_field
            The index of the header definition to be used for default
            ordering and when an invalid or non-sortable header is
            specified in GET parameters. If not specified, the index
            of the first sortable header will be used.

        default_order_type
            The default type of ordering used - must be one of
            ``'asc`` or ``'desc'``.

        additional_params:
            Query parameters which should always appear in sort links,
            specified as a dictionary mapping parameter names to
            values. For example, this might contain the current page
            number if you're sorting a paginated list of items.
        """
        if default_order_field is None:
            for i, (header, query_lookup) in enumerate(headers):
                if query_lookup is not None:
                    default_order_field = i
                    break
        if default_order_field is None:
            raise AttributeError('No default_order_field was specified and none of the header definitions given were sortable.')
        if default_order_type not in ('asc', 'desc'):
            raise AttributeError('If given, default_order_type must be one of \'asc\' or \'desc\'.')
        if additional_params is None: additional_params = {}

        self.header_defs = headers
        self.additional_params = additional_params
        self.order_field, self.order_type = default_order_field, default_order_type

        # Determine order field and order type for the current request
        params = dict(request.GET.items())
        if ORDER_VAR in params:
            try:
                new_order_field = int(params[ORDER_VAR])
                if headers[new_order_field][1] is not None:
                    self.order_field = new_order_field
            except (IndexError, ValueError):
                pass # Use the default
        if ORDER_TYPE_VAR in params and params[ORDER_TYPE_VAR] in ('asc', 'desc'):
            self.order_type = params[ORDER_TYPE_VAR]

    def headers(self):
        """
        Generates dicts containing header and sort link details for
        all defined headers.
        """
        for i, (header, order_criterion) in enumerate(self.header_defs):
            th_classes = []
            new_order_type = 'asc'
            if i == self.order_field:
                th_classes.append('sorted %sending' % self.order_type)
                new_order_type = {'asc': 'desc', 'desc': 'asc'}[self.order_type]
            yield {
                'text': header,
                'sortable': order_criterion is not None,
                'url': self.get_query_string({ORDER_VAR: i, ORDER_TYPE_VAR: new_order_type}),
                'class_attr': (th_classes and ' class="%s"' % ' '.join(th_classes) or ''),
            }

    def get_query_string(self, params):
        """
        Creates a query string from the given dictionary of
        parameters, including any additonal parameters which should
        always be present.
        """
        params.update(self.additional_params)
        return '?%s' % '&amp;'.join(['%s=%s' % (param, value) \
                                     for param, value in params.items()])

    def get_order_by(self):
        """
        Creates an ordering criterion based on the current order
        field and order type, for use with the Django ORM's
        ``order_by`` method.
        """
        return '%s%s' % (
            self.order_type == 'desc' and '-' or '',
            self.header_defs[self.order_field][1],
        )
