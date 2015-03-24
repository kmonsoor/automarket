# -*- coding=UTF-8 -*-

import datetime
import dateutil
import os
import pyExcelerator
import re

from django.conf import settings
from django.contrib.auth.decorators import login_required
from django.db import connection
from django.http import HttpResponse
from django.shortcuts import get_object_or_404

from lib.decorators import render_to
from lib.paginator import SimplePaginator
from lib.qs_filter import QSFilter
from lib.sort import SortHeaders

from data.models import (
    OrderedItem, BrandGroup, Area, Basket, Shipment, Package, BalanceItem,
    calc_parts_client, get_search_func, BALANCEITEM_TYPE_PREINVOICE
)
from data.forms import (
    OrderedItemsFilterForm, ShipmentsFilterForm, BalanceClientFilterForm,
    CLIENT_FIELD_LIST, CLIENT_SHIPMENTS_FIELD_LIST,
    BALANCE_CLIENT_FIELD_LIST_CLIENT
)

from client.forms import SearchForm


def get_period(request, prefix, field, default_period=None):
    PERIOD_PARAM = 'period'
    PERIOD_PARAM_WEEK = 'w'
    PERIOD_PARAM_MONTH = 'm'
    PERIOD_PARAM_YEAR = 'y'
    PERIOD_PARAM_ALL = 'a'
    PERIOD_PARAMS = (
        PERIOD_PARAM_WEEK,
        PERIOD_PARAM_MONTH,
        PERIOD_PARAM_YEAR,
        PERIOD_PARAM_ALL
    )
    PERIOD_PARAM_DEFAULT = default_period or PERIOD_PARAM_ALL

    period = request.GET.get(PERIOD_PARAM)

    session_key = "%s_%s" % (prefix, PERIOD_PARAM)
    if not period:
        period = request.session.get(session_key, None)
    else:
        request.session[session_key] = period
        request.session.modified = True

    if not period or period not in PERIOD_PARAMS:
        period = PERIOD_PARAM_DEFAULT

    rated_period = None
    if period:
        now = datetime.datetime.now()
        if period == 'w':
            rated_period = now + dateutil.relativedelta.relativedelta(
                weeks=-1, weekday=dateutil.relativedelta.calendar.SATURDAY,
                hour=0, minute=0, second=0, microsecond=0
            )
        elif period == 'm':
            rated_period = now + dateutil.relativedelta.relativedelta(
                day=1, hour=0, minute=0, second=0, microsecond=0
            )
        elif period == 'y':
            rated_period = now + dateutil.relativedelta.relativedelta(
                month=1, day=1, hour=0, minute=0, second=0, microsecond=0
            )
        elif period == 'a':
            pass

    if rated_period:
        return period, {'%s__gte' % field: rated_period}
    return period, {}


def get_items_per_page(request, prefix):
    ITEM_PER_PAGE_PARAM = 'items_per_page'
    ITEM_PER_PAGE_PARAM_ALL = 'all'
    ITEM_PER_PAGE_DEFAULT = 50

    items_per_page = request.GET.get(ITEM_PER_PAGE_PARAM)

    session_key = "%s_%s" % (prefix, ITEM_PER_PAGE_PARAM)
    if not items_per_page:
        items_per_page = request.session.get(session_key)
    else:
        request.session[session_key] = items_per_page
        request.session.modified = True

    if items_per_page == ITEM_PER_PAGE_PARAM_ALL:
        items_per_page = 10000

    if not items_per_page:
        items_per_page = ITEM_PER_PAGE_DEFAULT

    try:
        items_per_page = int(items_per_page)
    except (ValueError, TypeError):
        items_per_page = ITEM_PER_PAGE_DEFAULT

    return items_per_page


def get_show_preinvoices(request, prefix):
    SHOW_PREINVOICES_PARAM = 'preinvoices'
    SHOW_PREINVOICES_PARAM_DEFAULT_VALUE = 0
    try:
        show_preinvoices = int(request.GET.get(SHOW_PREINVOICES_PARAM))
    except (ValueError, TypeError):
        show_preinvoices = None

    session_key = "%s_%s" % (prefix, SHOW_PREINVOICES_PARAM)
    if show_preinvoices is None:
        show_preinvoices = request.session.get(
            session_key, SHOW_PREINVOICES_PARAM_DEFAULT_VALUE)  

    request.session[session_key] = show_preinvoices
    request.session.modified = True

    return show_preinvoices


