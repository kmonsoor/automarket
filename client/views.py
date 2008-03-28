# -*- coding=UTF-8 -*-
from lib.decorators import render_to
from django.contrib.auth.models import User

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

@render_to('client/order.html')
def order(request):
    
    if request.method == 'POST' :
        form = OrderItemForm(request.POST.copy())
        if form.is_valide() :
            print 'yes!'
        else:
            print 'fooo!'
    else :
        form = OrderItemForm()
        po = generatePo(request.user)
    
    return {'current_action':'order','form': form, 'po':po}

@render_to('client/help/brand_list.html')
def help_brand_list(request):
    brands = Brand.objects.all().order_by('name')
    return {'list':brands}        