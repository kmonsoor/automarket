# -*- coding=utf-8 -*-

import os
import pyExcelerator as xl
from datetime import datetime

from django.contrib.auth.models import User
from django.contrib.auth.decorators import login_required
from django.shortcuts import get_object_or_404, render_to_response
from django.http import Http404, HttpResponseRedirect, HttpResponse
from django.utils.datastructures import MultiValueDict
from django.utils import simplejson
from django.conf import settings

from lib.decorators import render_to, ajax_request
from lib.paginator import SimplePaginator
from lib.sort import SortHeaders
from lib.qs_filter import QSFilter
from lib.helpers import next, reverse
from lib import xlsreader

from cp.forms import OrderItemForm, ImportXlsForm, SearchForm
from data.models import Direction, BrandGroup, Brand, Car, OrderedItem, ORDER_ITEM_STATUSES
from data.forms import OrderedItemsFilterForm, OrderedItemForm
from common.views import PartSearch

@login_required
@render_to('cp/search.html')
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
                msg = u"Not Found"
            maker_name = PartSearch().get_maker_name(maker)

    else:
        form = SearchForm()

    return {'form': form, 'found': found, 'maker_name': maker_name, 'msg': msg,}


def get_status_options():
    statuses_dict = ORDER_ITEM_STATUSES
    status_options_str = '{';
    status_options = []
    k = 0
    for i in statuses_dict:
        k += 1
        status_options_str += '"%s":"%s"' % (i[0], i[1])
        status_options.append({'value':i[0],'option':i[1]})
        if k < len(ORDER_ITEM_STATUSES):
            status_options_str += ','
    status_options_str += '}'
    return (status_options_str, status_options)


@login_required
@render_to('cp/index.html')
def index(request):
    context = {}
    current_page = request.GET.get('page', 1)
    items_per_page = request.GET.get('items_per_page', None)
    if not items_per_page:
        items_per_page = request.session.get('cp_index_items_per_page', None)
    else:
        request.session['cp_index_items_per_page'] = items_per_page
        request.session.modified = True
    if not items_per_page:
        items_per_page = 20
    items_per_page = int(items_per_page)
    
    context['items_per_page'] = items_per_page
    _filter = QSFilter(request, OrderedItemsFilterForm)
    if _filter.modified:
        current_page = 1
    context['filter'] = _filter

    LIST_HEADERS = (
                    (u'PO', 'ponumber'),
                    (u'Поставщик', 'brandgroup'),
                    (u'BRAND', 'brandgroup__brands'),
                    (u'PART #', 'part_number'),
                    (u'COMMENT 2', None),
                    (u'Q', None),
                    (u'PRICE IN', None),
                    (u'TOTAL', None),
                    (u'ЗАМЕНА', None),
                    (u'ID', 'manager'),
                    (u'CL', 'client'),
                    (u'RUS', None),
                    (u'ENG', None),
                    (u'LIST', None),
                    (u'WEIGHT', None),
                    (u'SHIPPING', None),
                    (u'PRICE', None),
                    (u'NEW PRICE', None),
                    (u'COST', None),
                    (u'TOTAL COST', None),
                    (u'Инвойс', 'invoice_code'),
                    (u'Статус', 'status'),

                    )
    sort_headers = SortHeaders(request, LIST_HEADERS)
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

    qs = OrderedItem.objects.select_related().filter(**_filter.get_filters()).exclude(status='shipped')

    if order_by:
        qs = qs.order_by(order_by)
    paginator = SimplePaginator(request, qs, items_per_page, 'page')
    #paginator.set_page(current_page)
    context['status_options_str'], context['status_options'] = get_status_options()
    context['items'] = paginator.get_page_items();
    context['paginator'] = paginator
    context['brands'] = ','.join(['{"id":%s,"name":"%s"}' % (brand.id, brand.title) for brand in Brand.objects.all()])
    return context


@login_required
@render_to('cp/order.html')
def order(request):
    response = {}
    if request.method == 'POST':
        item_forms = OrderItemForm.get_forms(request)
        item_data = [item_form.render_js('from_template') for item_form in item_forms]
        if item_forms.are_valid():
            for form in item_forms:
                data = form.cleaned_data
                supplier_id = data['supplier']
                ponumber = OrderedItem.objects.get_next_ponumber(supplier_id)
                data['ponumber'] = ponumber
                data['manager'] = request.user
                data['brandgroup'] = BrandGroup.objects.get(id=supplier_id)
                data.pop('supplier')
                item = OrderedItem(**data).save()
            return HttpResponseRedirect('/cp/order/')
    else:
        item_data = [OrderItemForm().render_js('from_template'),OrderItemForm().render_js('from_template'),OrderItemForm().render_js('from_template')]

    response['page_template'] = OrderItemForm().render_js('from_template')
    response['page_data'] = item_data

    # search_form
    response['search_form'] = SearchForm()
    return response

