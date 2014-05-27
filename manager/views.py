# -*- coding=utf-8 -*-
import os
import pyExcelerator as xl
import datetime
import dateutil
import random
import string
from collections import defaultdict
from itertools import groupby

from django.contrib import messages
from django.contrib.auth.models import User
from django.core.urlresolvers import reverse
from django.conf import settings
from django.http import HttpResponse, Http404, HttpResponseRedirect
from django.shortcuts import get_object_or_404

from lib.decorators import render_to
from lib.paginator import SimplePaginator
from lib.sort import SortHeaders
from lib.qs_filter import QSFilter
from lib.collections import Counter

from common.decorators import manager_required

from data.models import (
    OrderedItem, ORDER_ITEM_STATUSES, UserProfile,
    Invoice, Package, Shipment, BalanceItem, BALANCEITEM_TYPE_INVOICE,
    PACKAGE_STATUS_RECEIVED, BALANCEITEM_TYPE_PAYMENT
)

from data.forms import (
    OrderedItemsFilterForm, MANAGER_FIELD_LIST,
    InvoicesFilterForm, INVOICES_FIELD_LIST,
    MANAGER_SHIPMENTS_FIELD_LIST, ShipmentsFilterForm,
    BalanceFilterForm, BALANCE_FIELD_LIST,
    BalanceClientFilterForm, BALANCE_CLIENT_FIELD_LIST
)

from cp.forms import PackageItemForm, BalanceAddForm

import logging
logger = logging.getLogger("manager.views")


def get_status_options():
    return list({'value': i[0], 'option': i[1]} for i in ORDER_ITEM_STATUSES)


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
    PERIOD_PARAM_DEFAULT = period or PERIOD_PARAM_ALL

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


def get_ordering(request, list_headers, field='created'):
    order_field = request.GET.get('o', None)
    order_direction = request.GET.get('ot', None)
    order_by = '-%s' % field

    if order_field:
        if order_direction == 'desc':
            order_direction = '-'
        else:
            order_direction = ''
        order_by = order_direction + list_headers[int(order_field)][1]

    return order_by


def get_list_filters(_filter, fields):
    list_filters = []
    for f in fields:
        try:
            form_field = _filter.form.__getitem__(f[3])
            list_filters.append(form_field)
        except Exception:
            list_filters.append("")
    return list_filters


def get_user_fields(user):
    try:
        user_profile = user.get_profile()
        user_fields = user_profile.get_order_fields()
    except:
        fields = MANAGER_FIELD_LIST
    else:
        fields = [x for x in MANAGER_FIELD_LIST if x[2] in user_fields]
    return fields


def get_total(qs, fields):
    if not qs:
        return {}

    total = defaultdict(float)
    for i in qs:
        total['weight'] += (i.weight or 0) * i.quantity
        total['total_cost'] += (i.total_cost or 0)
        total['delivery'] += (i.delivery or 0)
        total['price_sale'] += i.quantity * (
            (getattr(i, 'price_discount', 0) or 0)
            or
            getattr(i, 'price_sale', 0) or 0)

    return total


def get_total_row(qs, fields):
    total = get_total(qs, fields)
    return list(total.get(f[2], u"") for f in fields)


def _random(length=5):
    yield "".join([random.choice(string.letters) for x in xrange(0, length)])


def _redirect_after_post(url):
    return HttpResponseRedirect(
        "%s?%s=%s" % (url, _random().next(), _random().next())
    )


