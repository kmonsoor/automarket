# -*- coding=utf-8 -*-
from datetime import datetime

from django.contrib.auth.decorators import login_required
from django.shortcuts import get_object_or_404
from django.http import Http404, HttpResponseRedirect

from lib.decorators import render_to, ajax_request
from lib.paginator import SimplePaginator
from lib.sort import SortHeaders
from lib.qs_filter import QSFilter
from lib.helpers import next

from data.models import OrderedItem, Brand, TrustedUsers, Invoice, InvoiceItem, Bill, Payment, ORDER_ITEM_STATUSES, TRUSTED_USER_ORDER_ITEM_STATUSES, CAR_SIDES
from data.forms import OrderedItemsFilterForm, OrderedItemForm, InvoiceFilterForm, InvoiceForm, InvoiceItemForm

def get_status_options(mode='manager'):
    if mode == 'manager':
        statuses_dict = ORDER_ITEM_STATUSES
    else:
        statuses_dict = TRUSTED_USER_ORDER_ITEM_STATUSES
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

def get_access(request):
    access = False
    mode = None
    if TrustedUsers.objects.filter(user=request.user).count() > 0:
        access = True
        mode = 'trusted_user'   
    if request.user.is_staff == True:
        access = True
        mode = 'manager'
    return (access, mode)

