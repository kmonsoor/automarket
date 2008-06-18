# -*- coding=UTF-8 -*-
from django.contrib.auth.decorators import login_required
from django.shortcuts import get_object_or_404
from django.http import Http404
from lib.decorators import render_to, ajax_request
from lib.paginator import SimplePaginator
from lib.sort import SortHeaders
from lib.filter import Filter
from datetime import datetime
#from lib.exceptions import AccessDenied

from data.models import OrderedItem, Brand, TrustedUsers, ORDER_ITEM_STATUSES, TRUSTED_USER_ORDER_ITEM_STATUSES, CAR_SIDES

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
    fields = (
              {'name':'status','verbose':u'Статус', 'type':u'select', 'choices':ORDER_ITEM_STATUSES},
              #{'name':'car_maker', 'verbose':u'Марка', 'type':u'char'},
              #{'name':'car_model', 'verbose':u'Модель', 'type':u'char'},
              #{'name':'engine_volume', 'verbose':u'Объём двигателя', 'type':u'char'},
              {'name':'part_number', 'verbose':u'Part #', 'type':u'char'},
              {'name':'part_number_superseded', 'verbose':u'Superseded', 'type':u'char'},
              {'name':'price', 'verbose':u'Цена', 'type':u'char'},
              {'name':'quantity', 'verbose':u'QTY', 'type':u'char'},
              {'name':'quantity_backorder', 'verbose':u'QTY BO', 'type':u'char'},
              {'name':'quantity_ship', 'verbose':u'QTY SH', 'type':u'char'},
              {'name':'brand__name', 'verbose':u'Brand', 'type':u'char'},
              {'name':'side', 'verbose':u'Сторона', 'type':u'select', 'choices':CAR_SIDES},
              #{'name':'created', 'verbose':u'created', 'type':u'char'},
              #{'name':'year', 'verbose':u'Год выпуска', 'type':u'char'},           
              )
    filter = Filter(request, OrderedItem, fields)
    context['filter'] = filter
    LIST_HEADERS = (
                    ('PO', 'auth_user.username'),
                    ('Дата', 'created'),
                    ('Описание', None),
                    ('Side', None),
                    ('Brand', 'brand'),
                    ('Part #', 'part_number'),
                    ('Superseded', 'part_number_superseded'),
                    ('Price', 'price'),
                    ('QTY', 'quantity'),
                    ('QTY BO', 'quantity_backorder'),
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
    current_page = request.GET.get('page', 1)
    
    qs = OrderedItem.objects.select_related().filter(**filter.get_filters())
    if mode == 'trusted_user': 
        qs = qs.filter(po__user = request.user)
        
    if order_by:
        qs = qs.order_by(order_by)
    paginator = SimplePaginator(qs, 5, '?page=%s')
    paginator.set_page(current_page)
    context['items'] = paginator.get_page();
    context['paginator'] = paginator
    
    context['status_options_str'], context['status_options'] = get_status_options(mode)
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
    item = get_object_or_404(OrderedItem, id=id)
    response = {}
    try:
        item.__dict__[request.POST['type']]
    except:
        response['error'] = 'Attribute %s does not exist' % request.POST['type']
        return response 
    
    old_value = str(getattr(item, request.POST['type']))
    setattr(item, request.POST['type'], request.POST['value'])
    try:
        item.save()
        response['value'] = str(getattr(item, request.POST['type']))
    except:
        response['value'] = old_value or ''
        response['error'] = 'Wrong value for attribute %s' % request.POST['type']
    
    return response

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
     
    
