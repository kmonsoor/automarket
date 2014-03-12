# -*- coding=UTF-8 -*-
import os
import re
import pyExcelerator as xl
from datetime import datetime
import dateutil
from django.contrib.auth.decorators import login_required
from lib.decorators import render_to
from lib.paginator import SimplePaginator
from lib.sort import SortHeaders
from lib.qs_filter import QSFilter
from data.models import (
    OrderedItem, Brand, BrandGroup, Area, Basket,
    Shipment, Package, BalanceItem, search_local, search_analogs
)
from data.forms import OrderedItemsFilterForm, ShipmentsFilterForm, BalanceClientFilterForm
from client.forms import SearchForm
from common.views import PartSearch
from django.shortcuts import get_object_or_404
from django.contrib import messages
from django.contrib.auth.models import User
from django.utils.html import escape, mark_safe

from data.settings import AREA_MULTIPLIER_DEFAULT, AREA_DISCOUNT_DEFAULT, COST_MARGIN_DEFAULT
from data.forms import CLIENT_FIELD_LIST, CLIENT_SHIPMENTS_FIELD_LIST, BALANCE_CLIENT_FIELD_LIST_CLIENT
from django.http import HttpResponse, HttpResponseRedirect
from django.conf import settings
from client.forms import BasketForm

from django.db import connection

re_RUS = re.compile(u'^([-_+.,:;!?><*&%$#@а-яА-Я0-9\u0451\u0401]|\s)+$')


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
        now = datetime.now()
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


def normalize_sum(value):
    value = str(value)
    value = value.replace(',', '.')
    parts = value.split(".")
    m, d = parts[0:-1], parts[-1]
    value = "".join(m) + "." + d
    return value


def calc_part(part, user, render_for_template=True):
    if not part.get('MSRP'):
        return None

    # try to find area and get multiplier
    try:
        # find an area by title
        area = Area.objects.get(title__iexact=part['brandname'])
        brand_group = BrandGroup.objects.get(title=part['brandgroup'])
        # we need to find a valid multiplier for this area
        # TODO - hardcoded 'OEM', we need do more sofisticated algo
    except (BrandGroup.DoesNotExist, Area.DoesNotExist, Area.MultipleObjectsReturned, ValueError):
        # not price_setings for OEM and this area
        m, d, dp, pu, cm, brand_group, area = (
            AREA_MULTIPLIER_DEFAULT, None, None, None, COST_MARGIN_DEFAULT, None, None)
    else:
        m, d, dp, pu, cm = area.get_brandgroup_settings(brand_group)

    part['delivery_coef'] = d
    part['delivery_period'] = dp
    part['updated_at'] = pu
    part['area_id'] = area and area.id or None
    part['direction_id'] = brand_group and brand_group.direction.id or None
    part['brandgroup_id'] = brand_group and brand_group.id or None

    try:
        discount = user.get_profile().get_discount(brand_group=brand_group, area=area)
    except Exception:
        discount = AREA_DISCOUNT_DEFAULT
    discount = float(discount)

    # we need to remove all "," as separators
    # only last dot should be saved
    value = float(normalize_sum(str(part['MSRP'])))

    part['MSRP'] = value * float(m)
    if 'cost' in part and part['cost']:
        _msrp = part['cost'] * cm
        if _msrp > part['MSRP']:
            part['MSRP'] = _msrp

    try:
        part['core_price'] = float(normalize_sum(str(part['core_price'])))
    except:
        part['core_price'] = 0.00

    part['your_price'] = part['MSRP'] * (100 - discount) / 100
    part['your_economy'] = part['MSRP'] - part['your_price']
    part['your_economy_perc'] = 100 - part['your_price'] / part['MSRP'] * 100

    if render_for_template:
        part['core_price'] = "%.2f" % part['core_price']
        part['your_economy_perc'] = "%.2f" % part['your_economy_perc']
        part['MSRP'] = "%.2f" % part['MSRP']
        part['your_price'] = "%.2f" % part['your_price']
        part['your_economy'] = "%.2f" % part['your_economy']

        if len(part.get('sub_chain', [])) > 1:
            last = part['sub_chain'].pop(-1)
            part['sub_chain'] = mark_safe(
                u"Номер заменён: "
                + " -> ".join(part['sub_chain'])
                + " -> <b>%s</b>" % last)
        else:
            part.pop('sub_chain', None)

    return part