@manager_required
@render_to('manager/index.html')
def index(request):

    context = {}
    session_store_prefix = 'manager_index'

    _filter = QSFilter(request, OrderedItemsFilterForm)
    context['filter'] = _filter

    fields = get_user_fields(request.user)
    context['user_fields'] = [x[2] for x in fields]
    list_headers = [(x[0], x[1]) for x in fields]

    sort_headers = SortHeaders(request, list_headers)
    context['headers'] = list(sort_headers.headers())

    context['list_filters'] = get_list_filters(_filter, fields)

    qs_filter = _filter.get_filters()

    period, period_filter = get_period(
        request, session_store_prefix, 'created')
    qs_filter.update(period_filter)
    context['period'] = period

    client_ids = list(
        UserProfile.objects.filter(
            client_manager=request.user
        ).values_list('user', flat=True))

    qs = OrderedItem.objects.select_related().filter(
        client__id__in=client_ids, **qs_filter)

    total_row = []
    if _filter.is_set:
        total_row = get_total_row(
            qs.exclude(
                status__in=(
                    'failure', 'wrong_number', 'out_of_stock',
                    'cancelled_customer', 'export_part')),
            fields)
    context['total_row'] = total_row

    order_by = get_ordering(request, list_headers)
    if order_by:
        qs = qs.order_by(order_by)

    items_per_page = get_items_per_page(request, session_store_prefix)
    context['items_per_page'] = items_per_page
    paginator = SimplePaginator(request, qs, items_per_page, 'page')

    # grouping parents orders
    if not _filter.is_set:
        items_list = list(x for x in paginator.get_page_items() if not x.parent)
        for order in OrderedItem.objects.filter(
                parent__id__in=set(x.id for x in items_list)):
            items_list.insert(items_list.index(order.parent), order)
        paginator.page.object_list = items_list

    context['items'] = paginator.get_page_items()
    context['paginator'] = paginator
    return context


@manager_required
@render_to('manager/by_clients.html')
def by_clients(request):
    context = {}

    client_ids = list(
        UserProfile.objects.filter(
            client_manager=request.user
        ).values_list('user', flat=True))

    qs = OrderedItem.objects.select_related().filter(
        client__id__in=client_ids,
        status__in=('moderation',))
    ids = list(qs.values_list('id', flat=True))

    if request.method == 'POST':
        redirect_url = reverse("manager_by_clients")
        if request.POST.get('order_items'):
            try:
                order_ids = map(int, request.POST.get('order_ids').split(','))
                if not filter(lambda o: o in ids, order_ids):
                    raise ValueError
            except (ValueError, TypeError, AttributeError):
                msg = u"Невалидные данные"
                messages.add_message(request, messages.ERROR, msg)
                return _redirect_after_post(redirect_url)
            else:
                orders = OrderedItem.objects.filter(id__in=order_ids)
                orders.update(status='order')
                msg = u"Заказаны <b>%i</b> позиций." % len(orders)
                messages.add_message(request, messages.SUCCESS, msg)
                return _redirect_after_post(redirect_url)

    show_fields = (
        'brandgroup', 'area', 'brand', 'part_number', 'comment',
        'quantity', 'description_ru', 'description_en',
        'price_base', 'price_sale',)

    fields = filter(
        lambda x: x[2] in show_fields,
        get_user_fields(request.user))

    context['user_fields'] = [x[2] for x in fields]
    context['headers'] = [x[0] for x in fields]

    items = {}
    for item in qs:
        items.setdefault(item.client, []).append(item)

    context['items'] = items

    return context


@manager_required
@render_to('manager/order.html')
def order(request):
    context = {}
    return context


@manager_required
@render_to('manager/invoices.html')
def invoices(request):
    context = {}
    session_store_prefix = 'manager_invoices'

    _filter = QSFilter(request, InvoicesFilterForm)
    context['filter'] = _filter

    list_headers = [(x[0], x[1]) for x in INVOICES_FIELD_LIST]
    sort_headers = SortHeaders(request, list_headers)
    context['headers'] = list(sort_headers.headers())

    context['list_filters'] = get_list_filters(_filter, INVOICES_FIELD_LIST)

    qs_filter = _filter.get_filters()

    period, period_filter = get_period(
        request, session_store_prefix, 'received_at')
    qs_filter.update(period_filter)
    context['period'] = period

    client_ids = list(
        UserProfile.objects.filter(
            client_manager=request.user
        ).values_list('user', flat=True))

    invoice_codes = set(OrderedItem.objects.filter(
        client__id__in=client_ids).values_list('invoice_code', flat=True))

    qs = Invoice.objects.select_related().filter(
        code__in=invoice_codes, **qs_filter)

    order_by = get_ordering(request, list_headers, field='received_at')
    if order_by:
        qs = qs.order_by(order_by)

    items_per_page = get_items_per_page(request, session_store_prefix)
    context['items_per_page'] = items_per_page
    paginator = SimplePaginator(request, qs, items_per_page, 'page')
    context['items'] = paginator.get_page_items()
    context['paginator'] = paginator

    return context


