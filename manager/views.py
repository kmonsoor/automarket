# -*- coding=utf-8 -*-
import re
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
from django.utils.datastructures import MultiValueDict

from lib.decorators import render_to
from lib.paginator import SimplePaginator
from lib.sort import SortHeaders
from lib.qs_filter import QSFilter
from lib.collections import Counter
from lib.xlsreader import readexcel

from common.decorators import manager_required
from common.views import PartSearch

from data.models import (
    OrderedItem, UserProfile, Invoice, Package, Shipment, BalanceItem,
    BALANCEITEM_TYPE_INVOICE, PACKAGE_STATUS_RECEIVED,
    BALANCEITEM_TYPE_PAYMENT, BrandGroup,
    search_local, search_analogs_local, Basket, calc_parts_manager_client
)

from data.forms import (
    OrderedItemsFilterForm, MANAGER_FIELD_LIST,
    InvoicesFilterForm, INVOICES_FIELD_LIST,
    MANAGER_SHIPMENTS_FIELD_LIST, ShipmentsFilterForm,
    BalanceFilterForm, BALANCE_FIELD_LIST,
    BalanceClientFilterForm, BALANCE_CLIENT_FIELD_LIST, PackageItemForm,
    BalanceAddForm, ImportOrderXlsForm
)

from manager.forms import OrderItemForm, SearchForm

import logging
logger = logging.getLogger("manager.views")


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
    if not fields:
        fields = MANAGER_FIELD_LIST
    return fields


def get_total(qs, fields):
    if not qs:
        return {}

    total = defaultdict(float)
    for i in qs:
        total['total_cost'] += (i.total_cost or 0)
        total['delivery'] += (i.delivery or 0)
        total['price_manager'] += (i.price_manager or 0)
        total['total_manager'] += (i.total_manager or 0)
        total['price_sale'] += i.quantity * (
            (getattr(i, 'price_discount', 0) or 0)
            or
            getattr(i, 'price_sale', 0) or 0)

    return total


def get_total_row(qs, fields):
    total = get_total(qs, fields)
    return list(total.get(f[2], u"") for f in fields)


def get_total_exclude_statuses():
    return (
        'failure', 'wrong_number', 'out_of_stock',
        'cancelled_customer', 'export_part',)


def get_total_orders_with_packages(qs_orders, qs_packages, fields):
    total_orders = get_total(
        qs_orders.exclude(status__in=get_total_exclude_statuses()), fields)
    total_packages = get_total(qs_packages, fields)
    total_dict = dict(Counter(total_orders) + Counter(total_packages))
    total = list(total_dict.get(f[2], '') for f in fields)
    return total


def _random(length=5):
    yield "".join([random.choice(string.letters) for x in xrange(0, length)])


def _redirect_after_post(url):
    return HttpResponseRedirect(
        "%s?%s=%s" % (url, _random().next(), _random().next()))

def get_client_choice(manager):
    return (('', 'выбрать'),) + tuple(
        UserProfile.objects
            .filter(client_manager=manager)
            .order_by('user__username')
            .values_list('user__id', 'user__username')
        )


class ManagerOrderItems(object):
    filter_form = OrderedItemsFilterForm
    session_store_prefix = 'manager_index'
    default_order_by = 'created'

    def __init__(self, request):
        self.request = request
        self.items = self.get_items()

    @property
    def filter(self):
        return QSFilter(self.request, self.filter_form)

    @property
    def fields(self):
        return get_user_fields(self.request.user)

    @property
    def user_fields(self):
        return list(x[2] for x in self.fields)

    @property
    def headers(self):
        sort_headers = SortHeaders(
            self.request, [(x[0], x[1]) for x in self.fields])
        return list(sort_headers.headers())

    @property
    def filters(self):
        return get_list_filters(self.filter, self.fields)

    @property
    def period(self):
        return get_period(
            self.request, self.session_store_prefix, self.default_order_by)[0]

    @property
    def period_filter(self):
        return get_period(
            self.request, self.session_store_prefix, self.default_order_by)[1]

    @property
    def items_per_page(self):
        return get_items_per_page(self.request, self.session_store_prefix)

    @property
    def ordering(self):
        return get_ordering(
            self.request, [(x[0], x[1]) for x in self.fields], self.default_order_by)

    @property
    def client_ids(self):
        return list(
            UserProfile.objects.filter(
                client_manager=self.request.user
            ).values_list('user', flat=True))

    @property
    def qs_filter(self):
        qs_filter = self.filter.get_filters()
        qs_filter.update(self.period_filter)
        return qs_filter

    def get_items(self):

        qs = OrderedItem.objects.select_related().filter(
            client__id__in=self.client_ids, **self.qs_filter)

        if self.ordering:
            qs = qs.order_by(self.ordering)

        if self.filter.is_set:
            self.total = get_total_row(
                qs.exclude(status__in=get_total_exclude_statuses()),
                self.fields)

        self.paginator = SimplePaginator(
            self.request, qs, self.items_per_page, 'page')

        # grouping parents orders
        if not self.filter.is_set:

            items_list = list(
                x for x in self.paginator.get_page_items()
                if not x.parent)

            for order in OrderedItem.objects.filter(
                parent__id__in=set(x.id for x in items_list)
            ):
                items_list.insert(items_list.index(order.parent), order)

            self.paginator.page.object_list = items_list

        return self.paginator.get_page_items()


