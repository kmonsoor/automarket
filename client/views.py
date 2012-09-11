# -*- coding=UTF-8 -*-
import os
import re
import pyExcelerator as xl
from datetime import datetime
from django.contrib.auth.decorators import login_required
from lib.decorators import render_to
from lib.paginator import SimplePaginator
from lib.sort import SortHeaders
from lib.qs_filter import QSFilter
from data.models import OrderedItem, Brand, BrandGroup, Area, Basket
from data.forms import OrderedItemsFilterForm
from client.forms import SearchForm
from common.views import PartSearch
from django.shortcuts import get_object_or_404
from django.contrib import messages
from django.contrib.auth.models import User
from django.utils.html import escape, mark_safe

from data.settings import AREA_MULTIPLIER_DEFAULT, AREA_DISCOUNT_DEFAULT
from data.forms import CLIENT_FIELD_LIST
from django.http import HttpResponse, HttpResponseRedirect
from django.conf import settings
from client.forms import BasketForm

from django.db import connection

re_RUS = re.compile(u'^([-_+.,:;!?><*&%$#@а-яА-Я0-9\u0451\u0401]|\s)+$')

def normalize_sum(value):
    value = str(value)
    value = value.replace(',','.')
    parts = value.split(".")
    m, d = parts[0:-1], parts[-1]
    value = "".join(m) + "." + d
    return value

@login_required
@render_to('client/search.html')
def search(request):
    found = None
    maker_name = None
    msg = ''

    search_class = PartSearch()
    maker_choices = search_class.maker_choices()

    if request.method == 'POST':
	_post = request.POST.copy()
	_post['part_number'] = re.sub('[^\w\s]', '', _post['part_number']).strip()
        form = SearchForm(_post, maker_choices=maker_choices)
        if form.is_valid():
            maker = form.cleaned_data['maker']
            part_number = form.cleaned_data['part_number']
            found = search_class.search(maker, part_number)
            if not found or not found.get("partnumber"):
                found = None
                msg = u"Ничего не найдено"
    	    elif found and not found.get("MSRP"):
        		found = None
        		msg = u"Деталь не поставляется"
            else:
                # try to find area and get multiplier
                try:
                    # find an area by title
                    area = Area.objects.get(title__iexact=found['brandname'])
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
                except Exception:
                    discount = AREA_DISCOUNT_DEFAULT
                discount = float(discount)

                value = normalize_sum(str(found['MSRP']))

                # we need to remove all "," as separators
                # only last dot should be saved

                try:
                    found['core_price'] = "%.2f" % float(normalize_sum(str(found['core_price'])))
                except Exception:
                    found['core_price'] = 0.00

                found['MSRP'] = float(value) * float(m)
                if 'cost' in found and found['cost']:
                    _msrp = found['cost'] * (float(100) + settings.COST_DEFAULT_MARGIN) / float(100)
                    if _msrp > found['MSRP']:
                        found['MSRP'] = _msrp

                found['your_price'] = found['MSRP'] * (100 - discount) / 100
                found['your_economy'] = found['MSRP'] - found['your_price']
                found['your_economy_perc'] = "%.2f" % (100 - (found['your_price'] / found['MSRP']) * 100)
                # output
                found['MSRP'] = "%.2f" % found['MSRP']
                found['your_price'] = "%.2f" % found['your_price']
                found['your_economy'] = "%.2f" % found['your_economy']
                maker_name = form.cleaned_data['maker']

		#local search
		if 'sub_chain' in found and len(found['sub_chain']) > 1:
		    last = found['sub_chain'].pop(-1)
		    found['sub_chain'] = mark_safe(u"Номер заменён: " + \
		        " -> ".join(found['sub_chain']) + \
		        " -> <b>%s</b>" % last)
		else:
		    if 'sub_chain' in found:
			 del found['sub_chain']
    else:
        form = SearchForm(maker_choices=maker_choices)
        maker = None
    context = {'form': form, 'found': found, 'maker_name': maker_name, 'msg': msg,}
    context['basket_items'] = Basket.objects\
        .filter(user=request.user, order_item_id__isnull=True)
    context['basket_price_sum'] = reduce(lambda x,y: x+y, 
                                         [x.get_price_total() 
                                          for x in context['basket_items']], 0)
    return context

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
		EXCLUDED_FILTER = {
		    'status__in': ('failure',)
		}
	        q, params = qs.exclude(**EXCLUDED_FILTER)._as_sql(connection)
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
            value = getattr(order, value) or ''
            try:
                sheet.write(curr_line,i,value)
                i += 1
            except AssertionError:
                value = unicode(value)
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

@login_required
def basket_add(request):
    user = request.user
    form = BasketForm(request.POST or None, user=request.user)

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
    bitems = [(x,y) for x,y in request.POST.copy().items() if x.startswith("quantity_")]
    errors = {'quantity': False, 'description_ru': False, 'comment1': False}
    # quantity
    for index, q in bitems:
        try:
            q = int(q)
            assert q >= 0
            item_id = int(index.split("_")[1])
            b = Basket.objects.get(user=request.user, pk=item_id)
        except (AssertionError, TypeError, ValueError, IndexEoNrror, Basket.DoesNotExist):
            errors['quantity'] = True
        else:
            b.quantity = q
            b.save()
    
    # find description RUS
    descriptions = [(x,y) for x,y in request.POST.copy().items() if x.startswith("descriptionru_")]
    for index, value in descriptions:
        try:
            item_id = int(index.split("_")[1])
            assert description_ru_validate(value) == True
            
            b = Basket.objects.get(user=request.user, pk=item_id)
            b.description_ru = value
            b.save()
        except (AssertionError, TypeError, ValueError, Basket.DoesNotExist):
            errors['description_ru'] = True
    
    # find comments
    comments = [(x,y) for x,y in request.POST.copy().items() if x.startswith("comment1_")]

    for index, value in [(x,y) for x,y in comments if y]:
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
    brandgroup = BrandGroup.objects.get(title="OEM")
    
    def get_orderitem_data(item):

        sql = """
        select a.area_id, a.brand_id from data_area_brands a
        left join data_brand b on (b.id=a.brand_id)
        left join data_area c on (c.id=a.area_id)
        where c.id in (select area_id from data_brandgroup_area where brandgroup_id=%s)
        and b.title=%s;
        """
        cursor = connection.cursor()
        cursor.execute(sql, [brandgroup.id, item.brand_name])

        rows = cursor.fetchall()
        cursor.close()

        if not rows:
            return (None, item)
        row = dict(zip(('area_id', 'brand_id'), rows[0]))
        # data
        data = {}
        data['brandgroup'] = brandgroup

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

    for t, item in to_save:
        oi = OrderedItem(**t)
        oi.save()
        item.order_item_id = oi.id
        item.save()

    messages.add_message(request, messages.SUCCESS, u"Заказ оформлен")
    return HttpResponseRedirect("/client/")