@manager_required
@render_to('manager/invoice.html')
def invoice(request, invoice_id):
    invoice = get_object_or_404(Invoice, id=invoice_id)
    context = {'invoice': invoice}
    session_store_prefix = 'manager_invoice'

    _filter = QSFilter(request, OrderedItemsFilterForm)
    context['filter'] = _filter
    context['qs_filter_param'] = _filter.get_filters()

    fields = get_user_fields(request.user)
    context['user_fields'] = [x[2] for x in fields]
    list_headers = [(x[0], x[1]) for x in fields]

    sort_headers = SortHeaders(request, list_headers)
    context['headers'] = list(sort_headers.headers())

    context['list_filters'] = get_list_filters(_filter, fields)

    invoice.calculate_status()

    client_ids = list(
        UserProfile.objects.filter(
            client_manager=request.user
        ).values_list('user', flat=True))

    qs_packages = Package.objects.filter(
        client__id__in=client_ids,
        invoice=invoice).order_by('-created_at')
    context['packages'] = qs_packages

    qs_orders = OrderedItem.objects.select_related().filter(
        client__id__in=client_ids,
        invoice_code=invoice.code,
        **_filter.get_filters())

    order_by = get_ordering(request, list_headers)
    if order_by:
        qs_orders = qs_orders.order_by(order_by)

    total_orders = get_total(
        qs_orders.exclude(
            status__in=(
                'failure', 'wrong_number', 'out_of_stock',
                'cancelled_customer', 'export_part')),
        fields)

    total_packages = get_total(qs_packages, fields)

    total = dict(Counter(total_orders) + Counter(total_packages))
    context['total_row'] = list(total.get(f[2], '') for f in fields)

    items_per_page = get_items_per_page(request, session_store_prefix)
    context['items_per_page'] = items_per_page
    paginator = SimplePaginator(request, qs_orders, items_per_page, 'page')

    context['items'] = paginator.get_page_items()
    context['paginator'] = paginator

    package_data = []
    if request.method == 'POST':
        redirect_url = reverse("manager_invoice", args=[invoice.id])

        if 'save_package' in request.POST:
            package_forms = PackageItemForm.get_forms(request)
            context['package_forms'] = package_forms

            package_data = [
                package_form.render_js('from_template')
                for package_form in package_forms]

            if package_forms.are_valid():
                for form in package_forms:
                    data = form.cleaned_data
                    data['manager'] = request.user
                    data['invoice'] = invoice
                    Package(**data).save()
                messages.add_message(
                    request, messages.SUCCESS, u"Упаковка добавлена.")
                return _redirect_after_post(redirect_url)

    context['package_template'] = PackageItemForm().render_js('from_template')
    context['package_data'] = package_data

    return context