@manager_required
@render_to('manager/index.html')
def index(request):
    context = {}
    context['cl'] = ManagerOrderItems(request)
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


class ManagerInvoices(ManagerOrderItems):
    filter_form = InvoicesFilterForm
    session_store_prefix = 'manager_invoices'
    default_order_by = 'received_at'

    @property
    def fields(self):
        return INVOICES_FIELD_LIST

    def get_items(self):

        invoice_codes = set(OrderedItem.objects.filter(
            client__id__in=self.client_ids
        ).values_list('invoice_code', flat=True))

        qs = Invoice.objects.select_related().filter(
            code__in=invoice_codes, **self.qs_filter)

        if self.ordering:
            qs = qs.order_by(self.ordering)

        self.paginator = SimplePaginator(
            self.request, qs, self.items_per_page, 'page')
        return self.paginator.get_page_items()


@manager_required
@render_to('manager/invoices.html')
def invoices(request):
    context = {}
    context['cl'] = ManagerInvoices(request)
    return context



class ManagerInvoice(ManagerOrderItems):
    session_store_prefix = 'manager_invoice'

    def __init__(self, *args, **kwargs):
        self.invoice = kwargs.pop('invoice')
        super(ManagerInvoice, self).__init__(*args, **kwargs)

    @property
    def qs_filter(self):
        qs_filter = super(ManagerInvoice, self).qs_filter
        qs_filter['invoice_code__contains'] = self.invoice.code
        return qs_filter

    def get_items(self):

        qs_orders = OrderedItem.objects.select_related().filter(
            client__id__in=self.client_ids, **self.qs_filter)

        if self.ordering:
            qs_orders = qs_orders.order_by(self.ordering)

        qs_packages = Package.objects.filter(
            client__id__in=self.client_ids,
            invoice=self.invoice
        ).order_by('-created_at')
        self.packages = qs_packages

        self.total = get_total_orders_with_packages(
            qs_orders, qs_packages, self.fields)

        self.paginator = SimplePaginator(
            self.request, qs_orders, self.items_per_page, 'page')

        return self.paginator.get_page_items()


@manager_required
@render_to('manager/invoice.html')
def invoice(request, invoice_id):
    context = {}
    package_data = []

    invoice = get_object_or_404(Invoice, id=invoice_id)
    invoice.calculate_status()

    client_choice = get_client_choice(request.user)

    package_forms_is_valid = True
    if request.method == 'POST':
        redirect_url = reverse("manager_invoice", args=[invoice.id])

        if 'save_package' in request.POST:
            package_forms = PackageItemForm.get_forms(
                request, kwargs=dict(client_choice=client_choice))
            context['package_forms'] = package_forms

            package_data = [
                package_form.render_js('from_template')
                for package_form in package_forms]

            package_forms_is_valid = package_forms.are_valid()

            if package_forms_is_valid:
                for form in package_forms:
                    data = form.cleaned_data
                    data['manager'] = request.user
                    data['invoice'] = invoice
                    Package(**data).save()
                messages.add_message(
                    request, messages.SUCCESS, u"Упаковка добавлена.")
                return _redirect_after_post(redirect_url)

    context['cl'] = ManagerInvoice(request, invoice=invoice)
    context['package_template'] = PackageItemForm(
        client_choice=client_choice).render_js('from_template')
    context['package_data'] = package_data
    context['package_forms_is_valid'] = package_forms_is_valid
    return context


