# -*- coding=UTF-8 -*-
import os, cjson
import pyExcelerator as xl
from datetime import datetime
from django.contrib.auth.decorators import login_required, permission_required
from lib.decorators import render_to
from lib.paginator import SimplePaginator
from lib.sort import SortHeaders
from lib.qs_filter import QSFilter
from data.models import OrderedItem, Brand, BrandGroup, Area, BrandGroupAreaSettings
from data.forms import OrderedItemsFilterForm
from client.forms import SearchForm
from common.views import PartSearch
from data.settings import AREA_MULTIPLIER_DEFAULT, AREA_DISCOUNT_DEFAULT
from decimal import Decimal
from data.forms import CLIENT_FIELD_LIST
from django.http import HttpResponse
from django.conf import settings

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
                # try to find area and get multiplier
                try:
                    # find an area by title
                    area = Area.objects.get(title__icontains=found['brandname'])
                    brand_group = BrandGroup.objects.get(title="OEM")
                    # we need to find a valid multiplier for this area 
                    # TODO - hardcoded 'OEM', we need do more sofisticated algo
                except (BrandGroup.DoesNotExist, Area.DoesNotExist, Area.MultipleObjectsReturned, ValueError):
                    # not price_setings for OEM and this area
                    m = AREA_MULTIPLIER_DEFAULT
                else:
                    m, d = area.get_brandgroup_settings(brand_group)
                # TODO - add brand_group to get_discount
                try:
                    discount = request.user.get_profile() \
                                      .get_discount(brand_group=brand_group, area=area)
                except Exception, e:
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
        
        # calculate totals by filter
        self.total_row = {}
        if self.filter.is_set:
	        from django.db import connection
	        td = "U0"
	        q, params = qs._as_sql(connection)
	        from_clause = q.split("FROM")[1]
	        sql = \
	        """
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
	            self.total_row = dict(zip( \
		        ('total_cost', 'weight', 'delivery', 'price_sale'), \
		        res[0]))
    	    
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



@login_required
def export_order(request):
    LIST_HEADERS = (
        (u'PO', 'po_verbose'),
        (u'Поставщик', 'brandgroup'),
        (u'BRAND', 'brand'),
        (u'AREA', 'area'),
        (u'PART #', 'part_number'),
        (u'Q', 'quantity'),
        (u'ЗАМЕНА', 'part_number_superseded'),
        (u'RUS', 'description_ru'),
        (u'ENG', 'description_en'),
        (u'WEIGHT', 'weight'),
        (u'SHIPPING', 'delivery'),
        (u'PRICE', 'price_sale'),
        (u'NEW PRICE', 'price_discount'),
        (u'COST', 'cost'),
        (u'TOTAL COST', 'total_cost'),
        (u'Инвойс', 'invoice_code'),
        (u'Статус', 'status'),
    )
    
    
    def get_list_headers():
        try:
            fields = request.user.get_profile().get_order_fields()
        except Exception, e:
            fields = None
        if fields:
            return [(x[0], x[1]) for x in LIST_HEADERS if x[1] in fields]
        return LIST_HEADERS
    
   
    _filter = QSFilter(request, OrderedItemsFilterForm, clear_old=False)
    
    orders = OrderedItem.objects.select_related() \
                        .filter(client=request.user) \
                        .filter(**_filter.get_filters()) \
                        .order_by('brandgroup__direction__po', 'ponumber')
   
    filename = os.path.join(settings.MEDIA_ROOT,'temp.xls')
    book = xl.Workbook()
    sheet = book.add_sheet('ORDERS')

    i = 0
    curr_line = 0
    for key, value in get_list_headers():
        sheet.write(curr_line,i,key)
        i += 1

    for order in orders:
        i = 0
        curr_line += 1
        for key, value in get_list_headers():
            value = unicode(getattr(order, value)) \
                if getattr(order, value) is not None else ''
            sheet.write(curr_line,i,value)
            i += 1

    book.save(filename)
    os.chmod(filename, 0777)
    content = open(filename,'rb').read()
    response = HttpResponse(content, mimetype='application/vnd.ms-excel')
    name = '%s-%s.xls' % ('orders',datetime.now().strftime('%m-%d-%Y-%H-%M'))
    response['Content-Disposition'] = 'inline; filename=%s' % name
    os.remove(filename)
    return response