@manager_required
@render_to('manager/issues.html')
def issues(request):
    context = {}
    session_store_prefix = 'manager_issues'

    if request.method == 'POST':
        redirect_url = reverse('manager_issues')

        if request.POST.get('issued'):
            try:
                order_ids = map(
                    int, request.POST.get('issued_orders').split(','))
            except:
                msg = u"Невалидные данные"
                messages.add_message(request, messages.ERROR, msg)
                return _redirect_after_post(redirect_url)
            else:
                orders = list(OrderedItem.objects.filter(id__in=order_ids))
                already = filter(lambda x: x.shipment, orders)
                if already:
                    msg = u"Отгрузка не проведена. Позиции с ORDER ID: %s уже были отгружены." % (
                        ", ".join(str(x.id) for x in already))
                    messages.add_message(request, messages.ERROR, msg)
                    return _redirect_after_post(redirect_url)
                shipments = Shipment._create(request, orders)
                msg = u"Успешно отгружены. Количество новых отгрузок: <b>%i</b>." % len(shipments)
                messages.add_message(request, messages.SUCCESS, msg)
                return _redirect_after_post(redirect_url)

    _filter = QSFilter(request, OrderedItemsFilterForm)
    context['filter'] = _filter
    context['qs_filter_param'] = _filter.get_filters()
    context['qs_filter_param']['status'] = 'received_office'

    fields = get_user_fields(request.user)
    context['user_fields'] = [x[2] for x in fields]
    list_headers = [(x[0], x[1]) for x in fields]

    sort_headers = SortHeaders(request, list_headers)
    context['headers'] = list(sort_headers.headers())

    context['list_filters'] = get_list_filters(_filter, fields)

    client_ids = list(
        UserProfile.objects.filter(
            client_manager=request.user
        ).values_list('user', flat=True))

    qs = (
        OrderedItem.objects
            .select_related()
            .filter(
                status__in=('received_office',),
                shipment__isnull=True,
                client__id__in=client_ids,
                **_filter.get_filters()))

    order_by = get_ordering(request, list_headers)
    if order_by:
        qs = qs.order_by(order_by)

    total_row = []
    if _filter.is_set:
        total_row = get_total_row(
            qs.exclude(
                status__in=(
                    'failure', 'wrong_number', 'out_of_stock',
                    'cancelled_customer', 'export_part')),
            fields)
    context['total_row'] = total_row

    items_per_page = get_items_per_page(request, session_store_prefix)
    context['items_per_page'] = items_per_page

    paginator = SimplePaginator(request, qs, items_per_page, 'page')
    context['items'] = paginator.get_page_items()
    context['paginator'] = paginator
    return context