class ManagerIssues(ManagerOrderItems):
    session_store_prefix = 'manager_issues'

    @property
    def qs_filter(self):
        qs_filter = super(ManagerIssues, self).qs_filter
        qs_filter['status'] = 'received_office'
        return qs_filter


@manager_required
@render_to('manager/issues.html')
def issues(request):
    context = {}

    if request.method == 'POST':
        redirect_url = reverse('manager_issues')

        if request.POST.get('issued'):
            try:
                order_ids = map(int, request.POST.get('issued_orders').split(','))
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

    context['cl'] = ManagerIssues(request)
    return context


class ManagerIssuesClient(ManagerOrderItems):
    session_store_prefix = 'manager_issues_client'

    def __init__(self, *args, **kwargs):
        self.client = kwargs.pop('client')
        super(ManagerIssuesClient, self).__init__(*args, **kwargs)

    @property
    def qs_filter(self):
        qs_filter = super(ManagerIssuesClient, self).qs_filter
        qs_filter['status'] = 'received_office'
        qs_filter['client__username__contains'] = self.client.username
        return qs_filter

    def get_items(self):

        qs_orders = OrderedItem.objects.select_related().filter(
            client__id__in=self.client_ids, **self.qs_filter)

        if self.ordering:
            qs_orders= qs_orders.order_by(self.ordering)

        qs_packages = Package.objects.filter(
            status__in=(PACKAGE_STATUS_RECEIVED,),
            client__id=self.client.id
        ).order_by('-created_at')
        self.packages = qs_packages

        self.total = get_total_orders_with_packages(
            qs_orders, qs_packages, self.fields)

        self.paginator = SimplePaginator(
            self.request, qs_orders, self.items_per_page, 'page')

        return self.paginator.get_page_items()


@manager_required
@render_to('manager/issues_client.html')
def issues_client(request, client_id):
    context = {}

    client_ids = list(
        UserProfile.objects.filter(
            client_manager=request.user
        ).values_list('user', flat=True))

    try:
        if int(client_id) not in client_ids:
            raise ValueError
    except (ValueError, TypeError):
        raise Http404

    client = get_object_or_404(User, id=client_id)

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

    context['cl'] = ManagerIssuesClient(request, client=client)
    context['balance_add_form_template'] = BalanceAddForm().render_js('from_template')
    return context


class ManagerShipments(ManagerOrderItems):
    filter_form = ShipmentsFilterForm
    session_store_prefix = 'manager_shipments'
    default_order_by = 'created_at'

    @property
    def fields(self):
        return MANAGER_SHIPMENTS_FIELD_LIST

    def get_items(self):

        qs = Shipment.objects.select_related().filter(
            client__id__in=self.client_ids, **self.qs_filter)

        if self.ordering:
            qs = qs.order_by(self.ordering)

        self.paginator = SimplePaginator(
            self.request, qs, self.items_per_page, 'page')
        return self.paginator.get_page_items()


@manager_required
@render_to('manager/shipments.html')
def shipments(request):
    context = {}
    context['cl'] = ManagerShipments(request)
    return context


class ManagerShipment(ManagerOrderItems):
    session_store_prefix = 'manager_shipment'

    def __init__(self, *args, **kwargs):
        self.shipment = kwargs.pop('shipment')
        super(ManagerShipment, self).__init__(*args, **kwargs)

    @property
    def qs_filter(self):
        qs_filter = super(ManagerShipment, self).qs_filter
        qs_filter['shipment__id'] = self.shipment.id
        return qs_filter

    def get_items(self):

        qs_orders = OrderedItem.objects.select_related().filter(
            client__id__in=self.client_ids, **self.qs_filter)

        if self.ordering:
            qs_orders = qs_orders.order_by(self.ordering)

        qs_packages = Package.objects.filter(
            shipment__id=self.shipment.id,
            client__id__in=self.client_ids
        ).order_by('-created_at')
        self.packages = qs_packages

        self.total = get_total_orders_with_packages(
            qs_orders, qs_packages, self.fields)

        self.paginator = SimplePaginator(
            self.request, qs_orders, self.items_per_page, 'page')

        return self.paginator.get_page_items()


