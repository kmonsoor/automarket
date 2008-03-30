# -*- coding=UTF-8 -*-
from django.contrib.auth.decorators import login_required
from django.shortcuts import get_object_or_404
from lib.decorators import render_to, ajax_request
from lib.paginator import SimplePaginator

from data.models import OrderedItem

#@login_required
@render_to('cp/index.html')
def index(request):
    current_page = request.GET.get('page', 1)
    paginator = SimplePaginator(OrderedItem.objects.all(), 25, '?page=%s')
    paginator.set_page(current_page)
    items = paginator.get_page();
    return {'items':items,'paginator':paginator}

@ajax_request
def position_edit(request, id):
    item = get_object_or_404(OrderedItem, id=id)
    response = {}
    try:
        item.__dict__[request.POST['type']]
    except:
        response['error'] = 'Attribute %s does not exist' % request.POST['type']
        return response 
        
    item.__dict__[request.POST['type']] = request.POST['value']
    item.save()
    response['value'] = item.__dict__[request.POST['type']]
    return response