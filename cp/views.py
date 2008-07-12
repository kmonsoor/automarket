# -*- coding=utf-8 -*-
from django.contrib.auth.decorators import login_required
from django.shortcuts import get_object_or_404
from django.http import Http404, HttpResponseRedirect
from lib.decorators import render_to, ajax_request
from lib.paginator import SimplePaginator
from lib.sort import SortHeaders
from lib.qs_filter import QSFilter
from datetime import datetime
#from lib.exceptions import AccessDenied

from data.models import OrderedItem, Brand, TrustedUsers, Invoice, InvoiceItem, ORDER_ITEM_STATUSES, TRUSTED_USER_ORDER_ITEM_STATUSES, CAR_SIDES
from data.forms import OrderedItemsFilterForm, OrderedItemForm

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

@login_required
@render_to('cp/index.html')
def index(request):
    access, mode = get_access(request)
    if not access:
        raise Http404
    context = {}
    current_page = request.GET.get('page', 1)
    items_per_page = request.GET.get('items_per_page', None)
    if not items_per_page:
        items_per_page = request.session.get('items_per_page', None)
    else:
        request.session['items_per_page'] = items_per_page
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
                    ('QTY SH', 'quantity_ship'),
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
    
    
    qs = OrderedItem.objects.select_related().filter(**filter.get_filters())
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

@ajax_request
def position_edit(request, id):
    
    class FieldSaver(object):
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
                obj.quantity_ship = value
                obj.save()
            except Exception, e:
                pass
            return obj.quantity_ship
        
        def save_status(self, obj, value):
            try:
                obj.status = value
                obj.save()
            except Exception, e:
                pass
            return obj.status
        
    item = get_object_or_404(OrderedItem, id=id)
    response = {}
    try:
        old_value = getattr(item, request.POST['type'])
        #print old_value
    except:
        response['error'] = 'Attribute does not exist'
        return response 
    
    form = OrderedItemForm({request.POST['type']:request.POST['value']})
    if form.is_valid():
        try:
            value = form.clean_data[request.POST['type']]
        except Exception, e:
            response['error'] = e
            return response
        
        response['value'] = getattr(FieldSaver(), 'save_' + request.POST['type'])(item, value)

        
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
    invoice = None
    for item in items:
        if not invoice or invoice.po != item.po.po:
            invoice = Invoice(creator=request.user, po=item.po)
            invoice.save()
        invoice_item = InvoiceItem(invoice=invoice, ordered_item=item)
        invoice_item.save()
        item.status = 'shipped'
        item.save()
    return HttpResponseRedirect('/cp/invoices/')
            
@login_required
@render_to('cp/invoices.html')
def invoices(request): 
    access, mode = get_access(request)
    if not access or not mode == 'manager':
        raise Http404
    
           
    

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
     
    