@login_required
@render_to('client/search.html')
def search(request):
    parts = []
    analogs = []
    msg = ''

    show_maker_field = False

    if request.method == 'POST':
        _post = request.POST.copy()
        _post['part_number'] = re.sub('[\W]+', '', _post['part_number']).strip().upper()
        form = SearchForm(_post)

        if form.is_valid():

            maker = form.cleaned_data['maker']
            part_number = form.cleaned_data['part_number']
            search_type = form.cleaned_data['search_type']
            search_in_analogs = form.cleaned_data['search_in_analogs']

            search_func = get_search_func(search_type)
            part_founds, analog_founds = search_func(
                maker, part_number, search_in_analogs=search_in_analogs)

            if part_founds:
                makers = set(x['maker'] for x in part_founds)
                if len(makers) > 1:
                    show_maker_field = True
                    form.fields['maker'].widget.choices = [
                        ('', '----')] + [(x, x) for x in sorted(makers)]
                else:
                    parts = calc_parts_client(part_founds, request.user)
                    analogs = calc_parts_client(analog_founds, request.user)
            elif not part_founds and analog_founds:
                analogs = calc_parts_client(analog_founds, request.user)
            else:
                msg = u"Ничего не найдено"
    else:
        form = SearchForm()

    context = {
        'form': form,
        'data': parts,
        'analogs': analogs,
        'msg': msg,
        'show_maker_field': show_maker_field,
    }

    context['basket_items'] = Basket.objects.filter(
        creator=request.user,
        order_item_id__isnull=True
    ).order_by('-id')

    context['basket_price_sum'] = reduce(
        lambda x, y: x + y,
        [x.get_price_total() for x in context['basket_items']],
        0
    )
    return context


class ClientOrderItemDisplay(object):
    def __init__(self, obj, field, format):
        val = getattr(obj, field, u"")
        if val is None:
            val = u""
        self.value = val
        self.format = format

    def __unicode__(self):
        if 'date' in self.format:
            dateformat = self.format.split("::")[1]
            try:
                return self.value.strftime(dateformat)
            except AttributeError:
                return u"%s" % self.value
        return self.format % self.value


class ClientOrderItemRow(object):
    def __init__(self, fields, obj):
        self.fields = fields
        self.obj = obj

    def __iter__(self):
        for field_name, field_format in self.fields:
            yield ClientOrderItemDisplay(self.obj, field_name, field_format)


class ClientOrderItemList(object):
    def __init__(self, request, filter_form, session_store_prefix="client_index"):
        self.user = request.user
        self.set_fields()
        self.request = request
        self.filter = QSFilter(request, filter_form)

        session_store_prefix = session_store_prefix
        self.items_per_page = get_items_per_page(request, session_store_prefix)
        self.period, self.period_filter = get_period(request, session_store_prefix, "created")
        self.results = self.result_list()
        self.headers = self.list_headers()
        self.filters = self.list_filters()

    def set_fields(self):
        try:
            user_fields = self.user.get_profile().get_order_fields()
        except Exception:
            user_fields = None
        if user_fields:
            self.CLIENT_FIELDS = [x for x in CLIENT_FIELD_LIST if x[2] in user_fields]
        else:
            self.CLIENT_FIELDS = CLIENT_FIELD_LIST
        self.LIST_HEADERS = [(x[0], x[1]) for x in self.CLIENT_FIELDS]

    def result_list(self):
        return [
            ClientOrderItemRow([(x[2], x[3]) for x in self.CLIENT_FIELDS], obj)
            for obj in self.get_query_set()
        ]

    def list_headers(self):
        sort_headers = SortHeaders(self.request, self.LIST_HEADERS)
        return list(sort_headers.headers())

    def list_filters(self):
        def _inner():
            for x in self.CLIENT_FIELDS:
                try:
                    form_field = self.filter.form.__getitem__(x[4])
                    yield form_field
                except Exception:
                    yield ""

        return list(_inner())

    def get_query_set(self):
        order_field = self.request.GET.get('o', None)
        order_direction = self.request.GET.get('ot', None)

        order_by = '-created'
        if order_field:
            if order_direction == 'desc':
                order_direction = '-'
            else:
                order_direction = ''
            order_by = order_direction + self.LIST_HEADERS[int(order_field)][1]

        filters = self.filter.get_filters()

        qs = OrderedItem.objects.select_related() \
                        .filter(client=self.request.user) \
                        .filter(**filters)

        if self.period_filter:
            qs = qs.filter(**self.period_filter)

        # calculate totals by filter
        self.total_row = {}
        td = "U0"
        EXCLUDED_FILTER = {
            'status__in': ('failure',)
        }
        q, params = qs.exclude(**EXCLUDED_FILTER)._as_sql(connection)
        from_clause = q.split("FROM")[1]
        sql = """
            SELECT
                SUM(%(p)s.total_cost),
                SUM(%(p)s.weight*%(p)s.quantity),
                SUM(%(p)s.delivery),
                SUM(%(p)s.quantity*COALESCE(%(p)s.price_discount, %(p)s.price_sale, 0))
            FROM %(from)s
        """ % {'p': td, 'from': from_clause}
        cursor = connection.cursor()
        cursor.execute(sql, params)
        res = cursor.fetchall()
        if len(res) > 0:
            self.total_row = dict(zip(
                ('total_cost', 'weight', 'delivery', 'price_sale'),
                res[0]
            ))

        if order_by:
            qs = qs.order_by(order_by)

        self.paginator = SimplePaginator(self.request, qs, self.items_per_page, 'page')
        return self.paginator.get_page_items()

    def get_total_row(self):
        for f in self.CLIENT_FIELDS:
            field_name = f[2].split("__")[0]
            if field_name[:2] == "po":
                yield u"Итого"
            else:
                yield self.total_row.get(field_name, u"")


