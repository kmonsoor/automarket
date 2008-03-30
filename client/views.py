# -*- coding=UTF-8 -*-
from lib.decorators import render_to
from django.contrib.auth.models import User

from django.contrib.auth.decorators import login_required

from data.models import OrderedItem
from data.models import Order, Brand
from data.models import generatePo

from client.forms import OrderItemForm

@render_to('client/index.html')
def index(request):
    response = {}
    response['current_action'] = 'index'
    response['data'] = Order.objects.filter(user=request.user).order_by('-created')[:3]
    
    return response

@login_required
@render_to('client/order.html')
def order(request, po=None):
    
    if request.method == 'POST' :
        form = OrderItemForm(request.POST.copy())
        if form.is_valide() :
            print 'yes!'
        else:
            print 'fooo!'
    else :
        form = OrderItemForm()
        if not po :
            # New order
            po = generatePo(request.user)
            order = Order(po=po, confirmed=False, user=request.user)
            order.save()
        else :
            order = Order.objects.get_or_create(po=po)
            order_items = OrderedItem.objects.filter(order=order)
            
    return {'current_action':'order','form': form, 'order':order, 'items':order_items, 'created':created}

@render_to('client/help/brand_list.html')
def help_brand_list(request):
    brands = Brand.objects.all().order_by('name')
    return {'list':brands}

            