# -*- coding=UTF-8 -*-
from lib.decorators import render_to
from django.contrib.auth.models import User
from django.http import HttpResponseRedirect
from datetime import datetime
from django.contrib.auth.decorators import login_required

from data.models import OrderedItem
from data.models import Brand

from lib.paginator import SimplePaginator
from lib.sort import SortHeaders

from client.forms import OrderItemForm

@login_required
@render_to('client/index.html')
def index(request):
    response = {}
    response['current_action'] = 'index'
    
    LIST_HEADERS = (
                ('Дата', 'created'),
                ('Авто', None),
                ('Описание', None),
                ('Сторона', None),
                ('Производитель', 'brand'),
                ('OEM #', 'part_number'),
                ('Замена', 'superseded'),
                ('Цена', 'price'),
                ('QTY order', 'quantity'),
                ('QTY backorder', 'quantity_backorder'),
                ('QTY ship', 'quantity_ship'),
                ('Статус', 'status'),
                )
    sort_headers = SortHeaders(request, LIST_HEADERS)
    response['headers'] = list(sort_headers.headers())
    field = LIST_HEADERS[int(request.GET.get('o',0))][1]
    direction = request.GET.get('ot','desc')
    directions = {'asc':'', 'desc':'-'}
    field_order = '%s%s' % (directions[direction], field)

    current_page = request.GET.get('page',1)
    qs = OrderedItem.objects.filter(user=request.user).order_by(field_order)
    # Filter
    q = request.GET.get('q','').strip()
    if len(q) > 0 :
        qs = qs.filter(part_number__icontains=q)
    
    paginator = SimplePaginator(qs, 25, '?page=%s')
    paginator.set_page(current_page)
    
    response['field'] = field
    response['direction'] = direction    
    response['orders'] = paginator.get_page()
    response['paginator'] = paginator
    return response

@login_required
@render_to('client/order.html')
def order(request):
    message = ''
    response = {}
    response['current_action'] = 'order'
    
    if request.method == 'POST' :
        item_forms = OrderItemForm.get_forms(request)
        item_data = [item_form.render_js('from_template') for item_form in item_forms]
        if item_forms.are_valid():
            for form in item_forms:
                # Do something with your data here
                item = OrderedItem()

                for key, value in form.clean_data.items() :
                    item.__dict__[key] = value
                
                item.brand = Brand.objects.get(name=form.clean_data['brand'])
                
                item.user = request.user
                item.quantity_backorder = 0
                item.quantity_ship = 0
                item.status = 'order'
                item.confirmed = True
                
                item.save()
                
            return HttpResponseRedirect('/client/')
    else :
        item_data = [OrderItemForm().render_js('from_template'),OrderItemForm().render_js('from_template'),OrderItemForm().render_js('from_template')]
        #item_data = []
    response['page_template'] = OrderItemForm().render_js('from_template')
    
    response['page_data'] = item_data
    response['message'] = message
 
    return response

def superseded(request, action, item_id):
    
    next = request.GET.get('next','/client/')
    
    try:
        item = OrderedItem.objects.get(id=item_id)
    except:
        return HttpResponseRedirect(next)
    if action == 'accept' :
        new_item = OrderedItem()
        # Populate item dict
        for key, value in item.__dict__.items() :
            if key not in ('id','created',) :
                new_item.__dict__[key] = value
        # Rewrite values
        new_item.part_number_superseded = None
        new_item.part_number = item.part_number_superseded
        new_item.status = 'order'
        new_item.save()
        # Delete old item
        item.delete()
    if action == 'decline' :
        item.delete()
    
    return HttpResponseRedirect(next)

@render_to('client/help/brand_list.html')
def help_brand_list(request):
    brands = Brand.objects.all().order_by('name')
    return {'list':brands}

@login_required
def delete_item(request, po, item_id):
    try:
        item = OrderedItem.objects.get(pk=item_id)
        item.delete()
    except Exception, e:
        pass
    return HttpResponseRedirect('/client/order/')
    

            