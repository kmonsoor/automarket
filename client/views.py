# -*- coding=UTF-8 -*-
from lib.decorators import render_to
from django.contrib.auth.models import User
from django.http import HttpResponseRedirect

from django.contrib.auth.decorators import login_required

from data.models import OrderedItem
from data.models import Order, Brand
from data.models import generatePo

from client.forms import OrderItemForm

@render_to('client/index.html')
def index(request):
    response = {}
    response['current_action'] = 'index'
    response['orders'] = Order.objects.filter(user=request.user, confirmed=True).order_by('-created')[:3]
    
    return response

@login_required
@render_to('client/order.html')
def order(request, po=None):
    message = ''
    if not po :
        # New order
        po = generatePo(request.user)
        order = Order(po=po, confirmed=False, user=request.user)
        order.save()
    else :
        order,created = Order.objects.get_or_create(po=po)
    
    if request.method == 'POST' :
        if request.POST.has_key('add_item') :
            # Add item

            form = OrderItemForm(request.POST.copy())
            if form.is_valid() :
                item = OrderedItem()
                item.order = order
                item.confirmed = False
                for key,value in form.clean_data.items() :
                    if key == 'brand':
                        brand = Brand.objects.get(name__iexact=value)
                        value = brand
                    setattr(item, key, value)
                print item
                item.save()
            else:
                message = 'Исправьте ошибки заполнения формы!'
        if request.POST.has_key('save_order') :
            # Save order
            order.confirmed = True
            order.save()
            # Save items
            def get_quantity(k,v):
                if k[0:8] == 'quantity' :
                    return {'id':k.split('_')[1],'value':v}
                else:
                    pass
                
            quantity = [get_quantity(key, value) for key,value in request.POST.items()]
            
            for i in quantity:
                if i is not None:
                    item = OrderedItem.objects.get(id=i['id'])
                    item.quantity = i['value']
                    item.order = order
                    item.confirmed = True
                    item.save()
            return HttpResponseRedirect('/client/')
    else :
        form = OrderItemForm()
    
    order_items = OrderedItem.objects.filter(order=order) or []   
    return {'current_action':'order','form': form, 'order':order, 'items':order_items, 'message':message}

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
    url = '/client/order/%s/' % po
    return HttpResponseRedirect(url)
    

            