@login_required
@render_to('client/index.html')
def index(request):
    response = {}
    cl = ClientOrderItemList(request, OrderedItemsFilterForm)
    response['cl'] = cl
    response['paginator'] = cl.paginator
    response['items_per_page'] = cl.items_per_page
    response['period'] = cl.period
    response['qs_filter_param'] = cl.filter.get_filters()
    return response


class ClientShipmentList(object):
    def __init__(self, request, filter_form):
        self.request = request
        self.filter = QSFilter(request, filter_form)

        session_store_prefix = "client_shipments"
        self.items_per_page = get_items_per_page(request, session_store_prefix)
        self.period, self.period_filter = get_period(request, session_store_prefix, "created_at")
        self.results = self.result_list()
        self.headers = self.list_headers()
        self.filters = self.list_filters()

    def result_list(self):
        return self.get_query_set()

    def list_headers(self):
        sort_headers = SortHeaders(self.request, [(x[0], x[1]) for x in CLIENT_SHIPMENTS_FIELD_LIST])
        return list(sort_headers.headers())

    def list_filters(self):
        def _inner():
            for x in CLIENT_SHIPMENTS_FIELD_LIST:
                try:
                    form_field = self.filter.form.__getitem__(x[3])
                    yield form_field
                except Exception:
                    yield ""

        return list(_inner())

    def get_query_set(self):
        order_field = self.request.GET.get('o', None)
        order_direction = self.request.GET.get('ot', None)

        order_by = '-created_at'
        if order_field:
            if order_direction == 'desc':
                order_direction = '-'
            else:
                order_direction = ''
            order_by = order_direction + CLIENT_SHIPMENTS_FIELD_LIST[int(order_field)][1]

        qs = (
            Shipment.objects.select_related()
            .filter(client=self.request.user)
            .filter(**self.filter.get_filters())
        )

        if self.period_filter:
            qs = qs.filter(**self.period_filter)

        if order_by:
            qs = qs.order_by(order_by)

        self.paginator = SimplePaginator(self.request, qs, self.items_per_page, 'page')
        return self.paginator.get_page_items()


@login_required
@render_to('client/shipments.html')
def shipments(request):
    response = {}
    cl = ClientShipmentList(request, ShipmentsFilterForm)
    response['cl'] = cl
    response['paginator'] = cl.paginator
    response['items_per_page'] = cl.items_per_page
    response['period'] = cl.period
    response['shipments'] = shipments
    response['qs_filter_param'] = cl.filter.get_filters()
    return response


class ClientPackageOrderItemDisplay(object):
    def __init__(self, obj, field, format):
        val = getattr(obj, field, u"")
        if val is None:
            val = u""
        self.value = val
        if field == 'part_number':
            self.value = obj.description
        self.format = format

    def __unicode__(self):
        if 'date' in self.format:
            dateformat = self.format.split("::")[1]
            try:
                return self.value.strftime(dateformat)
            except AttributeError:
                return u"%s" % self.value
        return self.format % self.value


class ClientShipmentOrderItemRow(object):
    def __init__(self, fields, obj):
        self.fields = fields
        self.obj = obj

    def __iter__(self):
        for field_name, field_format in self.fields:
            yield ClientPackageOrderItemDisplay(self.obj, field_name, field_format)