def calc_parts(parts, user, render_for_template=True):
    data = []
    for part in parts:
        if not part.get('MSRP'):
            continue
        data.append(calc_part(part, user, render_for_template))
    return data


@login_required
@render_to('client/search.html')
def search(request):
    parts = []
    analogs = []
    msg = ''

    search_external = PartSearch()
    maker_choices = search_external.maker_choices()
    show_maker_field = False

    if request.method == 'POST':
        _post = request.POST.copy()
        _post['part_number'] = re.sub('[^\w]', '', _post['part_number']).strip().upper()
        form = SearchForm(_post, maker_choices=maker_choices)
        if form.is_valid():
            maker = form.cleaned_data['maker']
            part_number = form.cleaned_data['part_number']

            founds = search_local(maker, part_number)
            if founds:
                makers = set(x['maker'] for x in founds)
                if len(makers) > 1:
                    show_maker_field = True
                    form.fields['maker'].widget.choices = [
                        ('', '----')] + list((x, x) for x in makers)
                else:
                    parts = calc_parts(founds, request.user)
            else:
                show_maker_field = True
                if maker:
                    founds = search_external.search(maker, part_number)
                    if founds:
                        parts = calc_parts(founds, request.user)
                    else:
                        msg = u"Ничего не найдено"

            if founds:
                analog_founds = search_analogs(founds)
                analogs = calc_parts(analog_founds, request.user)
                
    else:
        form = SearchForm(maker_choices=maker_choices)

    context = {
        'form': form,
        'data': parts,
        'analogs': analogs,
        'msg': msg,
        'show_maker_field': show_maker_field,
    }

    context['basket_items'] = Basket.objects\
        .filter(user=request.user, order_item_id__isnull=True)\
        .order_by('-id')

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

        if self.request.REQUEST.get('exclude_shipment'):
            filters.update({'shipment__isnull': True})

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
        session_store_prefix = "client_balance"
        self.items_per_page = get_items_per_page(request, session_store_prefix)
        self.period, self.period_filter = get_period(request, session_store_prefix, "created_at", "a")
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
        (u'Q', 'quantity'),
        (u'ЗАМЕНА', 'part_number_superseded'),
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
    book = xl.Workbook()
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
    name = '%s-%s.xls' % ('orders', datetime.now().strftime('%m-%d-%Y-%H-%M'))
    response['Content-Disposition'] = 'inline; filename=%s' % name
    os.remove(filename)
    return response


@login_required
def basket_add(request):
    user = request.user
    form = BasketForm(request.POST or None, user=user)

    if not form.is_valid():
        messages.add_message(request, messages.ERROR, u"Ошибка корзины")
        return HttpResponseRedirect("/client/search/?be=1")
    else:
        form.save()
        return HttpResponseRedirect("/client/search/")


@login_required
def basket_delete(request, item_id):
    b = get_object_or_404(Basket, user=request.user, pk=item_id)
    b.delete()
    return HttpResponseRedirect('/client/search/')


@login_required
def basket_clear(request):
    Basket.objects.filter(user=request.user, order_item_id__isnull=True).delete()
    return HttpResponseRedirect("/client/search/")


def description_ru_validate(value=None):
    if value and re_RUS.match(value):
        return True
    return False


