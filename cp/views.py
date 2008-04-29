# -*- coding=UTF-8 -*-
from django.contrib.auth.decorators import login_required
from django.shortcuts import get_object_or_404
from lib.decorators import render_to, ajax_request
from lib.paginator import SimplePaginator
from lib.sort import SortHeaders
from lib.filter import Filter

from data.models import OrderedItem, Brand, ORDER_ITEM_STATUSES, CAR_SIDES

#@login_required
@render_to('cp/index.html')
def index(request):
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
    if order_by:
        qs = qs.order_by(order_by)
    paginator = SimplePaginator(qs, 5, '?page=%s')
    paginator.set_page(current_page)
    context['items'] = paginator.get_page();
    context['paginator'] = paginator
    status_options_str = '{';
    status_options = []
    k = 0
    for i in ORDER_ITEM_STATUSES:
        k += 1
        status_options_str += '"%s":"%s"' % (i[0], i[1])
        status_options.append({'value':i[0],'option':i[1]})
        if k < len(ORDER_ITEM_STATUSES):
            status_options_str += ','
    status_options_str += '}'
    context['status_options_str'] = status_options_str
    context['status_options'] = status_options
    return context

@render_to('cp/groups.html')
def groups(request):
    items = OrderedItem.objects.filter(status='order').order_by('brand')
    brands = []
    for i in items:
        if not i.brand.id in brands:
            brands.append(i.brand.id)
    return {'brands':brands}

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

#===============================================================================
# @ajax_request
# def position_edit(request, id):
#    item = get_object_or_404(OrderedItem, id=id)
#    response = {}
#    try:
#        item.__dict__[request.GET['type']]
#    except:
#        response['error'] = 'Attribute %s does not exist' % request.GET['type']
#        return response 
#    
#    old_value = str(getattr(item, request.GET['type']))
#    setattr(item, request.GET['type'], request.GET['value'])
#    try:
#        item.save()
#        response['value'] = str(getattr(item, request.GET['type']))
#    except:
#        response['value'] = old_value
#        response['error'] = 'Wrong value for attribute %s' % request.GET['type']
#    
#    return response
#===============================================================================