@manager_required
@render_to('manager/issues_client.html')
def issues_client(request, client_id):

    context = {}
    session_store_prefix = 'manager_issues_client'

    client_ids = list(
        UserProfile.objects.filter(
            client_manager=request.user
        ).values_list('user', flat=True))

    if int(client_id) not in client_ids:
        raise Http404

    client = get_object_or_404(User, id=client_id)
    context['client'] = client

    if request.method == 'POST':
        redirect_url = reverse("manager_issues_client", args=[client_id])

        if request.POST.get('issued'):
            try:
                order_ids = request.POST.get('issued_orders') or []
                if order_ids:
                    order_ids = map(int, order_ids.split(','))
                package_ids = request.POST.get('issued_packages') or []
                if package_ids:
                    package_ids = map(int, package_ids.split(','))
            except (ValueError, TypeError, AttributeError):
                msg = u"Невалидные данные"
                messages.add_message(request, messages.ERROR, msg)
                return _redirect_after_post(redirect_url)
            else:
                orders = list(OrderedItem.objects.filter(id__in=order_ids))
                packages = list(Package.objects.filter(id__in=package_ids))
                shipments = Shipment._create(request, orders, packages)
                msg = u"Успешно отгружены. Количество новых отгрузок: <b>%i</b>." % len(shipments)
                messages.add_message(request, messages.SUCCESS, msg)
                return _redirect_after_post(redirect_url)

        if 'save_balance_payment' in request.POST:
            forms = BalanceAddForm.get_forms(request)

            context['balance_payment_form_data'] = [
                form.render_js('from_template')
                for form in forms]

            if forms.are_valid():
                for form in forms:
                    data = form.cleaned_data
                    data['user'] = client
                    data['item_type'] = BALANCEITEM_TYPE_PAYMENT
                    BalanceItem(**data).save()

                messages.add_message(
                    request, messages.SUCCESS, u"Оплата добавлена.")
                return _redirect_after_post(redirect_url)

        if 'save_balance_invoice' in request.POST:
            forms = BalanceAddForm.get_forms(request)

            context['balance_invoice_form_data'] = [
                form.render_js('from_template')
                for form in forms]

            if forms.are_valid():
                for form in forms:
                    data = form.cleaned_data
                    data['amount'] = -data['amount']
                    data['user'] = client
                    data['item_type'] = BALANCEITEM_TYPE_INVOICE
                    BalanceItem(**data).save()

                messages.add_message(
                    request, messages.SUCCESS, u"Счёт добавлен.")
                return _redirect_after_post(redirect_url)

    _filter = QSFilter(request, OrderedItemsFilterForm)
    context['filter'] = _filter
    context['qs_filter_param'] = _filter.get_filters()

    fields = get_user_fields(request.user)
    context['user_fields'] = [x[2] for x in fields]
    list_headers = [(x[0], x[1]) for x in fields]

    sort_headers = SortHeaders(request, list_headers)
    context['headers'] = list(sort_headers.headers())

    context['list_filters'] = get_list_filters(_filter, fields)

    qs_filter = _filter.get_filters()

    qs_filter.update({
        'status__in': ('received_office',),
        'shipment__isnull': True,
        'client__id': client_id,
    })
    qs_orders = OrderedItem.objects.select_related().filter(**qs_filter)

    qs_packages = Package.objects.filter(
        status__in=(PACKAGE_STATUS_RECEIVED,),
        client__id=client_id,
        shipment__isnull=True,
    ).order_by('-created_at')
    context['packages'] = qs_packages

    total_orders = get_total(
        qs_orders.exclude(
            status__in=(
                'failure', 'wrong_number', 'out_of_stock',
                'cancelled_customer', 'export_part')),
        fields)

    total_packages = get_total(qs_packages, fields)

    total = dict(Counter(total_orders) + Counter(total_packages))
    context['total_row'] = list(total.get(f[2], '') for f in fields)

    order_by = get_ordering(request, list_headers)
    if order_by:
        qs_orders = qs_orders.order_by(order_by)

    items_per_page = get_items_per_page(request, session_store_prefix)
    context['items_per_page'] = items_per_page
    paginator = SimplePaginator(request, qs_orders, items_per_page, 'page')
    context['items'] = paginator.get_page_items()
    context['paginator'] = paginator
    context['balance_add_form_template'] = BalanceAddForm(
        ).render_js('from_template')
    return context


@manager_required
@render_to('manager/shipments.html')
def shipments(request):
    context = {}
    session_store_prefix = 'manager_shipments'

    _filter = QSFilter(request, ShipmentsFilterForm)
    context['filter'] = _filter

    list_headers = [(x[0], x[1]) for x in MANAGER_SHIPMENTS_FIELD_LIST]
    sort_headers = SortHeaders(request, list_headers)
    context['headers'] = list(sort_headers.headers())
    context['list_filters'] = get_list_filters(
        _filter, MANAGER_SHIPMENTS_FIELD_LIST)

    qs_filter = _filter.get_filters()

    period, period_filter = get_period(
        request, session_store_prefix, "created_at")
    qs_filter.update(period_filter)
    context['period'] = period

    client_ids = list(
        UserProfile.objects.filter(
            client_manager=request.user
        ).values_list('user', flat=True))

    qs = Shipment.objects.select_related().filter(
        client__id__in=client_ids, **qs_filter)

    order_by = get_ordering(request, list_headers, field='created_at')
    if order_by:
        qs = qs.order_by(order_by)

    items_per_page = get_items_per_page(request, session_store_prefix)
    context['items_per_page'] = items_per_page
    paginator = SimplePaginator(request, qs, items_per_page, 'page')
    context['items'] = paginator.get_page_items()
    context['paginator'] = paginator

    return context


