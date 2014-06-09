# -*- coding:utf-8 -*-

import datetime

from django.utils.safestring import mark_safe
from django import template
register = template.Library()


@register.inclusion_tag("manager/tags/td.html", takes_context=True)
def table_td(context, item, field_name, editable, jscallback, show_if_failed=1, prefix=""):
    try:
        value = getattr(item, field_name)
    except AttributeError:
        value = ""

    show_if_failed = bool(show_if_failed)

    if callable(value):
        value = value()

    if isinstance(value, datetime.datetime):
        value = mark_safe(value.strftime("%d.%m.%Y<br/>%H:%M"))

    if isinstance(value, float):
        value = "%.2f" % value

    return {
        'item': item,
        'editable': editable,
        'field_name': field_name,
        'jscallback': jscallback,
        'value': value,
        'show_if_failed': show_if_failed,
        'prefix': prefix,
    }


@register.inclusion_tag('lib/table_header_sort.html', takes_context=True)
def table_header_sort(context, headers):
    return {
        'headers': headers,
    }


@register.simple_tag
def table_td_status(item):
    from data.models import ORDER_ITEM_STATUSES

    statuses = dict(ORDER_ITEM_STATUSES)
    if item.status not in ('order', 'moderation',):
        return mark_safe(
            '<td class="editable">%s</td>' % item.get_status_display())

    opts = []
    for f in ('order', 'moderation',):
        opts.append(
            '<option value="%(value)s" %(selected)s>%(verbose)s</option>' % {
                'value': f,
                'selected': f == item.status and 'selected' or "",
                'verbose': statuses[f]})

    return mark_safe(
        '<td class="editable">'
        '<select id="status_input_%(id)s" onchange="editStatus(%(id)s, this.value)">'
        '%(opts)s'
        '</select>'
        '</td>' % dict(id=item.id, opts="".join(opts)))


@register.inclusion_tag('manager/tags/founds.html')
def founds(founds, delta_formid=0):
    return {'founds': founds, 'delta': delta_formid}