class ClientShipmentOrderItemList(ClientOrderItemList):
    def __init__(self, request, filter_form, shipment):
        self.shipment = shipment
        super(ClientShipmentOrderItemList, self).__init__(
            request,
            filter_form,
            session_store_prefix="client_shipment"
        )

    def get_query_set(self):
        order_field = self.request.GET.get('o', None)
        order_direction = self.request.GET.get('ot', None)

        order_by = '-created'
        if order_field:
            if order_direction == 'desc':
                order_direction = '-'
            else:
                order_direction = ''
            order_by = order_direction + self.LIST_HEADERS[int(order_field)][1]

        qs = OrderedItem.objects.select_related() \
                        .filter(client=self.request.user, shipment=self.shipment) \
                        .filter(**self.filter.get_filters())

        if self.period_filter:
            qs = qs.filter(**self.period_filter)

        self.packages = Package.objects.filter(shipment=self.shipment).order_by('-created_at')
        self.packages_list = [
            ClientShipmentOrderItemRow([(x[2], x[3]) for x in self.CLIENT_FIELDS], obj)
            for obj in self.packages
        ]

        # calculate totals by filter
        total = {}
        td = "U0"
        EXCLUDED_FILTER = {
            'status__in': ('failure',)
        }
        q, params = qs.exclude(**EXCLUDED_FILTER)._as_sql(connection)
        from_clause = q.split("FROM")[1]
        sql = """
            SELECT
                SUM(%(p)s.total_cost),
                SUM(%(p)s.weight*%(p)s.quantity),
                SUM(%(p)s.delivery),
                SUM(%(p)s.quantity*COALESCE(%(p)s.price_discount, %(p)s.price_sale, 0))
            FROM %(from)s
        """ % {'p': td, 'from': from_clause}
        cursor = connection.cursor()
        cursor.execute(sql, params)
        res = cursor.fetchall()
        if len(res) > 0:
            total = dict(zip(
                ('total_cost', 'weight', 'delivery', 'price_sale'),
                res[0]
            ))

        total_packages = {}
        sql = """
            SELECT
                SUM(total_cost),
                SUM(weight * quantity),
                SUM(delivery)
            FROM
                data_package
            WHERE
                shipment_id = %(shipment_id)i
        """ % {'shipment_id': self.shipment.id}

        cursor = connection.cursor()
        cursor.execute(sql)
        res = cursor.fetchall()
        if len(res) > 0:
            total_packages = dict(zip(
                ('total_cost', 'weight', 'delivery'), res[0])
            )

        def _sum(d1, d2):
            d = {}
            for k, v1 in d1.items():
                v2 = d2.get(k)
                if v1 is None and v2 is None:
                    d[k] = None
                else:
                    d[k] = (v1 or 0) + (v2 or 0)
            return d

        self.total_row = []
        total = _sum(total, total_packages)
        for f in self.CLIENT_FIELDS:
            field_name = f[2].split("__")[0]
            if field_name[:2] == "po":
                self.total_row.append(u"Итого:")
            else:
                self.total_row.append(total.get(field_name, u""))

        if order_by:
            qs = qs.order_by(order_by)

        self.paginator = SimplePaginator(self.request, qs, self.items_per_page, 'page')
        return self.paginator.get_page_items()

    def get_total_row(self):
        for f in self.total_row:
            yield f


@login_required
@render_to('client/shipment.html')
def shipment(request, shipment_id):
    shipment = get_object_or_404(Shipment, id=shipment_id)
    response = {}
    cl = ClientShipmentOrderItemList(request, OrderedItemsFilterForm, shipment)
    response['cl'] = cl
    response['paginator'] = cl.paginator
    response['items_per_page'] = cl.items_per_page
    response['period'] = cl.period
    response['shipment'] = shipment
    response['qs_filter_param'] = cl.filter.get_filters()
    return response


