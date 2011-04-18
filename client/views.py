# -*- coding=UTF-8 -*-

from datetime import datetime
from django.contrib.auth.decorators import login_required, permission_required
from lib.decorators import render_to
from lib.paginator import SimplePaginator
from lib.sort import SortHeaders
from lib.qs_filter import QSFilter
from data.models import OrderedItem, Brand, BrandGroup, Area
from data.forms import OrderedItemsFilterForm
from client.forms import SearchForm
from common.views import PartSearch
from data.settings import AREA_MULTIPLIER_DEFAULT, AREA_DISCOUNT_DEFAULT
from decimal import Decimal
from data.forms import CLIENT_FIELD_LIST

@login_required
@render_to('client/search.html')
def search(request):
    found = None
    maker_name = None
    msg = ''
    if request.method == 'POST':
        form = SearchForm(request.POST)
        if form.is_valid():
            maker = form.cleaned_data['maker']
            part_number = form.cleaned_data['part_number']
            found = PartSearch().search(maker, part_number)
            if not found:
                msg = u"Ничего не найдено"
            else:
                # try to find brand and get multiplier
                try:
                    area = Area.objects.get(title__icontains=found['brandname'])
                    m = area.multiplier or AREA_MULTIPLIER_DEFAULT
                except (Area.DoesNotExist, Area.MultipleObjectsReturned):
                    m = AREA_MULTIPLIER_DEFAULT
                try:
                    discount = request.user.get_profile().get_discount(area)
                except Exception, e:
                    print e
                    discount = AREA_DISCOUNT_DEFAULT
                discount = float(discount)
                found['MSRP'] = float(found['MSRP']) * float(m)
                found['your_price'] = found['MSRP']*(100-discount)/100
                found['your_economy'] = found['MSRP'] - found['your_price']
                found['your_economy_perc'] = 100 - (found['your_price']/found['MSRP'])*100
                # output
                found['MSRP'] = "%.2f" % found['MSRP']
                found['your_price'] = "%.2f" % found['your_price']
                found['your_economy'] = "%.2f" % found['your_economy']
            maker_name = PartSearch().get_maker_name(maker)

    else:
        form = SearchForm()

    return {'form': form, 'found': found, 'maker_name': maker_name, 'msg': msg,}

class ClientOrderItemDisplay(object):
    def __init__(self, obj, field, format):
        val = getattr(obj, field, u"")
        if val == None:
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
    def __init__(self, request, filter_form):
        self.user = request.user
        self.set_fields()
        self.request = request

        _filter = QSFilter(request, filter_form)
        if _filter.modified:
            current_page = 1
        self.filter = _filter

        current_page = request.GET.get('page', 1)
        items_per_page = request.GET.get('items_per_page', None)
        if not items_per_page:
            items_per_page = request.session.get('items_per_page', None)
        else:
            request.session['items_per_page'] = items_per_page
            request.session.modified = True
        if not items_per_page:
            items_per_page = 20
        self.items_per_page = int(items_per_page)

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
        self.LIST_HEADERS = [(x[0],x[1]) for x in self.CLIENT_FIELDS]

    def result_list(self):
        return [ClientOrderItemRow([(x[2],x[3]) \
                 for x in self.CLIENT_FIELDS], obj) \
                 for obj in self.get_query_set()]


    def list_headers(self):
        sort_headers = SortHeaders(self.request, self.LIST_HEADERS)
        return list(sort_headers.headers())

    def list_filters(self):
        def _inner():
            for x in self.CLIENT_FIELDS:
                try:
                    form_field = self.filter.form.__getitem__(x[4])
                    yield form_field
                except Exception, e:
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

        qs = OrderedItem.objects.select_related() \
                        .filter(client=self.request.user) \
                        .filter(**self.filter.get_filters())
        if order_by:
            qs = qs.order_by(order_by)

        self.paginator = SimplePaginator(self.request, qs, self.items_per_page, 'page')
        return self.paginator.get_page_items()

@login_required
@render_to('client/index.html')
def index(request):
    response = {}
    cl = ClientOrderItemList(request, OrderedItemsFilterForm)
    response['cl'] = cl
    response['paginator'] = cl.paginator
    response['items_per_page'] = cl.items_per_page
    return response


@render_to('client/help/list.html')
def help_area_list(request, brandgroup_id):
    try:
        area = BrandGroup.objects.get(id = brandgroup_id).area.all()
    except BrandGroup.DoesNotExist:
        area = []

    return {'list': area,}


@render_to('client/help/list.html')
def help_brands_list(request, area_id):
    try:
        brands = Area.objects.get(id = area_id).brands.all().order_by('title')
    except Area.DoesNotExist:
        brands = []

    return {'list': brands,}

