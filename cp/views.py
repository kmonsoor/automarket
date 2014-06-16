# -*- coding=utf-8 -*-
import os
import mechanize
import cjson
import pyExcelerator as xl
from datetime import datetime
import string
import random
import dateutil
from itertools import groupby

from django.core import serializers
from django.core.mail import send_mail
from django.core.urlresolvers import reverse
from django.contrib.auth.models import User
from django.contrib import messages
from django.contrib.admin.views.decorators import staff_member_required
from django.shortcuts import get_object_or_404
from django.http import Http404, HttpResponseRedirect, HttpResponse
from django.utils.datastructures import MultiValueDict
from django.conf import settings
from django.template.loader import render_to_string
from django.template import RequestContext

from lib.decorators import render_to, ajax_request
from lib.paginator import SimplePaginator
from lib.sort import SortHeaders
from lib.qs_filter import QSFilter
from lib import xlsreader

from cp.forms import OrderItemForm

from client.forms import SearchForm

from data.models import (
    BrandGroup, Brand, OrderedItem, ORDER_ITEM_STATUSES,
    Invoice, Package, INVOICE_STATUS_RECEIVED, INVOICE_STATUS_CLOSED,
    PACKAGE_STATUSES, PACKAGE_STATUS_RECEIVED, PACKAGE_STATUS_ISSUED,
    Shipment, BalanceItem, UserProfile, BALANCEITEM_TYPE_PAYMENT,
    BALANCEITEM_TYPE_INVOICE, MAP_STATUS_ORDER_TO_INVOICE
)
from data.forms import (
    OrderedItemsFilterForm, OrderedItemForm, STAFF_FIELD_LIST,
    InvoicesFilterForm, INVOICES_FIELD_LIST, PackageForm,
    ShipmentsFilterForm, SHIPMENTS_FIELD_LIST, BalanceFilterForm,
    BALANCE_FIELD_LIST, BalanceClientFilterForm, BALANCE_CLIENT_FIELD_LIST,
    PackageItemForm, BalanceAddForm, ImportOrderXlsForm
)
from common.views import PartSearch

import logging
logger = logging.getLogger("cp.views")


@staff_member_required
@render_to('cp/search.html')
def search(request):
    founds = []
    maker_name = None
    msg = ''
    search_class = PartSearch()

    maker_choices = search_class.maker_choices()
    if request.method == 'POST':
        form = SearchForm(request.POST, maker_choices=maker_choices)
        if form.is_valid():
            maker = form.cleaned_data['maker']
            part_number = form.cleaned_data['part_number']
            founds = search_class.search(maker, part_number)
            if not founds:
                msg = u"Not Found"
            maker_name = form.cleaned_data['maker']
    else:
        form = SearchForm(maker_choices=maker_choices)

    return {'form': form, 'data': founds, 'maker_name': maker_name, 'msg': msg}


def get_status_options():
    statuses_dict = ORDER_ITEM_STATUSES
    status_options_str = '{'
    status_options = []
    k = 0
    for i in statuses_dict:
        k += 1
        status_options_str += '"%s":"%s"' % (i[0], i[1])
        status_options.append({'value': i[0], 'option': i[1]})
        if k < len(ORDER_ITEM_STATUSES):
            status_options_str += ','
    status_options_str += '}'
    return (status_options_str, status_options)


def get_status_options_package():
    return [{'value': i[0], 'option': i[1]} for i in PACKAGE_STATUSES]


def get_period(request, prefix, field, period=''):
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
    PERIOD_PARAM_DEFAULT = period or PERIOD_PARAM_YEAR

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
        if period == PERIOD_PARAM_WEEK:
            rated_period = now + dateutil.relativedelta.relativedelta(
                weeks=-1, weekday=dateutil.relativedelta.calendar.SATURDAY,
                hour=0, minute=0, second=0, microsecond=0)
        elif period == PERIOD_PARAM_MONTH:
            rated_period = now + dateutil.relativedelta.relativedelta(
                day=1, hour=0, minute=0, second=0, microsecond=0)
        elif period == PERIOD_PARAM_YEAR:
            rated_period = now + dateutil.relativedelta.relativedelta(
                month=1, day=1, hour=0, minute=0, second=0, microsecond=0)
        elif period == PERIOD_PARAM_ALL:
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


def ordering(qs, request, list_headers):
    order_field = request.GET.get('o', None)
    order_direction = request.GET.get('ot', None)
    order_by = '-created_at'

    if order_field:
        if order_direction == 'desc':
            order_direction = '-'
        else:
            order_direction = ''
        order_by = order_direction + list_headers[int(order_field)][1]

    if order_by:
        qs = qs.order_by(order_by)

    return qs


def get_list_filters(_filter, _list_filters):
    list_filters = []
    for x in _list_filters:
        try:
            form_field = _filter.form.__getitem__(x[3])
            list_filters.append(form_field)
        except Exception:
            list_filters.append("")
    return list_filters


@staff_member_required
@render_to('cp/invoices.html')
def invoices(request):
    context = {}
    session_store_prefix = "cp_invoices"

    _filter = QSFilter(request, InvoicesFilterForm)
    context['filter'] = _filter

    LIST_HEADERS = [(x[0], x[1]) for x in INVOICES_FIELD_LIST]
    sort_headers = SortHeaders(request, LIST_HEADERS)
    context['headers'] = list(sort_headers.headers())

    list_filters = []
    for x in INVOICES_FIELD_LIST:
        try:
            form_field = _filter.form.__getitem__(x[3])
            list_filters.append(form_field)
        except Exception:
            list_filters.append("")
    context['list_filters'] = list_filters

    qs_filter = _filter.get_filters()

    period, period_filter = get_period(request, session_store_prefix, "received_at")
    qs_filter.update(period_filter)
    context['period'] = period

    qs = Invoice.objects.select_related().filter(**qs_filter)

    order_field = request.GET.get('o', None)
    order_direction = request.GET.get('ot', None)
    order_by = '-received_at'
    if order_field:
        if order_direction == 'desc':
            order_direction = '-'
        else:
            order_direction = ''
        order_by = order_direction + LIST_HEADERS[int(order_field)][1]
    if order_by:
        qs = qs.order_by(order_by)

    items_per_page = get_items_per_page(request, session_store_prefix)
    context['items_per_page'] = items_per_page
    paginator = SimplePaginator(request, qs, items_per_page, 'page')
    context['items'] = paginator.get_page_items()
    context['paginator'] = paginator

    return context


@staff_member_required
@render_to('cp/shipments.html')
def shipments(request):
    context = {}
    session_store_prefix = "cp_shipments"

    _filter = QSFilter(request, ShipmentsFilterForm)
    context['filter'] = _filter

    LIST_HEADERS = [(x[0], x[1]) for x in SHIPMENTS_FIELD_LIST]
    sort_headers = SortHeaders(request, LIST_HEADERS)
    context['headers'] = list(sort_headers.headers())

    try:
        user_fields = request.user.get_profile().get_order_fields()
    except Exception:
        user_fields = None
    if user_fields:
        STAFF_FIELDS = [x for x in STAFF_FIELD_LIST if x[2] in user_fields]
    else:
        STAFF_FIELDS = STAFF_FIELD_LIST
    context['staff_fields'] = [x[2] for x in STAFF_FIELDS]

    list_filters = []
    for x in SHIPMENTS_FIELD_LIST:
        try:
            form_field = _filter.form.__getitem__(x[3])
            list_filters.append(form_field)
        except Exception:
            list_filters.append("")
    context['list_filters'] = list_filters

    qs_filter = _filter.get_filters()

    period, period_filter = get_period(request, session_store_prefix, "created_at")
    qs_filter.update(period_filter)
    context['period'] = period

    qs = Shipment.objects.select_related().filter(**qs_filter)

    order_field = request.GET.get('o', None)
    order_direction = request.GET.get('ot', None)
    order_by = '-created_at'
    if order_field:
        if order_direction == 'desc':
            order_direction = '-'
        else:
            order_direction = ''
        order_by = order_direction + LIST_HEADERS[int(order_field)][1]
    if order_by:
        qs = qs.order_by(order_by)

    items_per_page = get_items_per_page(request, session_store_prefix)
    context['items_per_page'] = items_per_page
    paginator = SimplePaginator(request, qs, items_per_page, 'page')
    context['items'] = paginator.get_page_items()
    context['paginator'] = paginator

    return context