@render_to('cp/groups.html')
def groups(request):
    qs = OrderedItem.objects.filter(status='order')
    orders_by_brandgroup = {}
    for order in qs:
        if order.brandgroup not in orders_by_brandgroup:
            orders_by_brandgroup[order.brandgroup] = []
        orders_by_brandgroup[order.brandgroup].append(order)

    return {
            'orders_by_brandgroup':orders_by_brandgroup
            }


class OrderedItemSaver(object):
    error = None
    def save_part_number(self, obj, value):
        try:
            obj.part_number = value
            obj.save()
        except Exception, e:
            pass
        return obj.part_number

    def save_comment_customer(self, obj, value):
        try:
            obj.comment_customer = value
            obj.save()
        except Exception, e:
            pass
        return obj.comment_customer

    def save_price_invoice(self, obj, value):
        try:
            obj.price_invoice = value
            obj.save()
        except Exception, e:
            pass
        return obj.price_invoice

    def save_part_number_superseded(self, obj, value):
        try:
            obj.part_number_superseded = value
            obj.save()
        except Exception, e:
            pass
        return obj.part_number_superseded

    def save_description_ru(self, obj, value):
        try:
            obj.description_ru = value
            obj.save()
        except Exception, e:
            pass
        return obj.description_ru

    def save_description_en(self, obj, value):
        try:
            obj.description_en = value
            obj.save()
        except Exception, e:
            pass
        return obj.description_en

    def save_price_base(self, obj, value):
        try:
            obj.price_base = value
            obj.save()
        except Exception, e:
            pass
        return obj.price_base

    def save_weight(self, obj, value):
        try:
            obj.weight = value
            obj.save()
        except Exception, e:
            pass
        return obj.weight

    def save_price_discount(self, obj, value):
        try:
            obj.price_discount = value
            obj.save()
        except Exception, e:
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
            obj.save()
        except Exception, e:
            pass
        return obj.status

    def save_invoice_code(self, obj, value):
        try:
            obj.invoice_code = value
            obj.save()
        except Exception, e:
            pass
        return obj.invoice_code

@ajax_request
def position_edit(request, content_type, id):
    models = {
              'ordered_item':OrderedItem,
              }
    forms = {
              'ordered_item':OrderedItemForm,
              }
    savers = {
              'ordered_item':OrderedItemSaver,
              }
    item = get_object_or_404(models[content_type], id=id)
    response = {}
    try:
        old_value = getattr(item, request.POST['type'])
    except:
        response['error'] = 'Attribute does not exist'
        return response
    form = forms[content_type]({request.POST['type']:request.POST['value']})
    if form.is_valid():
        try:
            value = form.cleaned_data[request.POST['type']]
        except Exception, e:
            response['error'] = e
            return response

        saver = savers[content_type]()
        response['value'] = getattr(saver, 'save_' + request.POST['type'])(item, value)
        response['error'] = saver.error
    else:
        response['value'] = old_value and str(old_value) or ''
        response['error'] = u'Wrong value!'
    return response


def change_status(request):
    if request.method == 'POST':
        ids = request.POST.getlist('items')
        try:
            OrderedItem.objects.filter(id__in=ids, status='order').update(status='in_processing')
        except:
            pass
        return HttpResponseRedirect('/cp/groups/')
    else:
        raise Http404

def export(request, group_id):
    brandgroup = BrandGroup.objects.get(id=group_id)
    items = OrderedItem.objects.filter(brandgroup__id = group_id, status='order').order_by("brandgroup__direction__po")

    filename = os.path.join(settings.MEDIA_ROOT,'temp.xls')

    # Open new workbook
    book = xl.Workbook()

    # styles
    header_style = xl.XFStyle()
    header_style.font = xl.Font()
    header_style.font.bold = True
    header_style.font.italic = True
    header_style.font.height = 0x0190

    sub_header_style = xl.XFStyle()
    sub_header_style.font = xl.Font()
    sub_header_style.bold = True
    sub_header_style.font.height = 0x0190-100

    big_style = xl.XFStyle()
    big_style.font = xl.Font()
    big_style.font.height = 0x0190
    big_style.font.bold = True

    # Create sheet
    sheet = book.add_sheet(brandgroup.title)
    #sheet.cols[0].width = 0x1724

    sheet.write_merge(0,0,0,6, "Luke Auto Parts International, Inc",header_style)

    sheet.write_merge(1,0,0,6, "102 53 Street",sub_header_style)
    sheet.write_merge(2,0,0,6, "BROOKLYN, NY 11232",sub_header_style)
    sheet.write_merge(3,0,0,6, "FAX: (718) 247-5962, TEL.: (718)701-3151",sub_header_style)

    sheet.write(5,0,"Date %s" % datetime.now().strftime('%m/%d/%Y'), big_style)

    it = {}
    for i in items:
        k = "%s%d" % (i.brandgroup.direction.po,i.ponumber)
        if not it.has_key(k) :
            it[k] = []
        it[k].append(i)
    num = 5
    for po_number, data in it.items():
        num += 2
        sheet.write(num,0,"PO Alex %s" % po_number, big_style)
        for d in data:
           num += 1
           sheet.write_merge(num,num,0,2, d.part_number)
           sheet.write(num,3,int(d.quantity))
    # Save book
    book.save(filename)
    os.chmod(filename, 0777)
    content = open(filename,'rb').read()
    response = HttpResponse(content, mimetype='application/vnd.ms-excel')
    name = '%s-%s.xls' % (brandgroup.title,datetime.now().strftime('%m-%d-%Y-%H-%M'))
    response['Content-Disposition'] = 'inline; filename=%s' % name
    os.remove(filename)

    # Set items' status to 'in_processing'
    for i in items:
        i.status = 'in_processing'
        i.status_modified = datetime.now()
        i.save()
    return response