@manager_required
@render_to('manager/shipment.html')
def shipment(request, shipment_id):
    context = {}
    session_store_prefix = 'manager_shipment'

    shipment = get_object_or_404(Shipment, id=shipment_id)

    if request.method == 'POST':
        if 'delete_shipment' in request.POST:
            if not request.user.check_password(request.POST.get('password')):
                msg = u"Неверный пароль."
                messages.add_message(request, messages.ERROR, msg)
                return _redirect_after_post(
                    reverse("manager_shipment", args=[shipment.id]))

            shipment._delete()
            messages.add_message(
                request, messages.SUCCESS, u"Отгрузка отменена.")
            return HttpResponseRedirect(reverse("manager_shipments"))

    _filter = QSFilter(request, OrderedItemsFilterForm)
    context['filter'] = _filter
    context['qs_filter_param'] = _filter.get_filters()

    fields = get_user_fields(request.user)
    context['user_fields'] = [x[2] for x in fields]
    list_headers = [(x[0], x[1]) for x in fields]

    sort_headers = SortHeaders(request, list_headers)
    context['headers'] = list(sort_headers.headers())
    context['list_filters'] = get_list_filters(_filter, fields)

    qs_filter = _filter.get_filters()
    qs_filter.update({'shipment__id': shipment.id})

    client_ids = list(
        UserProfile.objects.filter(
            client_manager=request.user
        ).values_list('user', flat=True))

    qs_orders = OrderedItem.objects.select_related().filter(
        client__id__in=client_ids, **qs_filter)

    qs_packages = Package.objects.filter(
        shipment__id=shipment.id,
        client__id__in=client_ids
    ).order_by('-created_at')
    context['packages'] = qs_packages

    order_by = get_ordering(request, list_headers)
    if order_by:
        qs_orders = qs_orders.order_by(order_by)

    total_orders = get_total(
        qs_orders.exclude(
            status__in=(
                'failure', 'wrong_number', 'out_of_stock',
                'cancelled_customer', 'export_part')),
        fields)

    total_packages = get_total(qs_packages, fields)

    total = dict(Counter(total_orders) + Counter(total_packages))
    context['total_row'] = list(total.get(f[2], '') for f in fields)

    items_per_page = get_items_per_page(request, session_store_prefix)
    context['items_per_page'] = items_per_page
    paginator = SimplePaginator(request, qs_orders, items_per_page, 'page')

    context['items'] = paginator.get_page_items()
    context['paginator'] = paginator
    context['shipment'] = shipment

    return context


