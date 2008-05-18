# -*- coding=UTF-8 -*-
from lib.decorators import render_to
from django.db.models import Q
from django.contrib.auth.models import User
from django.http import HttpResponseRedirect
from datetime import datetime
from django.contrib.auth.decorators import login_required

from data.models import Po
from data.models import OrderedItem
from data.models import Brand

from lib.paginator import SimplePaginator
from lib.sort import SortHeaders

from client.forms import OrderItemForm, PoForm, ImportXlsForm

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
                ('Замена', 'part_number_superseded'),
                ('Цена', 'price'),
                ('QTY<br>ORD', 'quantity'),
                ('QTY<br>BO', 'quantity_backorder'),
                ('QTY<br>SH', 'quantity_ship'),
                ('Статус', 'status'),
                )
    sort_headers = SortHeaders(request, LIST_HEADERS, default_order_field='created', default_order_type='desc')
    response['headers'] = list(sort_headers.headers())
    field = LIST_HEADERS[int(request.GET.get('o',0))][1]
    direction = request.GET.get('ot','desc')
    directions = {'asc':'', 'desc':'-'}
    field_order = '%s%s' % (directions[direction], field)

    current_page = request.GET.get('page',1)
    po_list = [x.id for x in Po.objects.filter(user=request.user)]
    qs = OrderedItem.objects.filter(po__in=po_list).order_by(field_order)
    # Filter
    q = request.GET.get('q','').strip()
    if len(q) > 0 :
        qs = qs.filter(Q(part_number__icontains=q) | Q(brand__name__icontains=q))
    
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
        po_form = PoForm(request.POST.copy(), user=request.user)
        po_id = int(po_form.data['po.#'][0])
        po_number = OrderedItem.objects.get_next_ponumber(po_id)
        dict = request.POST.copy()
        del(dict['po.#'])
        request.POST = dict
        item_forms = OrderItemForm.get_forms(request)
        item_data = [item_form.render_js('from_template') for item_form in item_forms]
        
        if item_forms.are_valid():
            for form in item_forms:
                # Do something with your data here
                item = OrderedItem()

                for key, value in form.clean_data.items() :
                    if not key in ('brand','side','po'):
                        item.__dict__[key] = value

                if form.clean_data['side'] != 'None' and form.clean_data['side'] is not None :
                    item.side = form.clean_data['side']
                
                item.brand = Brand.objects.get(name=form.clean_data['brand'])
                
                item.po = Po.objects.get(pk=po_id)
                item.ponumber = po_number
                
                item.quantity_backorder = 0
                item.quantity_ship = 0
                item.status = 'order'
                item.confirmed = True
                
                item.save()
                
            return HttpResponseRedirect('/client/')
    else :
        item_data = [OrderItemForm().render_js('from_template'),OrderItemForm().render_js('from_template'),OrderItemForm().render_js('from_template')]
        po_form = PoForm(user=request.user)
    response['page_template'] = OrderItemForm().render_js('from_template')
    response['po_form'] = po_form
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
    
@login_required
@render_to('client/import_order.html')
def import_order(request):
    response = {}
    response['current_action'] = 'import_order'
    if request.method == 'POST':
        # Get a file
        form = ImportXlsForm(user=request.user)
        afile = request.FILES.get('xls_file',None)
        if afile :
            from lib import xlsreader
            xls = xlsreader.readexcel(file_contents=afile['content'])
            for sname in xls.book.sheet_names(): 
                for row in xls.iter_dict(sname): 
                    print row 
    else:
        form = ImportXlsForm(user=request.user)
    response['form'] = form
    return response        
            