# -*- coding=UTF-8 -*-
from django.contrib.auth.decorators import login_required
from django.shortcuts import get_object_or_404
from lib.decorators import render_to, ajax_request
from lib.paginator import SimplePaginator

from data.models import OrderedItem, ORDER_ITEM_STATUSES

#@login_required
@render_to('cp/index.html')
def index(request):
    context = {}
    current_page = request.GET.get('page', 1)
    paginator = SimplePaginator(OrderedItem.objects.all(), 5, '?page=%s')
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
    items = OrderedItem.objects.all().order_by('brand')
    brands = []
    for i in items:
        if not i.brand.id in brands:
            brands.append(i.brand.id)
    print brands
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