class ClientBalanceList(object):
    def __init__(self, request, filter_form):
        self.request = request
        self.filter = QSFilter(request, filter_form)
        self.session_store_prefix = "client_balance"
        self.items_per_page = get_items_per_page(request, self.session_store_prefix)
        self.period, self.period_filter = get_period(request, self.session_store_prefix, "created_at", "a")
        self.show_preinvoices = get_show_preinvoices(request, self.session_store_prefix)
        self.results = self.result_list()
        self.headers = self.list_headers()
        self.filters = self.list_filters()

    def result_list(self):
        return self.get_query_set()

    def list_headers(self):
        sort_headers = SortHeaders(self.request, [(x[0], x[1]) for x in BALANCE_CLIENT_FIELD_LIST_CLIENT])
        return list(sort_headers.headers())

    def list_filters(self):
        def _inner():
            for x in BALANCE_CLIENT_FIELD_LIST_CLIENT:
                try:
                    form_field = self.filter.form.__getitem__(x[3])
                    yield form_field
                except Exception:
                    yield ""

        return list(_inner())

    def get_query_set(self):
        order_field = self.request.GET.get('o', None)
        order_direction = self.request.GET.get('ot', None)

        order_by = '-created_at'
        if order_field:
            if order_direction == 'desc':
                order_direction = '-'
            else:
                order_direction = ''
            order_by = order_direction + BALANCE_CLIENT_FIELD_LIST_CLIENT[int(order_field)][1]

        qs = (
            BalanceItem.objects.select_related()
            .filter(user=self.request.user)
            .filter(**self.filter.get_filters())
        )

        if self.period_filter:
            qs = qs.filter(**self.period_filter)

        if not self.show_preinvoices:
            qs = qs.exclude(item_type=BALANCEITEM_TYPE_PREINVOICE)

        if order_by:
            qs = qs.order_by(order_by)

        self.total_amount = sum(x.amount for x in qs)

        self.paginator = SimplePaginator(self.request, qs, self.items_per_page, 'page')
        return self.paginator.get_page_items()


@login_required
@render_to('client/balance.html')
def balance(request):
    response = {}
    cl = ClientBalanceList(request, BalanceClientFilterForm)
    response['cl'] = cl
    response['paginator'] = cl.paginator
    response['items_per_page'] = cl.items_per_page
    response['period'] = cl.period
    response['shipments'] = shipments
    response['qs_filter_param'] = cl.filter.get_filters()
    response['show_preinvoices'] = get_show_preinvoices(
        request, cl.session_store_prefix)
    return response


@render_to('client/help/list.html')
def help_area_list(request, brandgroup_id):
    try:
        area = BrandGroup.objects.get(id=brandgroup_id).area.all()
    except BrandGroup.DoesNotExist:
        area = []

    return {'list': area}


@render_to('client/help/list.html')
def help_brands_list(request, area_id):
    try:
        brands = Area.objects.get(id=area_id).brands.all().order_by('title')
    except Area.DoesNotExist:
        brands = []

    return {'list': brands}


@login_required
def export_order(request):
    LIST_HEADERS = (
        (u'PO', 'po_verbose'),
        (u'Направление', 'brandgroup'),
        (u'Поставщик', 'brand'),
        (u'BRAND', 'area'),
        (u'PART #', 'part_number'),
        (u'ЗАМЕНА', 'part_number_superseded'),
        (u'Q', 'quantity'),
        (u'RUS', 'description_ru'),
        (u'ENG', 'description_en'),
        (u'Комментарий', 'comment_customer'),
        (u'WEIGHT', 'weight'),
        (u'SHIPPING', 'delivery'),
        (u'PRICE', 'price_sale'),
        (u'NEW PRICE', 'price_discount'),
        (u'COST', 'cost'),
        (u'TOTAL', 'total_cost'),
        (u'Инвойс', 'invoice_code'),
        (u'Статус', 'status'),
    )

    def get_list_headers():
        try:
            fields = request.user.get_profile().get_order_fields()
        except Exception:
            fields = None
        if fields:
            return [(x[0], x[1]) for x in LIST_HEADERS if x[1] in fields]
        return LIST_HEADERS

    _filter = QSFilter(request, OrderedItemsFilterForm, clear_old=False)

    orders = OrderedItem.objects.select_related() \
                        .filter(client=request.user) \
                        .filter(**_filter.get_filters()) \
                        .order_by('brandgroup__direction__po', 'ponumber')

    filename = os.path.join(settings.MEDIA_ROOT, 'temp.xls')
    book = pyExcelerator.Workbook()
    sheet = book.add_sheet('ORDERS')

    i = 0
    curr_line = 0
    for key, value in get_list_headers():
        sheet.write(curr_line, i, key)
        i += 1

    for order in orders:
        i = 0
        curr_line += 1
        for key, value in get_list_headers():
            value = getattr(order, value) or ''
            try:
                sheet.write(curr_line, i, value)
                i += 1
            except AssertionError:
                value = unicode(value)
                sheet.write(curr_line, i, value)
                i += 1

    book.save(filename)
    os.chmod(filename, 0777)
    content = open(filename, 'rb').read()
    response = HttpResponse(content, mimetype='application/vnd.ms-excel')
    name = '%s-%s.xls' % ('orders', datetime.datetime.now().strftime('%m-%d-%Y-%H-%M'))
    response['Content-Disposition'] = 'inline; filename=%s' % name
    os.remove(filename)
    return response
