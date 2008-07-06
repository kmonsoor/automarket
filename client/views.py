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
from data.models import Invoice, InvoiceItem

from lib.paginator import SimplePaginator
from lib.sort import SortHeaders
from lib.qs_filter import QSFilter

from client.forms import OrderItemForm, PoForm, ImportXlsForm
from data.forms import OrderedItemsFilterForm

@login_required
@render_to('client/index.html')
def index(request):
    response = {}
    response['current_action'] = 'index'
    # Set page number
    current_page = request.GET.get('page', 1)
    items_per_page = request.GET.get('items_per_page', None)
    if not items_per_page:
        items_per_page = request.session.get('items_per_page', None)
    else:
        request.session['items_per_page'] = items_per_page
        request.session.modified = True
    if not items_per_page:
        items_per_page = 10
    items_per_page = int(items_per_page)
    response['items_per_page'] = items_per_page
    # Set filter
    filter = QSFilter(request, OrderedItemsFilterForm)
    if filter.modified:
        current_page = 1
    response['filter'] = filter
    # Set table headers sortable 
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
                ('QTY<br>SH', 'quantity_ship'),
                ('Статус', 'status'),
                ('Статус изменен','status_modified')
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

    response['headers'] = list(sort_headers.headers())
    
    # Get queryset
    qs = OrderedItem.objects.select_related().filter(po__user=request.user).filter(**filter.get_filters())
    if order_by:
        qs = qs.order_by(order_by)
    
    paginator = SimplePaginator(qs, items_per_page, '?page=%s')
    paginator.set_page(current_page)
    
    response['items'] = paginator.get_page()
    response['paginator'] = paginator
    return response

@render_to('client/order.html')
@login_required
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
                item.status_modified = datetime.now()
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
        new_item.status_modified = datetime.now()
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
    
@render_to('client/import_order.html')
@login_required
def import_order(request):
    response = {}
    response['current_action'] = 'import_order'
    CELLS = (
       (0,'year','YEAR'),
       (1,'car_maker','MAKE'),
       (2,'car_model','MODEL'),
       (3,'engine_volume','V'),
       (4,'description','DESCRIPTION'),
       (5,'side','SIDE'),
       (6,'brand','BRAND'),
       (7,'part_number','PART#'),
       (8,'superseded','SUPERSEDED'),
       (9,'price','PRICE'),
       (10,'quantity','Q'),
    )
    
    def get_field_name(cell_title):
        for i in CELLS:
            if i[2] == cell_title:
                return i[1]
    
    def swap_keys(kwargs, num):
        _data = {}
        for k,v in kwargs.items():
            _data[get_field_name(k)+'.%d' % num] = v
            _data['id'+'.%d' % num] = ''
        return _data
    
    if request.method == 'POST':
        # Get a file
        form = ImportXlsForm()
        afile = request.FILES.get('xls_file',None)
        if afile :
            from lib import xlsreader
            xls = xlsreader.readexcel(file_contents=afile['content'])
            data = {}
            i = 1
            for row in xls.iter_dict(xls.book.sheet_names()[0]): 
                if not row['Q']:
                    continue
                row = dict([(x.upper().replace(' ',''),[y]) for x,y in list(row.iteritems())])
                data.update(swap_keys(row,i))
                i = i+1
            from django.utils.datastructures import MultiValueDict
            if data:
                request.POST = MultiValueDict(data)
                item_forms = OrderItemForm.get_forms(request)
                form_list = [item_form.render_js('from_template') for item_form in item_forms]                
                response['page_data'] = form_list
            else:
                pass
    else:
        form = ImportXlsForm()
    response['form'] = form
    response['po_form'] = PoForm(user=request.user)
    response['page_template'] = OrderItemForm().render_js('from_template')
    return response        

@render_to('client/invoices.html')
@login_required
def invoices(request):
    response = {}
    response['current_action'] = 'invoices'
    
    LIST_HEADERS = (
                ('Дата', 'created'),
                ('PO', 'po'),
                ('Позиций', None),
                ('Общий вес', None),
                ('Число мест', None),
                ('Стоимость доставки', None)
    )
    sort_headers = SortHeaders(request, LIST_HEADERS, default_order_field='created', default_order_type='desc')
    response['headers'] = list(sort_headers.headers())
    field = LIST_HEADERS[int(request.GET.get('o',0))][1]
    direction = request.GET.get('ot','desc')
    directions = {'asc':'', 'desc':'-'}
    field_order = '%s%s' % (directions[direction], field)

    po_list = [x.id for x in Po.objects.filter(user=request.user)]
    qs = Invoices.objects.filter(po__in=po_list).order_by(field_order)
    # Filter
    q = request.GET.get('q','').strip()
    if len(q) > 0 :
        qs = qs.filter(Q(po__po__icontains=q))
    
    paginator = SimplePaginator(qs, 25, '?page=%s')
    paginator.set_page(request.GET.get('page',1))
    response.update( {
            'paginator':paginator,
            'invoices':paginator.get_page(),
            'direction': direction,
            'field': field
            })
    return response

@render_to('client/balance.html')
@login_required
def balance(request):
    response = {}
    response['current_action'] = 'balance'
    
    return response