@manager_required
@render_to('manager/shipment.html')
def shipment(request, shipment_id):
    context = {}

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

    context['cl'] = ManagerShipment(request, shipment=shipment)

    return context


class ManagerBalance(ManagerOrderItems):
    filter_form = BalanceFilterForm
    session_store_prefix = 'manager_balance'
    default_order_by = 'created_at'

    @property
    def fields(self):
        return BALANCE_FIELD_LIST

    def get_items(self):

        qs = BalanceItem.objects.select_related().filter(
            user__id__in=self.client_ids, **self.qs_filter
        ).order_by('user')

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

        self.total = sum(x['balance'] for x in res)

        self.paginator = SimplePaginator(
            self.request, res, self.items_per_page, 'page')
        return self.paginator.get_page_items()


@manager_required
@render_to('manager/balance.html')
def balance(request):
    context = {}
    context['cl'] = ManagerBalance(request)
    return context


class ManagerBalanceClient(ManagerOrderItems):
    filter_form = BalanceClientFilterForm
    session_store_prefix = 'manager_balance_client'
    default_order_by = 'created_at'

    def __init__(self, *args, **kwargs):
        self.client = kwargs.pop('client')
        super(ManagerBalanceClient, self).__init__(*args, **kwargs)

    @property
    def fields(self):
        return BALANCE_CLIENT_FIELD_LIST

    def get_items(self):

        qs = BalanceItem.objects.select_related().filter(
            user=self.client, **self.qs_filter)

        if self.ordering:
            qs = qs.order_by(self.ordering)

        self.total = sum(x.amount for x in qs)

        self.paginator = SimplePaginator(
            self.request, qs, self.items_per_page, 'page')
        return self.paginator.get_page_items()


@manager_required
@render_to('manager/balance_client.html')
def balance_client(request, client_id):
    context = {}

    client_ids = list(
        UserProfile.objects.filter(
            client_manager=request.user
        ).values_list('user', flat=True))

    try:
        if int(client_id) not in client_ids:
            raise ValueError
    except (ValueError, TypeError):
        raise Http404

    client = get_object_or_404(User, id=client_id)

    context['balance_payment_form_data'] = []
    context['balance_invoice_form_data'] = []
    if request.method == 'POST':
        redirect_url = reverse('manager_balance_client', args=[client.id])

        if 'save_balance_payment' in request.POST:
            forms = BalanceAddForm.get_forms(request)
            context['balance_payment_form_data'] = [
                form.render_js('from_template') for form in forms]
            if forms.are_valid():
                for form in forms:
                    data = form.cleaned_data
                    data['user'] = client
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
                    data['user'] = client
                    data['item_type'] = BALANCEITEM_TYPE_INVOICE
                    BalanceItem(**data).save()
                messages.add_message(
                    request, messages.SUCCESS, u'Счёт добавлен.')
                return _redirect_after_post(redirect_url)

    context['cl'] = ManagerBalanceClient(request, client=client)
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
@render_to('manager/order.html')
def order(request):
    context = {}

    client_choice = get_client_choice(request.user)

    user_profile = request.user.get_profile()
    if not user_profile or not user_profile.can_edit_price_base:
        raise Http404

    if request.method == 'POST':
        item_forms = OrderItemForm.get_forms(
            request, kwargs=dict(client_choice=client_choice))
        item_data = [
            item_form.render_js('from_template')
            for item_form in item_forms]

        if item_forms.are_valid():
            client_order_numbers = {}

            for form in item_forms:
                fdata = form.cleaned_data
                supplier_id = fdata.pop('supplier')

                if fdata['client'] not in client_order_numbers:
                    client_order_numbers[fdata['client']] = \
                        OrderedItem.objects.get_next_client_order_id(fdata['client'])

                fdata['client_order_id'] = client_order_numbers[fdata['client']]
                fdata['manager'] = request.user
                fdata['brandgroup'] = BrandGroup.objects.get(id=supplier_id)
                fdata['status'] = 'order'

                OrderedItem(**fdata).save()

                messages.add_message(
                    request, messages.SUCCESS, u"Заказ отправлен")

            return _redirect_after_post(reverse('manager_order'))

    else:
        item_data = [
            OrderItemForm(
                client_choice=client_choice
            ).render_js('from_template')
        ] * 3

    context['form_template'] = OrderItemForm(
        client_choice=client_choice).render_js('from_template')
    context['form_data'] = item_data
    return context