@render_to('cp/import_order.html')
@login_required
def import_order(request):
    CELLS = (
       (0,'supplier','DIR'),
       (1,'brand','BRAND'),
       (2,'part_number','PART#'),
       (3,'comment_customer','COMENT 1'),
       (4,'comment_supplier','COMENT 2'),
       (5,'quantity','Q'),
       (6,'client_id','CL'),
       (7,'description_ru','RUS'),
       (8,'description_en','ENG'),
       (9,'price_base','LIST'),
       (10,'price_sale','PRICE'),
    )

    def get_field_name(cell_title):
        for i in CELLS:
            if i[2] == cell_title:
                return i[1]

    def swap_keys(kwargs, num):
        _data = {}
        for k,v in kwargs.items():
            if k == 'DIR':
                try:
                    _data[get_field_name(k)+'.%d' % num] = [BrandGroup.objects.get(title=v[0]).id]
                except BrandGroup.DoesNotExist:
                    _data[get_field_name(k)+'.%d' % num] = v
            elif k == 'BRAND':
                _data[get_field_name(k)+'.%d' % num] = [v[0]]
            elif k == 'CL':
                try:
                    _data[get_field_name(k)+'.%d' % num] = [User.objects.get(username=v[0]).id]
                except User.DoesNotExist:
                    _data[get_field_name(k)+'.%d' % num] = v
            else:
                _data[get_field_name(k)+'.%d' % num] = v
            _data['id'+'.%d' % num] = ''
        return _data

    response = {}
    data = {}
    if request.method == 'POST':
        form = ImportXlsForm()
        f = request.FILES.get('xls_file', None)
        if f:
            xls = xlsreader.readexcel(file_contents=f.read())
            i = 1
            for row in xls.iter_dict(xls.book.sheet_names()[0]):
                row = dict([(x,[y]) for x,y in list(row.iteritems())])
                data.update(swap_keys(row,i))
                i = i+1

            if data:
                request.POST = MultiValueDict(data)
                item_forms = OrderItemForm.get_forms(request)
                form_list = [item_form.render_js('from_template') for item_form in item_forms]
                response['page_data'] = form_list
            else:
                pass
            f.close()
    else:
        form = ImportXlsForm()
    response['form'] = form
    response['page_template'] = OrderItemForm().render_js('from_template')
    return response


LIST_HEADERS = (
    (u'PO', 'ponumber'),
    (u'Поставщик', 'brandgroup'),
    (u'BRAND', 'brand'),
    (u'PART #', 'part_number'),
    (u'COMMENT 2', 'comment_supplier'),
    (u'Q', 'quantity'),
    (u'PRICE IN', 'price_invoice'),
    (u'TOTAL', 'total_w_ship'),
    (u'ЗАМЕНА', 'part_number_superseded'),
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
    (u'TOTAL COST', 'total_cost'),
    (u'Инвойс', 'invoice_code'),
    (u'Статус', 'status'),
)

@login_required
def export_order(request):
    orders = OrderedItem.objects.all().order_by('brandgroup__direction__po', 'ponumber')
    filename = os.path.join(settings.MEDIA_ROOT,'temp.xls')
    book = xl.Workbook()
    sheet = book.add_sheet('ORDERS')

    i = 0
    curr_line = 0
    for key, value in LIST_HEADERS:
        sheet.write(curr_line,i,key)
        i += 1
        
    for order in orders:
        i = 0
        curr_line += 1
        for key, value in LIST_HEADERS:
            if value == 'ponumber':
                value = u'%s%s' % (order.brandgroup.direction.po, order.ponumber)
            elif value == 'status':
                value = order.get_status_verbose()
            else:
                value = unicode(getattr(order, value)) if getattr(order, value) is not None else ''
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
