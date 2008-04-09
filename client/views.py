# -*- coding=UTF-8 -*-
from lib.decorators import render_to
from django.contrib.auth.models import User
from django.http import HttpResponseRedirect

from django.contrib.auth.decorators import login_required

from data.models import OrderedItem
from data.models import Brand

from lib.paginator import SimplePaginator

from client.forms import OrderItemForm

@login_required
@render_to('client/index.html')
def index(request):
    response = {}
    response['current_action'] = 'index'
    current_page = request.GET.get('page',1)
    paginator = SimplePaginator(OrderedItem.objects.filter(user=request.user).order_by('-created'), 25, '?page=%s')
    paginator.set_page(current_page)
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
                
                item.user = request.user
                item.quantity_backorder = 0
                item.quantity_ship = 0
                item.status = 'order'
                item.confirmed = True
                
                item.save()
                
            return HttpResponseRedirect('/client/')
    else :
        #item_data = [OrderItemForm().render_js('from_template'),OrderItemForm().render_js('from_template'),OrderItemForm().render_js('from_template')]
        item_data = []
    response['page_template'] = OrderItemForm().render_js('from_template')
    
    response['page_data'] = item_data
    response['message'] = message
 
    return response

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
    

            