@staff_member_required
@render_to('cp/shipment.html')
def shipment(request, shipment_id):
    shipment = get_object_or_404(Shipment, id=shipment_id)
    context = {}
    session_store_prefix = "cp_shipment"

    if request.method == 'POST':
        if 'delete_shipment' in request.POST:
            if not request.user.check_password(request.POST.get('password')):
                msg = u"Неверный пароль."
                messages.add_message(request, messages.ERROR, msg)
                return _redirect_after_post(reverse("shipment", args=[shipment.id]))

            shipment._delete()
            messages.add_message(request, messages.SUCCESS, u"Отгрузка отменена.")
            return HttpResponseRedirect(reverse("shipments"))

    _filter = QSFilter(request, OrderedItemsFilterForm)
    context['filter'] = _filter
    context['qs_filter_param'] = _filter.get_filters()

    try:
        user_fields = request.user.get_profile().get_order_fields()
    except Exception:
        user_fields = None
    if user_fields:
        STAFF_FIELDS = [x for x in STAFF_FIELD_LIST if x[2] in user_fields]
    else:
        STAFF_FIELDS = STAFF_FIELD_LIST
    context['staff_fields'] = [x[2] for x in STAFF_FIELDS]
    LIST_HEADERS = [(x[0], x[1]) for x in STAFF_FIELDS]

    sort_headers = SortHeaders(request, LIST_HEADERS)
    order_field = request.GET.get('o', None)
    order_direction = request.GET.get('ot', None)

    list_filters = []
    for x in STAFF_FIELDS:
        try:
            form_field = _filter.form.__getitem__(x[3])
            list_filters.append(form_field)
        except Exception:
            list_filters.append("")
    context['list_filters'] = list_filters

    order_by = '-created'
    if order_field:
        if order_direction == 'desc':
            order_direction = '-'
        else:
            order_direction = ''
        order_by = order_direction + LIST_HEADERS[int(order_field)][1]

    context['headers'] = list(sort_headers.headers())

    qs_filter = _filter.get_filters()

    qs_filter.update({'shipment__id': shipment.id})

    qs = OrderedItem.objects.select_related().filter(**qs_filter)

    context['packages'] = Package.objects.filter(
        shipment__id=shipment.id
    ).order_by('-created_at')

    # calculate totals by filter
    from django.db import connection
    total = {}
    td = "U0"
    q, params = qs._as_sql(connection)
    from_clause = q.split("FROM")[1]

    where = from_clause.split("WHERE")
    if len(where) > 1:
        from_clause = where[0]
        where = [where[1]]
    else:
        where = []
    where.append("%s.status NOT IN ('failure', 'wrong_number', 'out_of_stock', 'cancelled_customer', 'export_part')" % td)
    where = "WHERE %s" % "AND ".join(where)

    sql = """
        SELECT
            SUM(%(p)s.total_cost),
            SUM(%(p)s.weight*%(p)s.quantity),
            SUM(%(p)s.delivery),
            SUM(%(p)s.quantity*COALESCE(%(p)s.price_discount, %(p)s.price_sale, 0)),
            SUM(%(p)s.price_invoice*%(p)s.quantity),
            SUM(%(p)s.price_manager),
            SUM(%(p)s.total_manager)
            FROM %(from)s %(where)s
    """ % {'p': td, 'from': from_clause, 'where': where}
    cursor = connection.cursor()
    cursor.execute(sql, params)
    res = cursor.fetchall()
    if len(res) > 0:
        total.update(dict(zip(
            (
                'total_cost', 'weight', 'delivery', 'price_sale',
                'price_invoice', 'price_manager', 'total_manager'), res[0])
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
    """ % {'shipment_id': shipment.id}

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

    total_row = []
    total = _sum(total, total_packages)
    for f in STAFF_FIELDS:
        field_name = f[2].split("__")[0]
        if field_name[:2] == "po":
            total_row.append(u"Итого:")
        else:
            total_row.append(total.get(field_name, u""))
    context['total_row'] = total_row

    if order_by:
        qs = qs.order_by(order_by)

    items_per_page = get_items_per_page(request, session_store_prefix)
    context['items_per_page'] = items_per_page
    paginator = SimplePaginator(request, qs, items_per_page, 'page')

    context['status_options_str'], context['status_options'] = get_status_options()
    context['status_options_package'] = get_status_options_package()
    context['items'] = paginator.get_page_items()
    context['paginator'] = paginator
    context['brands'] = ','.join(['{"id":%s,"name":"%s"}' % (brand.id, brand.title) for brand in Brand.objects.all()])
    context['total_row'] = total_row
    context['shipment'] = shipment
    return context


@staff_member_required
@ajax_request
def remove_package(request):
    try:
        ids = [int(x) for x in request.POST.get('ids').split(',')]
        if not bool(len(ids)):
            raise ValueError
    except:
        return {'success': False, 'error': 'invalid data'}
    else:
        Package.objects.filter(id__in=ids).delete()
        return {'success': True}


def _random():
    yield "".join([random.choice(string.letters) for x in xrange(1, 5)])


def _redirect_after_post(url):
    return HttpResponseRedirect(
        "%s?%s=%s" % (url, _random().next(), _random().next())
    )


@staff_member_required
@render_to('cp/invoice.html')
def invoice(request, invoice_id):
    invoice = get_object_or_404(Invoice, id=invoice_id)
    context = {'invoice': invoice}
    session_store_prefix = "cp_invoice"

    _filter = QSFilter(request, OrderedItemsFilterForm)
    context['filter'] = _filter
    context['qs_filter_param'] = _filter.get_filters()

    try:
        user_fields = request.user.get_profile().get_order_fields()
    except Exception:
        user_fields = None
    if user_fields:
        STAFF_FIELDS = [x for x in STAFF_FIELD_LIST if x[2] in user_fields]
    else:
        STAFF_FIELDS = STAFF_FIELD_LIST
    context['staff_fields'] = [x[2] for x in STAFF_FIELDS]
    LIST_HEADERS = [(x[0], x[1]) for x in STAFF_FIELDS]

    sort_headers = SortHeaders(request, LIST_HEADERS)
    order_field = request.GET.get('o', None)
    order_direction = request.GET.get('ot', None)

    list_filters = []
    for x in STAFF_FIELDS:
        try:
            form_field = _filter.form.__getitem__(x[3])
            list_filters.append(form_field)
        except Exception:
            list_filters.append("")
    context['list_filters'] = list_filters

    order_by = '-created'
    if order_field:
        if order_direction == 'desc':
            order_direction = '-'
        else:
            order_direction = ''
        order_by = order_direction + LIST_HEADERS[int(order_field)][1]

    context['headers'] = list(sort_headers.headers())

    order_statuses = list(
        OrderedItem.objects
        .filter(invoice_code=invoice.code)
        .values_list('status', flat=True)
    )

    invoice.calculate_status()

    order_filter = _filter.get_filters()
    package_filter = _filter.get_filters()

    # FIXME
    if 'invoice_code__contains' in package_filter:
        package_filter.update({'invoice__code__contains': package_filter.get('invoice_code__contains')})
        del package_filter['invoice_code__contains']

    if 'description_en__contains' in package_filter:
        del package_filter['description_en__contains']
        package_filter = {'id': 0}

    if 'description_ru__contains' in package_filter:
        del package_filter['description_ru__contains']
        package_filter = {'id': 0}

    if 'part_number_superseded__contains' in package_filter:
        del package_filter['part_number_superseded__contains']
        package_filter = {'id': 0}

    if 'comment_supplier__contains' in package_filter:
        del package_filter['comment_supplier__contains']
        package_filter = {'id': 0}

    if 'comment_customer__contains' in package_filter:
        del package_filter['comment_customer__contains']
        package_filter = {'id': 0}

    if 'part_number__contains' in package_filter:
        del package_filter['part_number__contains']
        package_filter = {'id': 0}

    if 'brand__title__contains' in package_filter:
        del package_filter['brand__title__contains']
        package_filter = {'id': 0}

    if 'area__title__contains' in package_filter:
        del package_filter['area__title__contains']
        package_filter = {'id': 0}

    if 'brandgroup__title__contains' in package_filter:
        del package_filter['brandgroup__title__contains']
        package_filter = {'id': 0}

    if 'brandgroup__direction__po__icontains' in package_filter:
        del package_filter['brandgroup__direction__po__icontains']
        package_filter = {'id': 0}

    if 'status' in package_filter:
        package_filter['status'] = dict(MAP_STATUS_ORDER_TO_INVOICE).get(package_filter['status'], 0)

    context['packages'] = Package.objects.filter(invoice=invoice, **package_filter).order_by('-created_at')

    qs = OrderedItem.objects.select_related()\
        .filter(**order_filter)\
        .filter(invoice_code=invoice.code)

    # calculate totals by filter
    from django.db import connection
    total = {}
    td = "U0"
    q, params = qs._as_sql(connection)
    from_clause = q.split("FROM")[1]

    where = from_clause.split("WHERE")
    if len(where) > 1:
        from_clause = where[0]
        where = [where[1]]
    else:
        where = []
    where.append("%s.status NOT IN ('failure', 'wrong_number', 'out_of_stock', 'cancelled_customer', 'export_part')" % td)
    where = "WHERE %s" % "AND ".join(where)

    sql = """
        SELECT
            SUM(%(p)s.total_cost),
            SUM(%(p)s.weight*%(p)s.quantity),
            SUM(%(p)s.delivery),
            SUM(%(p)s.quantity*COALESCE(%(p)s.price_discount, %(p)s.price_sale, 0)),
            SUM(%(p)s.price_invoice*%(p)s.quantity),
            SUM(%(p)s.price_manager),
            SUM(%(p)s.total_manager)
            FROM %(from)s %(where)s
    """ % {'p': td, 'from': from_clause, 'where': where}
    cursor = connection.cursor()
    cursor.execute(sql, params)
    res = cursor.fetchall()
    if len(res) > 0:
        total.update(dict(zip(
            (
                'total_cost', 'weight', 'delivery', 'price_sale', 'price_invoice',
                'price_manager', 'total_manager'), res[0])
        ))

    total_packages = {}
    if context['packages']:
        sql = """
            SELECT
                SUM(total_cost),
                SUM(weight * quantity),
                SUM(delivery)
            FROM
                data_package
            WHERE
                id IN (%(packages)s)
        """ % {'packages': ",".join("%s" % x.id for x in context['packages'])}

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

    total_row = []
    total = _sum(total, total_packages)
    for f in STAFF_FIELDS:
        field_name = f[2].split("__")[0]
        if field_name[:2] == "po":
            total_row.append(u"Итого:")
        else:
            total_row.append(total.get(field_name, u""))
    context['total_row'] = total_row

    if order_by:
        qs = qs.order_by(order_by)

    items_per_page = get_items_per_page(request, session_store_prefix)
    context['items_per_page'] = items_per_page
    paginator = SimplePaginator(request, qs, items_per_page, 'page')

    context['status_options_str'], context['status_options'] = get_status_options()
    context['status_options_package'] = get_status_options_package()
    context['items'] = paginator.get_page_items()
    context['paginator'] = paginator
    context['brands'] = ','.join(['{"id":%s,"name":"%s"}' % (brand.id, brand.title) for brand in Brand.objects.all()])

    package_data = []
    form_packages_is_valid = True
    if request.method == 'POST':
        redirect_url = reverse("invoice", args=[invoice.id])

        if 'save_package' in request.POST:
            package_forms = PackageItemForm.get_forms(request)
            package_data = [package_form.render_js('from_template') for package_form in package_forms]
            if package_forms.are_valid():
                for form in package_forms:
                    data = form.cleaned_data
                    data['manager'] = request.user
                    data['invoice'] = invoice
                    Package(**data).save()
                messages.add_message(request, messages.SUCCESS, u"Упаковка добавлена.")
                return _redirect_after_post(redirect_url)
            form_packages_is_valid = False

        elif 'close_invoice' in request.POST:
            if not request.user.check_password(request.POST.get('password')):
                msg = u"Неверный пароль."
                messages.add_message(request, messages.ERROR, msg)
                return _redirect_after_post(redirect_url)

            statuses_to_close = ('received_office', 'not_obtained_from_supplier', 'issued')
            if not all(map(lambda x: x in statuses_to_close, order_statuses)):
                msg = u"Вы не можете закрыть инвойс. Не все позиции получены."
                messages.add_message(request, messages.ERROR, msg)
                return _redirect_after_post(redirect_url)

            OrderedItem.objects.filter(invoice_code=invoice.code).update(editable=False)
            Package.objects.filter(invoice=invoice).update(editable=False)
            invoice.status = INVOICE_STATUS_CLOSED
            invoice.closed_at = datetime.now()
            invoice.save()
            messages.add_message(request, messages.SUCCESS, u"Инвойс закрыт.")
            return _redirect_after_post(redirect_url)

        elif 'open_invoice' in request.POST:
            if not request.user.check_password(request.POST.get('password')):
                msg = u"Неверный пароль."
                messages.add_message(request, messages.ERROR, msg)
                return _redirect_after_post(redirect_url)

            if invoice.status == INVOICE_STATUS_CLOSED:
                OrderedItem.objects.filter(invoice_code=invoice.code).update(editable=True)
                Package.objects.filter(invoice=invoice).update(editable=True)
                invoice.status = INVOICE_STATUS_RECEIVED
                invoice.save()
                messages.add_message(request, messages.SUCCESS, u"Инвойс открыт.")
                return _redirect_after_post(redirect_url)

    context['package_template'] = PackageItemForm().render_js('from_template')
    context['package_data'] = package_data
    context['form_packages_is_valid'] = form_packages_is_valid
    context['is_invoice_page'] = True

    return context


@staff_member_required
@render_to('cp/issues.html')
def issues(request):
    context = {}
    session_store_prefix = "cp_issues"

    if request.method == 'POST':
        redirect_url = reverse("issues")

        if request.POST.get('issued'):
            try:
                order_ids = [int(x) for x in request.POST.get('issued_orders').split(',')]
            except:
                msg = u"Невалидные данные"
                messages.add_message(request, messages.ERROR, msg)
                return _redirect_after_post(redirect_url)
            else:
                orders = list(OrderedItem.objects.filter(id__in=order_ids))
                already = filter(lambda x: x.shipment, orders)
                if already:
                    msg = u"Отгрузка не проведена. Позиции с ORDER ID: %s уже были отгружены." % ", ".join(str(x.id) for x in already)
                    messages.add_message(request, messages.ERROR, msg)
                    return _redirect_after_post(redirect_url)
                shipments = Shipment._create(request, orders)
                msg = u"Успешно отгружены. Количество новых отгрузок: <b>%i</b>." % len(shipments)
                messages.add_message(request, messages.SUCCESS, msg)
                return _redirect_after_post(redirect_url)

    _filter = QSFilter(request, OrderedItemsFilterForm)
    context['filter'] = _filter
    context['qs_filter_param'] = _filter.get_filters()

    try:
        user_fields = request.user.get_profile().get_order_fields()
    except Exception:
        user_fields = None
    if user_fields:
        STAFF_FIELDS = [x for x in STAFF_FIELD_LIST if x[2] in user_fields]
    else:
        STAFF_FIELDS = STAFF_FIELD_LIST
    context['staff_fields'] = [x[2] for x in STAFF_FIELDS]
    LIST_HEADERS = [(x[0], x[1]) for x in STAFF_FIELDS]

    sort_headers = SortHeaders(request, LIST_HEADERS)
    order_field = request.GET.get('o', None)
    order_direction = request.GET.get('ot', None)

    list_filters = []
    for x in STAFF_FIELDS:
        try:
            form_field = _filter.form.__getitem__(x[3])
            list_filters.append(form_field)
        except Exception:
            list_filters.append("")
    context['list_filters'] = list_filters

    order_by = '-created'
    if order_field:
        if order_direction == 'desc':
            order_direction = '-'
        else:
            order_direction = ''
        order_by = order_direction + LIST_HEADERS[int(order_field)][1]

    context['headers'] = list(sort_headers.headers())

    qs = OrderedItem.objects.select_related()\
        .filter(**_filter.get_filters())\
        .filter(status__in=('received_office',))

    # calculate totals by filter
    total_row = []
    if _filter.is_set:
        from django.db import connection

        td = "U0"
        q, params = qs._as_sql(connection)
        from_clause = q.split("FROM")[1]

        where = from_clause.split("WHERE")
        if len(where) > 1:
            from_clause = where[0]
            where = [where[1]]
        else:
            where = []
        where.append("%s.status NOT IN ('failure', 'wrong_number', 'out_of_stock', 'cancelled_customer', 'export_part')" % td)
        where = "WHERE %s" % "AND ".join(where)

        sql = """
            SELECT
                SUM(%(p)s.total_cost),
                SUM(%(p)s.weight*%(p)s.quantity),
                SUM(%(p)s.delivery),
                SUM(%(p)s.quantity*COALESCE(%(p)s.price_discount, %(p)s.price_sale, 0)),
                SUM(%(p)s.price_invoice*%(p)s.quantity)
                SUM(%(p)s.price_manager),
                SUM(%(p)s.total_manager)
                FROM %(from)s %(where)s
        """ % {'p': td, 'from': from_clause, 'where': where}
        cursor = connection.cursor()
        cursor.execute(sql, params)
        res = cursor.fetchall()
        if len(res) > 0:
            total = dict(zip(
                (
                    'total_cost', 'weight', 'delivery', 'price_sale',
                    'price_invoice', 'price_manager', 'total_manager'), res[0])
            )

            for f in STAFF_FIELDS:
                field_name = f[2].split("__")[0]
                if field_name[:2] == "po":
                    total_row.append(u"Итого:")
                else:
                    total_row.append(total.get(field_name, u""))

    if order_by:
        qs = qs.order_by(order_by)

    items_per_page = get_items_per_page(request, session_store_prefix)
    context['items_per_page'] = items_per_page
    paginator = SimplePaginator(request, qs, items_per_page, 'page')

    #paginator.set_page(current_page)
    context['status_options_str'], context['status_options'] = get_status_options()
    context['items'] = paginator.get_page_items()
    context['paginator'] = paginator
    context['brands'] = ','.join(['{"id":%s,"name":"%s"}' % (brand.id, brand.title) for brand in Brand.objects.all()])
    context['total_row'] = total_row
    context['edit_mode'] = 1
    context['issues_mode'] = 1
    return context


@staff_member_required
@render_to('cp/issues_client.html')
def issues_client(request, client_id):
    client = get_object_or_404(User, id=client_id)
    context = {}
    session_store_prefix = "cp_issues_client"

    if request.method == 'POST':
        redirect_url = reverse("issues_client", args=[client_id])

        if request.POST.get('issued'):
            order_ids = request.POST.get('issued_orders')
            package_ids = request.POST.get('issued_packages')
            try:
                if order_ids:
                    order_ids = [int(x) for x in order_ids.split(',')]

                if package_ids:
                    package_ids = [int(x) for x in package_ids.split(',')]
            except:
                msg = u"Невалидные данные"
                messages.add_message(request, messages.ERROR, msg)
                return _redirect_after_post(redirect_url)
            else:
                orders = []
                if order_ids:
                    orders = list(OrderedItem.objects.filter(id__in=order_ids))

                packages = []
                if package_ids:
                    packages = list(Package.objects.filter(id__in=package_ids))

                shipments = Shipment._create(request, orders, packages)

                msg = u"Успешно отгружены. Количество новых отгрузок: <b>%i</b>." % len(shipments)
                messages.add_message(request, messages.SUCCESS, msg)
                return _redirect_after_post(redirect_url)

        if 'save_balance_payment' in request.POST:
            forms = BalanceAddForm.get_forms(request)
            context['balance_payment_form_data'] = [form.render_js('from_template') for form in forms]
            if forms.are_valid():
                for form in forms:
                    data = form.cleaned_data
                    data['user'] = client
                    data['item_type'] = BALANCEITEM_TYPE_PAYMENT
                    BalanceItem(**data).save()
                messages.add_message(request, messages.SUCCESS, u"Оплата добавлена.")
                return _redirect_after_post(redirect_url)

        if 'save_balance_invoice' in request.POST:
            forms = BalanceAddForm.get_forms(request)
            context['balance_invoice_form_data'] = [form.render_js('from_template') for form in forms]
            if forms.are_valid():
                for form in forms:
                    data = form.cleaned_data
                    data['amount'] = -data['amount']
                    data['user'] = client
                    data['item_type'] = BALANCEITEM_TYPE_INVOICE
                    BalanceItem(**data).save()
                messages.add_message(request, messages.SUCCESS, u"Счёт добавлен.")
                return _redirect_after_post(redirect_url)

    _filter = QSFilter(request, OrderedItemsFilterForm)
    context['filter'] = _filter
    context['qs_filter_param'] = _filter.get_filters()

    try:
        user_fields = request.user.get_profile().get_order_fields()
    except Exception:
        user_fields = None
    if user_fields:
        STAFF_FIELDS = [x for x in STAFF_FIELD_LIST if x[2] in user_fields]
    else:
        STAFF_FIELDS = STAFF_FIELD_LIST
    context['staff_fields'] = [x[2] for x in STAFF_FIELDS]
    LIST_HEADERS = [(x[0], x[1]) for x in STAFF_FIELDS]

    sort_headers = SortHeaders(request, LIST_HEADERS)
    order_field = request.GET.get('o', None)
    order_direction = request.GET.get('ot', None)

    list_filters = []
    for x in STAFF_FIELDS:
        try:
            form_field = _filter.form.__getitem__(x[3])
            list_filters.append(form_field)
        except Exception:
            list_filters.append("")
    context['list_filters'] = list_filters

    order_by = '-created'
    if order_field:
        if order_direction == 'desc':
            order_direction = '-'
        else:
            order_direction = ''
        order_by = order_direction + LIST_HEADERS[int(order_field)][1]

    context['headers'] = list(sort_headers.headers())

    qs_filter = _filter.get_filters()

    qs_filter.update({
        'status__in': ('received_office',),
        'client__id': client_id,
    })

    qs = OrderedItem.objects.select_related().filter(**qs_filter)

    context['packages'] = Package.objects.filter(
        client__id=client_id,
        status__in=(PACKAGE_STATUS_RECEIVED,)
    ).order_by('-created_at')

    # calculate totals by filter
    from django.db import connection
    total = {}
    td = "U0"
    q, params = qs._as_sql(connection)
    from_clause = q.split("FROM")[1]

    where = from_clause.split("WHERE")
    if len(where) > 1:
        from_clause = where[0]
        where = [where[1]]
    else:
        where = []
    where.append("%s.status NOT IN ('failure', 'wrong_number', 'out_of_stock', 'cancelled_customer', 'export_part')" % td)
    where = "WHERE %s" % "AND ".join(where)

    sql = """
        SELECT
            SUM(%(p)s.total_cost),
            SUM(%(p)s.weight*%(p)s.quantity),
            SUM(%(p)s.delivery),
            SUM(%(p)s.quantity*COALESCE(%(p)s.price_discount, %(p)s.price_sale, 0)),
            SUM(%(p)s.price_invoice*%(p)s.quantity),
            SUM(%(p)s.price_manager),
            SUM(%(p)s.total_manager)
            FROM %(from)s %(where)s
    """ % {'p': td, 'from': from_clause, 'where': where}
    cursor = connection.cursor()
    cursor.execute(sql, params)
    res = cursor.fetchall()
    if len(res) > 0:
        total.update(dict(zip(
            (
                'total_cost', 'weight', 'delivery', 'price_sale',
                'price_invoice', 'price_manager', 'total_manager'), res[0])
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
            client_id = %(client_id)i AND status IN (%(statuses)s)
    """ % {
        'client_id': client.id,
        'statuses': ",".join(str(x) for x in (PACKAGE_STATUS_RECEIVED,))
    }

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

    total_row = []
    total = _sum(total, total_packages)
    for f in STAFF_FIELDS:
        field_name = f[2].split("__")[0]
        if field_name[:2] == "po":
            total_row.append(u"Итого:")
        else:
            total_row.append(total.get(field_name, u""))
    context['total_row'] = total_row

    if order_by:
        qs = qs.order_by(order_by)

    items_per_page = get_items_per_page(request, session_store_prefix)
    context['items_per_page'] = items_per_page
    paginator = SimplePaginator(request, qs, items_per_page, 'page')

    context['status_options_str'], context['status_options'] = get_status_options()
    context['status_options_package'] = get_status_options_package()
    context['items'] = paginator.get_page_items()
    context['paginator'] = paginator
    context['brands'] = ','.join(['{"id":%s,"name":"%s"}' % (brand.id, brand.title) for brand in Brand.objects.all()])
    context['total_row'] = total_row
    context['edit_mode'] = 1
    context['issues_mode'] = 1
    context['client'] = client
    context['balance_add_form_template'] = BalanceAddForm().render_js('from_template')
    return context


@staff_member_required
@render_to('cp/issues_manager.html')
def issues_manager(request, manager_id):
    manager = get_object_or_404(User, id=manager_id)
    context = {}
    session_store_prefix = "cp_issues_manager"

    if request.method == 'POST':
        redirect_url = reverse("issues_manager", args=[manager_id])

        if request.POST.get('issued'):
            order_ids = request.POST.get('issued_orders')
            package_ids = request.POST.get('issued_packages')
            try:
                if order_ids:
                    order_ids = [int(x) for x in order_ids.split(',')]

                if package_ids:
                    package_ids = [int(x) for x in package_ids.split(',')]
            except:
                msg = u"Невалидные данные"
                messages.add_message(request, messages.ERROR, msg)
                return _redirect_after_post(redirect_url)
            else:
                if order_ids:
                    orders = list(OrderedItem.objects.filter(id__in=order_ids))
                    for order in orders:
                        order.status = 'issued'
                        order.issued_at = datetime.now()
                        order.save()

                if package_ids:
                    packages = list(Package.objects.filter(id__in=package_ids))
                    for package in packages:
                        package.status = PACKAGE_STATUS_ISSUED
                        package.issued_at = datetime.now()
                        package.save()
                msg = u"Успешно отгружены"
                messages.add_message(request, messages.SUCCESS, msg)
                return _redirect_after_post(redirect_url)

    _filter = QSFilter(request, OrderedItemsFilterForm)
    context['filter'] = _filter
    context['qs_filter_param'] = _filter.get_filters()

    try:
        user_fields = request.user.get_profile().get_order_fields()
    except Exception:
        user_fields = None
    if user_fields:
        STAFF_FIELDS = [x for x in STAFF_FIELD_LIST if x[2] in user_fields]
    else:
        STAFF_FIELDS = STAFF_FIELD_LIST
    context['staff_fields'] = [x[2] for x in STAFF_FIELDS]
    LIST_HEADERS = [(x[0], x[1]) for x in STAFF_FIELDS]

    sort_headers = SortHeaders(request, LIST_HEADERS)
    order_field = request.GET.get('o', None)
    order_direction = request.GET.get('ot', None)

    list_filters = []
    for x in STAFF_FIELDS:
        try:
            form_field = _filter.form.__getitem__(x[3])
            list_filters.append(form_field)
        except Exception:
            list_filters.append("")
    context['list_filters'] = list_filters

    order_by = '-created'
    if order_field:
        if order_direction == 'desc':
            order_direction = '-'
        else:
            order_direction = ''
        order_by = order_direction + LIST_HEADERS[int(order_field)][1]

    context['headers'] = list(sort_headers.headers())

    qs_filter = _filter.get_filters()

    qs_filter.update({
        'status__in': ('received_office',),
        'manager__id': manager.id,
    })

    qs = OrderedItem.objects.select_related().filter(**qs_filter)

    context['packages'] = Package.objects.filter(
        manager__id=manager.id,
        status__in=(PACKAGE_STATUS_RECEIVED,)
    ).order_by('-created_at')

    # calculate totals by filter
    from django.db import connection
    total = {}
    td = "U0"
    q, params = qs._as_sql(connection)
    from_clause = q.split("FROM")[1]

    where = from_clause.split("WHERE")
    if len(where) > 1:
        from_clause = where[0]
        where = [where[1]]
    else:
        where = []
    where.append("%s.status NOT IN ('failure', 'wrong_number', 'out_of_stock', 'cancelled_customer', 'export_part')" % td)
    where = "WHERE %s" % "AND ".join(where)

    sql = """
        SELECT
            SUM(%(p)s.total_cost),
            SUM(%(p)s.weight*%(p)s.quantity),
            SUM(%(p)s.delivery),
            SUM(%(p)s.quantity*COALESCE(%(p)s.price_discount, %(p)s.price_sale, 0)),
            SUM(%(p)s.price_invoice*%(p)s.quantity),
            SUM(%(p)s.price_manager),
            SUM(%(p)s.total_manager)
            FROM %(from)s %(where)s
    """ % {'p': td, 'from': from_clause, 'where': where}
    cursor = connection.cursor()
    cursor.execute(sql, params)
    res = cursor.fetchall()
    if len(res) > 0:
        total.update(dict(zip(
            (
                'total_cost', 'weight', 'delivery', 'price_sale',
                'price_invoice', 'price_manager', 'total_manager'), res[0])
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
            manager_id = %(manager_id)i AND status IN (%(statuses)s)
    """ % {
        'manager_id': manager.id,
        'statuses': ",".join(str(x) for x in (PACKAGE_STATUS_RECEIVED,))
    }

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

    total_row = []
    total = _sum(total, total_packages)
    for f in STAFF_FIELDS:
        field_name = f[2].split("__")[0]
        if field_name[:2] == "po":
            total_row.append(u"Итого:")
        else:
            total_row.append(total.get(field_name, u""))
    context['total_row'] = total_row

    if order_by:
        qs = qs.order_by(order_by)

    items_per_page = get_items_per_page(request, session_store_prefix)
    context['items_per_page'] = items_per_page
    paginator = SimplePaginator(request, qs, items_per_page, 'page')

    context['status_options_str'], context['status_options'] = get_status_options()
    context['status_options_package'] = get_status_options_package()
    context['items'] = paginator.get_page_items()
    context['paginator'] = paginator
    context['brands'] = ','.join(['{"id":%s,"name":"%s"}' % (brand.id, brand.title) for brand in Brand.objects.all()])
    context['total_row'] = total_row
    context['edit_mode'] = 1
    context['issues_mode'] = 1
    context['manager'] = manager
    return context


@staff_member_required
@render_to('cp/index.html')
def index(request):
    context = {}
    session_store_prefix = "cp_index"

    _filter = QSFilter(request, OrderedItemsFilterForm)
    context['filter'] = _filter

    try:
        user_fields = request.user.get_profile().get_order_fields()
    except Exception:
        user_fields = None

    if user_fields:
        fields = [x for x in STAFF_FIELD_LIST if x[2] in user_fields]
    else:
        fields = STAFF_FIELD_LIST
    context['staff_fields'] = [x[2] for x in fields]
    LIST_HEADERS = [(x[0], x[1]) for x in fields]
    sort_headers = SortHeaders(request, LIST_HEADERS)

    list_filters = []
    for x in fields:
        try:
            form_field = _filter.form.__getitem__(x[3])
            list_filters.append(form_field)
        except Exception:
            list_filters.append("")
    context['list_filters'] = list_filters

    order_field = request.GET.get('o', None)
    order_direction = request.GET.get('ot', None)
    order_by = '-created'
    if order_field:
        if order_direction == 'desc':
            order_direction = '-'
        else:
            order_direction = ''
        order_by = order_direction + LIST_HEADERS[int(order_field)][1]

    context['headers'] = list(sort_headers.headers())

    qs_filter = _filter.get_filters()

    period, period_filter = get_period(request, session_store_prefix, "created")
    qs_filter.update(period_filter)
    context['period'] = period

    qs = OrderedItem.objects.select_related().filter(**qs_filter)

    total_row = []
    if _filter.is_set:
        from collections import defaultdict
        total = defaultdict(float)
        total_qs = qs.exclude(
            status__in=('failure', 'wrong_number', 'out_of_stock',
                        'cancelled_customer', 'export_part'))

        for i in total_qs:
            total['weight'] += (i.weight or 0) * i.quantity
            total['total_cost'] += (i.total_cost or 0)
            total['delivery'] += (i.delivery or 0)
            total['price_sale'] += i.quantity * (i.price_discount or i.price_sale or 0)
            total['price_invoice'] += (i.price_invoice or 0) * i.quantity
            total['price_manager'] += (i.price_manager or 0)
            total['total_manager'] += (i.total_manager or 0)

        for f in fields:
            total_row.append(total.get(f[2], u""))

    context['total_row'] = total_row

    if order_by:
        qs = qs.order_by(order_by)

    items_per_page = get_items_per_page(request, session_store_prefix)
    context['items_per_page'] = items_per_page
    paginator = SimplePaginator(request, qs, items_per_page, 'page')

    # grouping parents orders
    if not _filter.is_set:
        items_list = list(x for x in paginator.get_page_items() if not x.parent)
        for order in OrderedItem.objects.filter(parent__id__in=set(x.id for x in items_list)):
            items_list.insert(items_list.index(order.parent), order)
        paginator.page.object_list = items_list

    context['status_options_str'], context['status_options'] = get_status_options()
    context['items'] = paginator.get_page_items()
    context['paginator'] = paginator
    context['brands'] = ','.join(['{"id":%s,"name":"%s"}' % (brand.id, brand.title) for brand in Brand.objects.all()])
    context['edit_mode'] = 1
    return context


@staff_member_required
@render_to('cp/balance.html')
def balance(request):
    context = {}
    session_store_prefix = "cp_balance"

    _filter = QSFilter(request, BalanceFilterForm)
    context['filter'] = _filter

    LIST_HEADERS = [(x[0], x[1]) for x in BALANCE_FIELD_LIST]
    sort_headers = SortHeaders(request, LIST_HEADERS)
    context['headers'] = list(sort_headers.headers())

    context['list_filters'] = get_list_filters(_filter, BALANCE_FIELD_LIST)

    qs_filter = _filter.get_filters()

    period, period_filter = get_period(request, session_store_prefix, "created_at", "a")
    # qs_filter.update(period_filter)
    context['period'] = period

    qs = BalanceItem.objects.select_related().filter(**qs_filter).order_by('user')

    res = []
    for user, balanceitems in groupby(qs, lambda x: x.user):

        balance = 0
        last_modified = None

        for b in balanceitems:
            balance += b.amount
            if not last_modified or last_modified < b.created_at:
                last_modified = b.created_at

        try:
            client_group = UserProfile.objects.get(user=user).client_group
        except:
            client_group = None

        res.append({
            'user': user,
            'user_group': client_group,
            'balance': balance,
            'last_modified': last_modified,
        })

    res = sorted(res, key=lambda x: x['last_modified'], reverse=True)

    items_per_page = get_items_per_page(request, session_store_prefix)
    context['items_per_page'] = items_per_page
    paginator = SimplePaginator(request, res, items_per_page, 'page')
    context['items'] = paginator.get_page_items()
    context['paginator'] = paginator
    context['total_balance'] = sum(x['balance'] for x in res)
    return context


@staff_member_required
@render_to('cp/balance_client.html')
def balance_client(request, client_id):
    user = get_object_or_404(User, id=client_id)
    context = {}

    context['balance_payment_form_data'] = []
    context['balance_invoice_form_data'] = []
    if request.method == 'POST':
        redirect_url = reverse("balance_client", args=[user.id])

        if 'save_balance_payment' in request.POST:
            forms = BalanceAddForm.get_forms(request)
            context['balance_payment_form_data'] = [form.render_js('from_template') for form in forms]
            if forms.are_valid():
                for form in forms:
                    data = form.cleaned_data
                    data['user'] = user
                    data['item_type'] = BALANCEITEM_TYPE_PAYMENT
                    BalanceItem(**data).save()
                messages.add_message(request, messages.SUCCESS, u"Оплата добавлена.")
                return _redirect_after_post(redirect_url)

        if 'save_balance_invoice' in request.POST:
            forms = BalanceAddForm.get_forms(request)
            context['balance_invoice_form_data'] = [form.render_js('from_template') for form in forms]
            if forms.are_valid():
                for form in forms:
                    data = form.cleaned_data
                    data['amount'] = -data['amount']
                    data['user'] = user
                    data['item_type'] = BALANCEITEM_TYPE_INVOICE
                    BalanceItem(**data).save()
                messages.add_message(request, messages.SUCCESS, u"Счёт добавлен.")
                return _redirect_after_post(redirect_url)

    context['user'] = user
    session_store_prefix = "cp_balance_client"

    _filter = QSFilter(request, BalanceClientFilterForm)
    context['filter'] = _filter

    LIST_HEADERS = [(x[0], x[1]) for x in BALANCE_CLIENT_FIELD_LIST]
    sort_headers = SortHeaders(request, LIST_HEADERS)
    context['headers'] = list(sort_headers.headers())

    context['list_filters'] = get_list_filters(_filter, BALANCE_CLIENT_FIELD_LIST)

    qs_filter = _filter.get_filters()

    period, period_filter = get_period(request, session_store_prefix, "created_at", "a")
    qs_filter.update(period_filter)
    context['period'] = period

    qs = ordering(BalanceItem.objects.select_related().filter(user=user, **qs_filter), request, LIST_HEADERS)

    items_per_page = get_items_per_page(request, session_store_prefix)
    context['items_per_page'] = items_per_page
    paginator = SimplePaginator(request, qs, items_per_page, 'page')
    context['items'] = paginator.get_page_items()
    context['paginator'] = paginator
    context['total_amount'] = sum(x.amount for x in qs)
    context['balance_add_form_template'] = BalanceAddForm().render_js('from_template')
    return context


@staff_member_required
def balanceitem_delete(request, item_id):
    obj = get_object_or_404(BalanceItem, id=item_id)
    user = obj.user
    obj.delete()
    messages.add_message(request, messages.SUCCESS, u"Запись баланса удалена.")
    return HttpResponseRedirect(reverse("balance_client", args=[user.id]))


@staff_member_required
@render_to('cp/order.html')
def order(request):
    response = {}
    if request.method == 'POST':
        item_forms = OrderItemForm.get_forms(request)
        item_data = [item_form.render_js('from_template') for item_form in item_forms]
        if item_forms.are_valid():
            clients = {}
            for form in item_forms:
                data = form.cleaned_data
                if data['client'] not in clients:
                    clients[data['client']] = \
                        OrderedItem.objects.get_next_client_order_id(data['client'])
                data['client_order_id'] = clients[data['client']]
                supplier_id = data.pop('supplier')
                data['manager'] = request.user

                data['brandgroup'] = BrandGroup.objects.get(id=supplier_id)
                OrderedItem(**data).save()

            return HttpResponseRedirect('/cp/order/success/')
    else:
        item_data = [
            OrderItemForm().render_js('from_template'),
            OrderItemForm().render_js('from_template'),
            OrderItemForm().render_js('from_template')
        ]

    response['page_template'] = OrderItemForm().render_js('from_template')
    response['page_data'] = item_data

    return response


@staff_member_required
@render_to('cp/order_success.html')
def order_success(request):
    return {}


@staff_member_required
@render_to('cp/groups.html')
def groups(request):
    qs = OrderedItem.objects.filter(status__in=('order', 'moderation'))
    orders_by_direction = {}
    for order in qs:
        if order.brandgroup.direction not in orders_by_direction:
            orders_by_direction[order.brandgroup.direction] = {}
        if order.brandgroup not in orders_by_direction[order.brandgroup.direction]:
            orders_by_direction[order.brandgroup.direction][order.brandgroup] = []
        orders_by_direction[order.brandgroup.direction][order.brandgroup].append(order)

    basket_filled, msg = automototrade_basket_filled()
    if basket_filled:
        messages.add_message(request, messages.ERROR, msg)
    else:
        messages.add_message(request, messages.SUCCESS, msg)

    return {'orders_by_direction': orders_by_direction}


def automototrade_basket_filled():
    try:
        br = mechanize.Browser()
        br.open("http://automototrade.com/", timeout=5.0)
        br.select_form(nr=0)
        br["login"] = settings.SOAP_LOGIN
        br["password"] = settings.SOAP_PASSWORD
        br.submit()
        link = list(br.links(url="./?key=personal&basket2"))[0]
        count = int(link.text.decode('cp1251').lower().split(" ")[2].strip())
    except:
        return True, u'Произошла ошибка при проверке корзины. Проверьте, пожалуйста, вручную.'
    else:
        filled = count > 0
        return filled, u'В корзине <b>%s</b> позиций.' % count


class OrderedItemSaver(object):
    error = None

    def save_part_number(self, obj, value):
        try:
            obj.part_number = value
            obj.save()
        except Exception, e:
            logger.exception("save_part_number: %r" % e)
            pass
        return obj.part_number

    def save_comment_customer(self, obj, value):
        try:
            obj.comment_customer = value
            obj.save()
        except Exception, e:
            logger.exception("save_comment_customer: %r" % e)
            pass
        return obj.comment_customer

    def save_comment_supplier(self, obj, value):
        try:
            obj.comment_supplier = value
            obj.save()
        except Exception, e:
            logger.exception("save_comment_supplier: %r" % e)
            pass
        return obj.comment_supplier

    def save_price_invoice(self, obj, value):
        # change status for first time setting
        # of price invoice for US direction
        if not obj.price_invoice and value:
            if str(obj.brandgroup.direction.title.lower()) == 'us':
                obj.switch_status('in_delivery')
            if str(obj.brandgroup.direction.title.lower()) == 'msk':
                obj.switch_status('sent_representative')
        else:
            obj.switch_status()
        try:
            obj.price_invoice = value
            obj.save()

        except Exception, e:
            logger.exception("save_price_invoice: %r" % e)
        return obj.price_invoice

    def save_part_number_superseded(self, obj, value):
        try:
            obj.part_number_superseded = value
            obj.save()
        except Exception, e:
            logger.exception("save_part_number_superseded: %r" % e)
            pass
        return obj.part_number_superseded

    def save_description_ru(self, obj, value):
        try:
            obj.description_ru = value
            obj.save()
        except Exception, e:
            logger.exception("save_description_ru: %r" % e)
            pass
        return obj.description_ru

    def save_description_en(self, obj, value):
        try:
            obj.description_en = value
            obj.save()
        except Exception, e:
            logger.exception("save_description_en: %r" % e)
            pass
        return obj.description_en

    def save_price_base(self, obj, value):
        try:
            obj.price_base = value
            obj.save()
        except Exception, e:
            logger.exception("save_price_base: %r" % e)
            pass
        return obj.price_base

    def save_weight(self, obj, value):
        try:
            if not obj.weight:
                obj.status = 'received_office'
                obj.received_office_at = datetime.now()
            obj.weight = value
            obj.save()
        except Exception, e:
            logger.exception("save_weight: %r" % e)
            pass
        return obj.weight

    def save_price_discount(self, obj, value):
        try:
            obj.price_discount = value
            obj.save()
        except Exception, e:
            logger.exception("save_price_discount: %r" % e)
            pass
        return obj.price_discount

    def save_quantity_ship(self, obj, value):
        try:
            if obj.quantity < value:
                self.error = 'quantity_ship value can not be more than quantity (quantity: %s, entered: %s)' % (obj.quantity, value)
                return obj.quantity_ship
            obj.quantity_ship = value
            obj.save()
        except Exception, e:
            logger.exception("save_quantity_ship: %r" % e)
            self.error = e
        return obj.quantity_ship

    def save_status(self, obj, value):
        try:
            previous_status = obj.previous_status
            obj.previous_status = obj.status
            if value == '_return_':
                if previous_status:
                    obj.status = previous_status
            else:
                obj.status = value
            obj.status_modified = datetime.now()
            if value == 'received_office':
                obj.received_office_at = datetime.now()
            elif value == 'issued':
                obj.issued_at = datetime.now()
            obj.save()
        except Exception, e:
            logger.exception("save_status: %r" % e)
            pass
        return obj.status

    def save_invoice_code(self, obj, value):
        try:
            obj.invoice_code = value
            obj.save()
        except Exception, e:
            logger.exception("save_invoice_code: %r" % e)
            pass
        return obj.invoice_code

    def save_price_manager(self, obj, value):
        try:
            obj.price_manager = value
            obj.save()
        except Exception, e:
            logger.exception("save_price_manager: %r" % e)
            pass
        return obj.price_manager


class PackageSaver(object):
    error = None

    def save_description(self, obj, value):
        try:
            obj.description = value
            obj.save()
        except Exception, e:
            logger.exception("save_package_description: %r" % e)
            pass
        return obj.description

    def save_weight(self, obj, value):
        try:
            obj.weight = value
            obj.save()
        except Exception, e:
            logger.exception("save_package_weight: %r" % e)
            pass
        return obj.weight

    def save_quantity(self, obj, value):
        try:
            obj.quantity = value
            obj.save()
        except Exception, e:
            logger.exception("save_package_quantity: %r" % e)
            pass
        return obj.quantity

    def save_status(self, obj, value):
        try:
            obj.status = value
            obj.save()
        except Exception, e:
            logger.exception("save_package_status: %r" % e)
            pass
        return obj.status


@ajax_request
# @staff_member_required
def position_edit(request, content_type, item_id):
    logger.debug("position_edit called with args: %s, %s" % (content_type, item_id))
    models = {'ordered_item': OrderedItem, 'package': Package}
    forms = {'ordered_item': OrderedItemForm, 'package': PackageForm}
    savers = {'ordered_item': OrderedItemSaver, 'package': PackageSaver}
    item = get_object_or_404(models[content_type], pk=item_id)
    logger.debug("Item found: %r" % item)
    response = {}
    try:
        old_value = getattr(item, request.POST['type'])
    except:
        logger.exception('Attribute %s does not exist' % request.POST['type'])
        response['error'] = 'Attribute does not exist'
        return response
    form = forms[content_type]({request.POST['type']: request.POST['value']})
    if form.is_valid():
        logger.debug("Form is valid")
        try:
            value = form.cleaned_data[request.POST['type']]
            logger.debug("Got value: %r" % value)
        except Exception, e:
            logger.error("Value error: %r" % e)
            response['error'] = e
            return response

        saver = savers[content_type]()
        logger.debug("Calling saver: %r" % saver)
        response['value'] = getattr(saver, 'save_' + request.POST['type'])(item, value)
        response['error'] = saver.error
    else:
        logger.error("Form validation failed")
        response['value'] = old_value and str(old_value) or ''
        response['error'] = u'Wrong value!'
    return response


@ajax_request
@staff_member_required
def get_ordered_item(request, item_id):
    item = get_object_or_404(OrderedItem, pk=item_id)
    fields = request.GET.get('fields').split(",")
    if not fields:
        return {}
    response = {}
    for f in fields:
        try:
            if f in ('created', 'modified', 'received_office_at'):
                try:
                    attr = getattr(item, f)
                    response[f] = attr.strftime("%Y-%m-%d %H:%M:%S")
                except (AttributeError, ValueError):
                    response[f] = ''
            else:
                response[f] = str(getattr(item, f))
        except AttributeError:
            response[f] = None
    return response


def insert_in_basket(items, ponumber, send_order=False):
    details = []
    not_us_details = []
    data = {'ok': False, 'response': None}
    for x in items:
        d = {
            'Brand': x.area.title,
            'Coment': x.comment_supplier if x.comment_supplier else '',
            'Description': x.description_ru,
            'DescriptionEng': x.description_en,
            'Qty': x.quantity,
            'OemCode': x.part_number,
            'CustomerId': "%s/%s" % (int(x.id), x.client.username),
            'Weight': x.weight if x.weight else '',
        }

        if x.brandgroup.add_brand_to_comment and x.brandgroup.direction.title.lower() in ('us',):
            d['Coment'] = u'%s %s' % (d['Coment'], x.brand.title) if d['Coment'] else x.brand.title

        if x.brandgroup.direction.title.lower() in ('us',):
            details.append(d)
        else:
            not_us_details.append(d)

    if not_us_details:
        context = {
            'details': not_us_details,
            'root_url': settings.ROOT_URL
        }
        text = render_to_string('cp/mails/new_orders.txt', context)
        if text:
            send_mail(settings.EMAIL_SUBJECT, text, settings.EMAIL_FROM, settings.EMAILS, fail_silently=False)
            data = {'ok': True, 'response': 'mail_sent'}

    if details:
        response = ''
        err = 0
        fails = (
                u'Произошла ошибка. Детали не были добавлены в корзину. Проверьте, пожалуйста, правильность введенных данных и попробуйте еще раз.',
                u'Произошла ошибка. Детали были добавлены в корзину, но способ доставки и PO не были заданы.',
                u'Произошла ошибка. Детали были добавлены в корзину, способ доставки и PO были заданы, но детали не были отправлены в заказ.'
        )
        succ = (
                u'Детали были успешно добавлены в корзину, способ доставки(авиа) и PO были успешно заданы.',
        )

        if getattr(settings, 'SOAP_ENABLE', False):
            script_path = os.path.join(settings.PROJECT_ROOT, 'soapclient.php')
            arg1 = cjson.encode(details)
            arg2 = cjson.encode({'login': settings.SOAP_LOGIN, 'passwd': settings.SOAP_PASSWORD})
            cmd = "php -f %s %s '%s' '%s'" % (script_path, 'insertBasket', arg1, arg2)
            f = os.popen(cmd)
            data = f.read()
            f.close()
            response = ''
            if data:
                data = cjson.decode(data)
                if data and data['ok'] and data['response']:
                    arg3 = cjson.encode({'ClientOrderNum': ponumber, 'DostavkaType': getattr(settings, 'DELIVERY_TYPE', 1)})
                    cmd = "php -f %s %s '%s' '%s'" % (script_path, 'setOrderParam', arg3, arg2)
                    f = os.popen(cmd)
                    data = f.read()
                    f.close()
                    if data:
                        data = cjson.decode(data)
                        if data and data['ok'] and data['response']:
                            response += succ[0]
                            if send_order:
                                cmd = "php -f %s %s '%s'" % (script_path, 'sendOrder', arg2)
                                f = os.popen(cmd)
                                data = f.read()
                                f.close()
                                if data:
                                    data = cjson.decode(data)
                                    if data['ok'] and data['response']:
                                        pass
                                    else:
                                        err += 1
                                        response += fails[2]
                                else:
                                    err += 1
                                    response += fails[2]
                        else:
                            err += 1
                            response += fails[1]
                    else:
                        err += 1
                        response += fails[1]
                else:
                    err += 1
                    response += fails[0]
            else:
                err += 1
                response += fails[0]

            if err > 0:
                ok = False
            else:
                ok = True

            return {'ok': ok, 'response': response}


@staff_member_required
def change_status(request):
    if not request.method == 'POST':
        raise Http404

    ids = request.POST.getlist('items')
    try:
        orders = OrderedItem.objects.filter(id__in=ids, status='order').order_by('id')
    except:
        orders = []

    if not orders:
        return HttpResponseRedirect('/cp/groups/')

    basket_filled, msg = automototrade_basket_filled()
    if basket_filled:
        msg = u'Заказ невозможен. Корзина не пустая.'
        messages.add_message(request, messages.ERROR, msg)
        return HttpResponseRedirect('/cp/groups/')

    ponumber = OrderedItem.objects.get_next_ponumber(orders[0].brandgroup.direction.id)
    poprefix = orders[0].brandgroup.direction.po
    full_po = '%s%s' % (poprefix, ponumber)

    data = insert_in_basket(orders, full_po)
    if data:
        if data['ok']:
            if 'response' in data and data['response']:
                messages.add_message(request, messages.SUCCESS, data['response'])
            for x in orders:
                if not x.ponumber:
                    x.ponumber = ponumber
                x.status = 'in_processing'
                x.status_modified = datetime.now()
                x.save()
        else:
            if 'response' in data and data['response']:
                messages.add_message(request, messages.ERROR, data['response'])
    return HttpResponseRedirect('/cp/groups/')


@staff_member_required
def export_selected(request):

    ids = request.POST.getlist('items')
    try:
        items = OrderedItem.objects.filter(id__in=ids, status='order')
    except:
        items = []

    if items:
        ponumber = OrderedItem.objects.get_next_ponumber(items[0].brandgroup.direction.id)
        for x in items:
            if not x.ponumber:
                x.ponumber = ponumber
            x.status = 'in_processing'
            x.status_modified = datetime.now()
            x.save()

        filename = os.path.join(settings.MEDIA_ROOT, 'temp.xls')

        # Open new workbook
        book = xl.Workbook()

        # styles
        sub_header_style = xl.XFStyle()
        sub_header_style.font = xl.Font()
        sub_header_style.bold = True
        sub_header_style.font.height = 0x0190-150

        sheet = book.add_sheet('Export')

        try:
            user_fields = request.user.get_profile().get_order_fields()
        except Exception:
            user_fields = None
        if user_fields:
            STAFF_FIELDS = [x for x in STAFF_FIELD_LIST if x[2] in user_fields]
        else:
            STAFF_FIELDS = STAFF_FIELD_LIST

        FIELDS = tuple((x[0], x[2]) for x in STAFF_FIELDS)

        i = 0
        curr_line = 0
        for key, value in FIELDS:
            sheet.write(curr_line, i, key)
            i += 1
        for order in items:
            i = 0
            curr_line += 1
            for key, field_name in FIELDS:

                if field_name == 'ponumber':
                    value = u'%s%s' % (order.brandgroup.direction.po, order.ponumber or '--')
                elif field_name == 'status':
                    value = order.get_status_verbose()
                else:
                    value = field_value(order, field_name)
                try:
                    sheet.write(curr_line, i, value)
                    i += 1
                except AssertionError:
                    value = unicode(value)
                    sheet.write(curr_line, i, value)
                    i += 1

        # Save book
        book.save(filename)
        os.chmod(filename, 0777)
        content = open(filename, 'rb').read()
        response = HttpResponse(content, mimetype='application/vnd.ms-excel')
        name = '%s-%s.xls' % ('export', datetime.now().strftime('%m-%d-%Y-%H-%M'))
        response['Content-Disposition'] = 'inline; filename=%s' % name
        os.remove(filename)

        return response
    else:
        return HttpResponseRedirect('/cp/groups/')


@staff_member_required
def export(request, group_id):
    brandgroup = BrandGroup.objects.get(id=group_id)
    items = OrderedItem.objects.filter(brandgroup__id=group_id, status='order').order_by("brandgroup__direction__po")
    ponumber = OrderedItem.objects.get_next_ponumber(brandgroup.direction.id)

    for x in items:
        if not x.ponumber:
            x.ponumber = ponumber
        x.status = 'in_processing'
        x.status_modified = datetime.now()
        x.save()

    filename = os.path.join(settings.MEDIA_ROOT, 'temp.xls')

    # Open new workbook
    book = xl.Workbook()

    # styles
    sub_header_style = xl.XFStyle()
    sub_header_style.font = xl.Font()
    sub_header_style.bold = True
    sub_header_style.font.height = 0x0190-150

    sheet = book.add_sheet(brandgroup.title)

    try:
        user_fields = request.user.get_profile().get_order_fields()
    except Exception:
        user_fields = None
    if user_fields:
        STAFF_FIELDS = [x for x in STAFF_FIELD_LIST if x[2] in user_fields]
    else:
        STAFF_FIELDS = STAFF_FIELD_LIST

    FIELDS = tuple((x[0], x[2]) for x in STAFF_FIELDS)

    i = 0
    curr_line = 0
    for key, value in FIELDS:
        sheet.write(curr_line, i, key)
        i += 1
    for order in items:
        i = 0
        curr_line += 1
        for key, field_name in FIELDS:

            if field_name == 'ponumber':
                value = u'%s%s' % (order.brandgroup.direction.po, order.ponumber or '--')
            elif field_name == 'status':
                value = order.get_status_verbose()
            else:
                value = field_value(order, field_name)
            try:
                sheet.write(curr_line, i, value)
                i += 1
            except AssertionError:
                value = unicode(value)
                sheet.write(curr_line, i, value)
                i += 1

    # Save book
    book.save(filename)
    os.chmod(filename, 0777)
    content = open(filename, 'rb').read()
    response = HttpResponse(content, mimetype='application/vnd.ms-excel')
    name = '%s-%s.xls' % (brandgroup.title, datetime.now().strftime('%m-%d-%Y-%H-%M'))
    response['Content-Disposition'] = 'inline; filename=%s' % name
    os.remove(filename)

    return response


@staff_member_required
@render_to('cp/import_order.html')
def import_order(request):
    CELLS = (
       (0, 'supplier', 'DIR'),
       (1, 'area', 'AREA'),
       (2, 'brand', 'BRAND'),
       (3, 'part_number', 'PART#'),
       (4, 'comment_customer', 'COMENT 1'),
       (5, 'comment_supplier', 'COMENT 2'),
       (6, 'quantity', 'Q'),
       (7, 'client', 'CL'),
       (8, 'description_ru', 'RUS'),
       (9, 'description_en', 'ENG'),
       (10, 'price_base', 'LIST'),
       (11, 'price_sale', 'PRICE'),
    )

    def get_field_name(cell_title):
        for i in CELLS:
            if i[2] == cell_title:
                return i[1]

    def swap_keys(kwargs, num):
        _data = {}
        for k, v in kwargs.items():
            if k.upper() == 'DIR':
                try:
                    _data[get_field_name(k) + '.%d' % num] = [BrandGroup.objects.get(title__iexact=v[0]).id]
                except BrandGroup.DoesNotExist:
                    _data[get_field_name(k) + '.%d' % num] = ''
            elif k.upper() == 'BRAND' or k.upper() == 'AREA':
                _data[get_field_name(k) + '.%d' % num] = [v[0].capitalize()]
            elif k.upper() == 'CL':
                try:
                    _data[get_field_name(k) + '.%d' % num] = [User.objects.get(username__iexact=v[0].lower()).id]
                except User.DoesNotExist:
                    _data[get_field_name(k) + '.%d' % num] = ''
            else:
                _data[get_field_name(k) + '.%d' % num] = v
            _data['id' + '.%d' % num] = ''
        return _data

    response = {}
    if request.method == 'POST':
        form = ImportOrderXlsForm(request.POST, request.FILES)
        if form.is_valid():
            data = {}
            f = form.cleaned_data['xls_file']
            try:
                xls = xlsreader.readexcel(file_contents=f.read())
                sheet = xls.book.sheet_names()[0]
                for i, row in enumerate(xls.iter_dict(sheet), 1):
                    row = dict((x, [y]) for x, y in row.iteritems())
                    data.update(swap_keys(row, i))
            except Exception as e:
                logger.error("%r", e)
                messages.add_message(
                    request, messages.ERROR,
                    u"При импорте произошла ошибка %s-ой(-ей) строке." % i)
            else:
                if data:
                    request.POST = MultiValueDict(data)
                    item_forms = OrderItemForm.get_forms(request)
                    form_list = [
                        item_form.render_js('from_template')
                        for item_form in item_forms]
                    response['page_data'] = form_list
            finally:
                f.close()
    else:
        form = ImportOrderXlsForm()
    response['form'] = form
    response['page_template'] = OrderItemForm().render_js('from_template')
    return response


LIST_HEADERS = (
    (u'PO', 'ponumber'),
    (u'Поставщик', 'brandgroup'),
    (u'BRAND', 'brand'),
    (u'AREA', 'area'),
    (u'PART #', 'part_number'),
    (u'ЗАМЕНА', 'part_number_superseded'),
    (u'COMMENT 2', 'comment_supplier'),
    (u'Q', 'quantity'),
    (u'PRICE IN', 'price_invoice'),
    (u'TOTAL', 'total_w_ship'),
    (u'ID', 'manager'),
    (u'CL', 'client'),
    (u'RUS', 'description_ru'),
    (u'ENG', 'description_en'),
    (u'LIST', 'price_base'),
    (u'WEIGHT', 'weight'),
    (u'SHIPPING', 'delivery'),
    (u'PRICE', 'price_sale'),
    (u'NEW PRICE', 'price_discount'),
    (u'COST', 'cost'),
    (u'TOTAL', 'total_cost'),
    (u'Инвойс', 'invoice_code'),
    (u'Статус', 'status'),
)


def field_value(order_obj, field_name):
    price_fields = [
        'price_invoice', 'total', 'total_w_ship', 'price_base', 'price_sale', 'delivery',
        'price_discount', 'cost', 'total_cost'
    ]
    if field_name in price_fields and order_obj.failed:
        return ''
    return getattr(order_obj, field_name) or ''


@staff_member_required
def export_order(request):
    _filter = QSFilter(request, OrderedItemsFilterForm, clear_old=False)

    orders = OrderedItem.objects.select_related() \
                        .filter(**_filter.get_filters()) \
                        .order_by('brandgroup__direction__po', 'ponumber')
    filename = os.path.join(settings.MEDIA_ROOT, 'temp.xls')

    book = xl.Workbook()
    sheet = book.add_sheet('ORDERS')

    try:
        user_fields = request.user.get_profile().get_order_fields()
    except Exception:
        user_fields = None
    if user_fields:
        STAFF_FIELDS = [x for x in STAFF_FIELD_LIST if x[2] in user_fields]
    else:
        STAFF_FIELDS = STAFF_FIELD_LIST

    FIELDS = tuple((x[0], x[2]) for x in STAFF_FIELDS)

    i = 0
    curr_line = 0
    for key, value in FIELDS:
        sheet.write(curr_line, i, key)
        i += 1
    for order in orders:
        i = 0
        curr_line += 1
        for key, field_name in FIELDS:

            if field_name == 'ponumber':
                value = u'%s%s' % (order.brandgroup.direction.po, order.ponumber \
                                   or '--')
            elif field_name == 'status':
                value = order.get_status_verbose()
            else:
                value = field_value(order, field_name)
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


@ajax_request
@staff_member_required
def get_brandgroup_settings(request, ordered_item_id):
    try:
        ordered_item = OrderedItem.objects.get(pk=ordered_item_id)
    except OrderedItem.DoesNotExist:
        pass
    else:
        m, d, dp, pu, mc = ordered_item.area.get_brandgroup_settings(ordered_item.brandgroup)
        return map(float, [m, d])
    return []


@staff_member_required
def ordered_item_row(request, item_id):
    try:
        item = OrderedItem.objects.get(pk=item_id)
    except OrderedItem.DoesNotExist:
        return HttpResponse(content='')
    c = {
        'i': item,
    }
    c['status_options_str'], c['status_options'] = get_status_options()
    context = RequestContext(request, c)
    html = render_to_string("cp/tags/table/row.html", context_instance=context)
    return HttpResponse(content=html)


def get_brandgroup_areas(request, brandgroup_id):
    response = ''
    try:
        brandgroup = BrandGroup.objects.get(pk=brandgroup_id)
    except BrandGroup.DoesNotExist:
        response = ''
    else:
        response = serializers.serialize('json',
            brandgroup.area.all(), fields=('id', 'title'))
    return HttpResponse(response, mimetype="text/json")