@manager_required
@render_to('manager/balance.html')
def balance(request):
    context = {}
    session_store_prefix = 'manager_balance'

    _filter = QSFilter(request, BalanceFilterForm)
    context['filter'] = _filter

    list_headers = [(x[0], x[1]) for x in BALANCE_FIELD_LIST]
    sort_headers = SortHeaders(request, list_headers)
    context['headers'] = list(sort_headers.headers())
    context['list_filters'] = get_list_filters(
        _filter, BALANCE_FIELD_LIST)

    qs_filter = _filter.get_filters()

    period, period_filter = get_period(
        request, session_store_prefix, 'created_at')
    context['period'] = period

    client_ids = list(
        UserProfile.objects.filter(
            client_manager=request.user
        ).values_list('user', flat=True))

    qs = BalanceItem.objects.select_related().filter(
        user__id__in=client_ids, **qs_filter).order_by('user')

    res = []
    for user, balanceitems in groupby(qs, lambda x: x.user):

        balance = 0
        last_modified = None

        for b in balanceitems:
            balance += b.amount
            if not last_modified or last_modified < b.created_at:
                last_modified = b.created_at

        res.append({
            'user': user,
            'user_group': UserProfile.objects.get(user=user).client_group,
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


@manager_required
@render_to('manager/balance_client.html')
def balance_client(request, client_id):

    user = get_object_or_404(User, id=client_id)

    client_ids = list(
        UserProfile.objects.filter(
            client_manager=request.user
        ).values_list('user', flat=True))

    if user.id not in client_ids:
        raise Http404

    context = {}
    context['user'] = user
    session_store_prefix = 'manager_balance_client'

    context['balance_payment_form_data'] = []
    context['balance_invoice_form_data'] = []
    if request.method == 'POST':
        redirect_url = reverse('manager_balance_client', args=[user.id])

        if 'save_balance_payment' in request.POST:
            forms = BalanceAddForm.get_forms(request)
            context['balance_payment_form_data'] = [
                form.render_js('from_template') for form in forms]
            if forms.are_valid():
                for form in forms:
                    data = form.cleaned_data
                    data['user'] = user
                    data['item_type'] = BALANCEITEM_TYPE_PAYMENT
                    BalanceItem(**data).save()
                messages.add_message(
                    request, messages.SUCCESS, u'Оплата добавлена.')
                return _redirect_after_post(redirect_url)

        if 'save_balance_invoice' in request.POST:
            forms = BalanceAddForm.get_forms(request)
            context['balance_invoice_form_data'] = [
                form.render_js('from_template') for form in forms]
            if forms.are_valid():
                for form in forms:
                    data = form.cleaned_data
                    data['amount'] = -data['amount']
                    data['user'] = user
                    data['item_type'] = BALANCEITEM_TYPE_INVOICE
                    BalanceItem(**data).save()
                messages.add_message(
                    request, messages.SUCCESS, u'Счёт добавлен.')
                return _redirect_after_post(redirect_url)

    _filter = QSFilter(request, BalanceClientFilterForm)
    context['filter'] = _filter

    list_headers = [(x[0], x[1]) for x in BALANCE_CLIENT_FIELD_LIST]
    sort_headers = SortHeaders(request, list_headers)
    context['headers'] = list(sort_headers.headers())
    context['list_filters'] = get_list_filters(
        _filter, BALANCE_CLIENT_FIELD_LIST)

    qs_filter = _filter.get_filters()

    period, period_filter = get_period(
        request, session_store_prefix, 'created_at')
    qs_filter.update(period_filter)
    context['period'] = period

    qs = BalanceItem.objects.select_related().filter(
        user=user, **qs_filter)

    order_by = get_ordering(request, list_headers, field='created_at')
    if order_by:
        qs = qs.order_by(order_by)

    items_per_page = get_items_per_page(request, session_store_prefix)
    context['items_per_page'] = items_per_page
    paginator = SimplePaginator(request, qs, items_per_page, 'page')
    context['items'] = paginator.get_page_items()
    context['paginator'] = paginator
    context['total_amount'] = sum(x.amount for x in qs)
    context['balance_add_form_template'] = BalanceAddForm().render_js('from_template')
    return context


@manager_required
def balanceitem_delete(request, item_id):
    obj = get_object_or_404(BalanceItem, id=item_id)
    user = obj.user
    obj.delete()
    messages.add_message(request, messages.SUCCESS, u'Запись баланса удалена.')
    return HttpResponseRedirect(reverse(
        'manager_balance_client', args=[user.id]))


@manager_required
def export_order(request):
    user_profile = request.user.get_profile()
    if not user_profile:
        raise Http404

    _filter = QSFilter(request, OrderedItemsFilterForm, clear_old=False)

    client_ids = list(UserProfile.objects.filter(
        client_manager=request.user).values_list('user', flat=True))

    orders = (
        OrderedItem.objects.select_related()
        .filter(client__id__in=client_ids, **_filter.get_filters())
        .order_by('brandgroup__direction__po', 'ponumber'))

    filename = os.path.join(settings.MEDIA_ROOT, 'temp.xls')

    book = xl.Workbook()
    sheet = book.add_sheet('ORDERS')

    fields = tuple((x[0], x[2]) for x in get_user_fields(request.user))

    i = 0
    curr_line = 0
    for key, value in fields:
        sheet.write(curr_line, i, key)
        i += 1

    for order in orders:
        i = 0
        curr_line += 1
        for key, field_name in fields:

            if field_name == 'ponumber':
                value = u'%s%s' % (
                    order.brandgroup.direction.po, order.ponumber or '--')
            elif field_name == 'status':
                value = order.get_status_verbose()
            else:
                value = getattr(order, field_name) or ''
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