@login_required
def basket_update(request, redirect=True):
    bitems = [(x, y) for x, y in request.POST.copy().items() if x.startswith("quantity_")]
    errors = {'quantity': False, 'description_ru': False, 'comment1': False}
    # quantity
    for index, q in bitems:
        try:
            q = int(q)
            assert q >= 0
            item_id = int(index.split("_")[1])
            b = Basket.objects.get(user=request.user, pk=item_id)
        except (AssertionError, TypeError, ValueError, IndexError, Basket.DoesNotExist):
            errors['quantity'] = True
        else:
            b.quantity = q
            b.save()

    # find description RUS
    descriptions = [(x, y) for x, y in request.POST.copy().items() if x.startswith("descriptionru_")]
    for index, value in descriptions:
        try:
            item_id = int(index.split("_")[1])
            assert description_ru_validate(value) is True

            b = Basket.objects.get(user=request.user, pk=item_id)
            b.description_ru = value
            b.save()
        except (AssertionError, TypeError, ValueError, Basket.DoesNotExist):
            errors['description_ru'] = True

    # find comments
    comments = [(x, y) for x, y in request.POST.copy().items() if x.startswith("comment1_")]

    for index, value in [(x, y) for x, y in comments if y]:
        item_id = index.split("_")[1]
        try:
            b = Basket.objects.get(user=request.user, pk=item_id)
            b.comment1 = escape(value)
            b.save()
        except Basket.DoesNotExist:
            pass

    if errors['quantity']:
        messages.add_message(request, messages.ERROR, u"Количество должно быть больше 0. Проверьте позиции")
    if errors['description_ru']:
        messages.add_message(request, messages.ERROR, u"Поле `Описание RUS` должно быть заполнено русскими буквами для каждой позиции. Пожалуйста, проверьте!")

    if redirect:
        return HttpResponseRedirect("/client/search/")
    else:
        return not any(errors.values())


@login_required
def basket_order(request):
    # recalculate by quantity field
    ok = basket_update(request, redirect=False)
    if not ok:
        return HttpResponseRedirect('/client/search/')

    bi = Basket.objects.filter(user=request.user, order_item_id__isnull=True)
    if not bi:
        messages.add_message(request, messages.ERROR, u"Ваша корзина пуста")
        return HttpResponseRedirect('/client/search/')
    # common objects
    adminuser = User.objects.get(pk=1)
    brandgroup_default = BrandGroup.objects.get(title="OEM")

    def get_orderitem_data(item):
        data = {}

        if all([item.brandgroup, item.area, item.brand_name]):
            data['brandgroup'] = BrandGroup.objects.get(title__iexact=item.brandgroup)
            data['area'] = Area.objects.get(title__iexact=item.area)
            data['brand'] = Brand.objects.get(title__iexact=item.brand_name)
        else:  # remove it
            sql = """
            select a.area_id, a.brand_id from data_area_brands a
            left join data_brand b on (b.id=a.brand_id)
            left join data_area c on (c.id=a.area_id)
            where c.id in (select area_id from data_brandgroup_area where brandgroup_id=%s)
            and b.title=%s;
            """
            cursor = connection.cursor()
            cursor.execute(sql, [brandgroup_default.id, item.brand_name])
            rows = cursor.fetchall()
            cursor.close()

            if not rows:
                return (None, item)
            row = dict(zip(('area_id', 'brand_id'), rows[0]))
            data['brandgroup'] = brandgroup_default
            data['area'] = Area.objects.get(pk=row['area_id'])
            data['brand'] = Brand.objects.get(pk=row['brand_id'])

        data['description_en'] = item.description
        data['description_ru'] = item.description_ru or u""
        data['comment_customer'] = item.comment1 or u""
        data['client'] = request.user
        data['quantity'] = item.quantity
        data['part_number'] = item.part_number
        data['manager'] = adminuser
        data['price_base'] = item.msrp
        data['price_sale'] = item.get_price()
        return (data, item)

    to_save = [x for x in map(get_orderitem_data, list(bi)) if x[0]]
    client_order_id = OrderedItem.objects.get_next_client_order_id(request.user)

    for t, item in to_save:
        oi = OrderedItem(**t)
        oi.client_order_id = client_order_id
        oi.save()
        item.order_item_id = oi.id
        item.save()

    messages.add_message(request, messages.SUCCESS, u"Заказ оформлен")
    return HttpResponseRedirect("/client/")