@manager_required
@render_to('manager/search.html')
def search(request):
    parts = []
    analogs = []
    msg = ''

    search_external = PartSearch()
    maker_choice = search_external.maker_choices()
    client_choice = get_client_choice(request.user)
    show_maker_field = False
    client = None

    if request.method == 'POST':
        _post = request.POST.copy()

        _post['part_number'] = re.sub(
            '[^\w]', '', _post['part_number']).strip().upper()

        form = SearchForm(
            _post, maker_choice=maker_choice, client_choice=client_choice)

        if form.is_valid():
            maker = form.cleaned_data['maker']
            part_number = form.cleaned_data['part_number']

            try:
                client = User.objects.get(id=form.cleaned_data['client'])
            except:
                client = None

            if client:
                request.session['search_form_client'] = client.id
                request.session.modified = True

            founds = search_local(maker, part_number)
            analog_founds = search_analogs_local(part_number, maker)

            if founds:
                makers = set(x['maker'] for x in founds)
                if len(makers) > 1:
                    show_maker_field = True
                    form.fields['maker'].widget.choices = [
                        ('', '----')] + list((x, x) for x in makers)
                else:
                    parts = calc_parts_manager_client(founds, request.user, client)
                    analogs = calc_parts_manager_client(analog_founds, request.user, client)

            if not founds:
                if analog_founds:
                    analogs = calc_parts_manager_client(analog_founds, request.user, client)
                else:
                    show_maker_field = True
                    if maker:
                        founds = search_external.search(maker, part_number)
                        if founds:
                            parts = calc_parts_manager_client(
                                founds, request.user, client)
                        else:
                            msg = u"Ничего не найдено"
    else:
        initial = {}
        if not request.GET.get('new'):
            initial = {'client': request.session.get('search_form_client')}
        form = SearchForm(
            maker_choice=maker_choice,
            client_choice=client_choice,
            initial=initial)

    context = {
        'form': form,
        'data': parts,
        'analogs': analogs,
        'msg': msg,
        'show_maker_field': show_maker_field,
        'client': client,
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


@manager_required
@render_to('manager/import_order.html')
def import_order(request):

    user_profile = request.user.get_profile()
    if not user_profile or not user_profile.can_edit_price_base:
        raise Http404
    
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

    def swap_keys(row, num):

        res = {}
        for k, v in row.items():
            k = k.strip().upper()

            if k == 'DIR':
                try:
                    res[get_field_name(k) + '.%d' % num] = [
                        BrandGroup.objects.get(title__iexact=v[0]).id]
                except BrandGroup.DoesNotExist:
                    res[get_field_name(k) + '.%d' % num] = ''

            elif k in ('BRAND', 'AREA',):
                res[get_field_name(k) + '.%d' % num] = [v[0].capitalize()]

            elif k == 'CL':
                try:
                    res[get_field_name(k) + '.%d' % num] = [
                        User.objects.get(username__iexact=v[0].lower()).id]
                except User.DoesNotExist:
                    res[get_field_name(k) + '.%d' % num] = ''

            elif k == 'COMENT 2':
                res[get_field_name(k) + '.%d' % num] = ''

            else:
                res[get_field_name(k) + '.%d' % num] = v

        res['id' + '.%d' % num] = ''

        return res

    response = {}
    client_choice = get_client_choice(request.user)

    if request.method == 'POST':
        form = ImportOrderXlsForm(request.POST, request.FILES)
        if form.is_valid():
            data = {}
            f = form.cleaned_data['xls_file']
            try:
                xls = readexcel(file_contents=f.read())
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
                    item_forms = OrderItemForm.get_forms(
                        request, kwargs=dict(client_choice=client_choice))
                    form_list = [
                        item_form.render_js('from_template')
                        for item_form in item_forms]
                    response['form_data'] = form_list
            finally:
                f.close()
    else:
        form = ImportOrderXlsForm()

    response['form'] = form
    response['form_template'] = OrderItemForm(
        client_choice=client_choice
    ).render_js('from_template')
    return response