@render_to('cp/index.html')
@login_required
def index(request):
    access, mode = get_access(request)
    if not access:
        raise Http404
    context = {}
    current_page = request.GET.get('page', 1)
    items_per_page = request.GET.get('items_per_page', None)
    if not items_per_page:
        items_per_page = request.session.get('cp_index_items_per_page', None)
    else:
        request.session['cp_index_items_per_page'] = items_per_page
        request.session.modified = True
    if not items_per_page:
        items_per_page = 10
    items_per_page = int(items_per_page)
    context['items_per_page'] = items_per_page
    filter = QSFilter(request, OrderedItemsFilterForm)
    if filter.modified:
        current_page = 1
    context['filter'] = filter
    LIST_HEADERS = (
                    ('PO', None),
                    ('Дата', 'created'),
                    ('Описание', None),
                    ('Side', None),
                    ('Brand', 'brand'),
                    ('Part #', 'part_number'),
                    ('Superseded', 'part_number_superseded'),
                    ('Price', 'price'),
                    ('QTY', 'quantity'),
                    ('SHP', 'quantity_ship'),
                    ('Status', 'status'),
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
    
    
    qs = OrderedItem.objects.select_related().filter(**filter.get_filters()).exclude(status='shipped')
    if mode == 'trusted_user': 
        qs = qs.filter(po__user = request.user) 
    if order_by:
        qs = qs.order_by(order_by)
    paginator = SimplePaginator(qs, items_per_page, '?page=%s')
    paginator.set_page(current_page)
    context['items'] = paginator.get_page();
    context['paginator'] = paginator
    
    context['status_options_str'], context['status_options'] = get_status_options(mode)
    context['brands'] = ','.join(['{"id":%s,"name":"%s"}' % (brand.id, brand.name) for brand in Brand.objects.all()])
    return context

@render_to('cp/groups.html')
def groups(request):
    access, mode = get_access(request)
    if not access:
        raise Http404
    qs = OrderedItem.objects.filter(status='order').order_by('brand')
    if mode == 'trusted_user':
        qs = qs.filter(po__user=request.user)
    brands = []
    for i in qs:
        if not i.brand.id in brands:
            brands.append(i.brand.id)
    return {
            'brands':brands,
            'mode':mode,
            }


class OrderedItemSaver(object):
    error = None
    def save_brand(self, obj, value):
        try:
            obj.brand = Brand.objects.get(id=value)
            obj.save()
        except Exception, e:
            pass
        return obj.brand.id
    
    def save_part_number_superseded(self, obj, value):
        try:
            obj.part_number_superseded = value
            obj.save()
        except Exception, e:
            pass
        return obj.part_number_superseded
    
    def save_price(self, obj, value):
        try:
            obj.price = value
            obj.save()
        except Exception, e:
            pass
        return obj.price
    
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
            obj.status = value
            obj.save()
        except Exception, e:
            pass
        return obj.status

class InvoiceSaver(object):
    error = None
    def save_places_num(self, obj, value):
        try:
            obj.places_num = value
            obj.save()
        except Exception, e:
            pass
        return obj.places_num
    
    def save_weight_kg(self, obj, value):
        try:
            obj.weight_kg = value
            obj.save()
        except Exception, e:
            pass
        return obj.weight_kg
    
    def save_shipping_cost(self, obj, value):
        try:
            obj.shipping_cost = value
            obj.save()
        except Exception, e:
            pass
        return obj.shipping_cost

class InvoiceItemSaver(object):
    error = None
    def save_price(self, obj, value):
        try:
            obj.price = value
            obj.save()
        except Exception, e:
            pass
        return obj.price
    
    def save_quantity(self, obj, value):
        try:
            obj.quantity = value
            obj.save()
        except Exception, e:
            pass
        return obj.quantity

@ajax_request
def position_edit(request, content_type, id):
    models = {
              'ordered_item':OrderedItem,
              'invoice':Invoice,
              'invoice_item':InvoiceItem,
              }
    forms = {
              'ordered_item':OrderedItemForm,
              'invoice':InvoiceForm,
              'invoice_item':InvoiceItemForm,
              }
    savers = {
              'ordered_item':OrderedItemSaver,
              'invoice':InvoiceSaver,
              'invoice_item':InvoiceItemSaver,
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
            value = form.clean_data[request.POST['type']]
        except Exception, e:
            response['error'] = e
            return response
        
        saver = savers[content_type]()
        response['value'] = getattr(saver, 'save_' + request.POST['type'])(item, value)
        response['error'] = saver.error      
    else:
        response['value'] = old_value and str(old_value) or ''
        response['error'] = 'Wrong value!'
    
    return response

@login_required
def make_invoices(request):
    access, mode = get_access(request)
    if not access or not mode == 'manager':
        raise Http404
           
    items = OrderedItem.objects.filter(status='on_stock').order_by('po')
    #invoices 
    invoice = None
    for item in items:
        if not invoice or invoice.po.po != item.po.po:
            invoice = Invoice(creator=request.user, po=item.po)
            invoice.saved = False
        if item.quantity_ship and item.price:
            if not invoice.saved:
                invoice.save()
                invoice.saved = True
            price = float(item.price * item.quantity_ship)
            invoice.invoiceitem_set.create(ordered_item=item, quantity=item.quantity_ship, price=price)
            
            if item.quantity_ship < item.quantity:
                new_item = OrderedItem(po=item.po, ponumber=item.ponumber, car_maker=item.car_maker, car_model=item.car_model, year=item.year, engine_volume=item.engine_volume, side=item.side, part_number=item.part_number, part_number_superseded=item.part_number_superseded, price=item.price, status=item.status, description=item.description, brand=item.brand, created=item.created, status_modified=item.status_modified, confirmed=item.confirmed, comments=item.comments)
                new_item.quantity = item.quantity - item.quantity_ship
                new_item.quantity_ship = 0
                new_item.save()
            item.status = 'back_order'
            item.save()
    return HttpResponseRedirect('/cp/invoices/')
            
@render_to('cp/invoices.html')
@login_required
def invoices(request): 
    access, mode = get_access(request)
    if not access or not mode == 'manager':
        raise Http404
    
    current_page = request.GET.get('page', 1)
    items_per_page = request.GET.get('items_per_page', None)
    if not items_per_page:
        items_per_page = request.session.get('invoices_items_per_page', None)
    else:
        request.session['invoices_items_per_page'] = items_per_page
        request.session.modified = True
    if not items_per_page:
        items_per_page = 10
    
    qs_filter = QSFilter(request, InvoiceFilterForm)
    if qs_filter.modified:
        current_page = 1
    LIST_HEADERS = (
                    ('ID', None),
                    ('PO', None),
                    ('Дата', 'created'),                  
                    ('places_num', 'places_num'),
                    ('weight_kg', 'weight_kg'),
                    ('shipping_cost', 'shipping_cost'),
                    ('Actions', None),
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

    headers = list(sort_headers.headers())
    
    invoices = Invoice.objects.filter(**qs_filter.get_filters()).order_by(order_by)
    paginator = SimplePaginator(invoices, items_per_page, '?page=%s')
    paginator.set_page(current_page)
    
    return {
            'items_per_page':items_per_page,
            'filter':qs_filter,
            'headers':headers,
            'invoices':invoices,
            'next':next(request),
            'paginator':paginator,
            }

@render_to('cp/invoice.html')
@login_required  
def invoice(request, id):    
    access, mode = get_access(request)
    if not access or not mode == 'manager':
        raise Http404
    inv = get_object_or_404(Invoice, id=id)
    return {
            'invoice':inv,
            }

from lib.decorators import render_as


class groupby(dict):
    def __init__(self, seq, key=lambda x:x):
        for value in seq:
            k = key(value)
            self.setdefault(k, []).append(value)
    def __iter__(self):
        keys = self.keys()
        keys.sort()
        for k in keys:
            yield k, self[k]

def export(request, group_id):
    brand = Brand.objects.get(id=group_id)
    items = OrderedItem.objects.filter(brand__id=group_id, status='order').order_by("po")

    from django.conf import settings
    import os
    filename = os.path.join(settings.MEDIA_ROOT,'temp.xls')
    import pyExcelerator as xl
    import datetime

    from django.http import HttpResponse 
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
    sheet = book.add_sheet(brand.name)
    #sheet.cols[0].width = 0x1724
    
    sheet.write_merge(0,0,0,6, "Luke Auto Parts International, Inc",header_style)

    sheet.write_merge(1,0,0,6, "102 53 Street",sub_header_style)
    sheet.write_merge(2,0,0,6, "BROOKLYN, NY 11232",sub_header_style)
    sheet.write_merge(3,0,0,6, "FAX: (718) 247-5962, TEL.: (718)701-3151",sub_header_style)
    
    sheet.write(5,0,"Date %s" % datetime.datetime.now().strftime('%m/%d/%Y'), big_style)
    
    it = {}
    for i in items:
        k = "%s%d" % (i.po.po,i.ponumber)
        if not it.has_key(k) :
            it[k] = []
        it[k].append(i)
    num = 5
    for po_number, data in it.items() :
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
    name = '%s-%s.xls' % (brand.name,datetime.datetime.now().strftime('%m-%d-%Y-%H-%M'))
    response['Content-Disposition'] = 'inline; filename=%s' % name
    os.remove(filename)
    
    # Set items' status to 'in_processing'
    for i in items:
        i.status = 'in_processing'
        i.status_modified = datetime.now()
        i.save()
    return response
     
    
