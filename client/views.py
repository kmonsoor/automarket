# -*- coding=UTF-8 -*-

from datetime import datetime
from django.contrib.auth.decorators import login_required, permission_required
from lib.decorators import render_to
from lib.paginator import SimplePaginator
from lib.sort import SortHeaders
from lib.qs_filter import QSFilter
from data.models import OrderedItem, Brand, Car
from data.forms import OrderedItemsFilterForm
from client.forms import SearchForm
from common.views import PartSearch


@login_required
@render_to('client/search.html')
def search(request):
    found = None
    maker_name = None
    msg = ''
    if request.method == 'POST':
        form = SearchForm(request.POST)
        if form.is_valid():
            maker = form.cleaned_data['maker']
            part_number = form.cleaned_data['part_number']
            found = PartSearch().search(maker, part_number)
            if not found:
                msg = u"Not Found"
            else:
                # TO DO исправить все это, сделать нормально
                found['MSRP'] = float(found['MSRP'])*1.1 # +10%
                discount = 0
                for x in request.user.groups.values('discount'):
                    if x['discount'] > discount:
                        discount = float(x['discount'])/100
                
                found['your_price'] = found['MSRP'] - found['MSRP']*discount
                found['your_economy'] = found['MSRP'] - found['your_price']
                found['your_economy_perc'] = 100 - (found['your_price']/found['MSRP'])*100
                # output
                found['MSRP'] = "%.2f" % found['MSRP']
                found['your_price'] = "%.2f" % found['your_price']
                found['your_economy'] = "%.2f" % found['your_economy']
            maker_name = PartSearch().get_maker_name(maker)
            
    else:
        form = SearchForm()

    return {'form': form, 'found': found, 'maker_name': maker_name, 'msg': msg,}

@login_required
@render_to('client/index.html')
def index(request):
    response = {}
    current_page = request.GET.get('page', 1)
    items_per_page = request.GET.get('items_per_page', None)
    if not items_per_page:
        items_per_page = request.session.get('items_per_page', None)
    else:
        request.session['items_per_page'] = items_per_page
        request.session.modified = True
    if not items_per_page:
        items_per_page = 20
    items_per_page = int(items_per_page)
    response['items_per_page'] = items_per_page
    
    filter = QSFilter(request, OrderedItemsFilterForm)
    if filter.modified:
        current_page = 1
    response['filter'] = filter
    
    LIST_HEADERS = (
        (u'PO', 'ponumber'),
        (u'BRAND', 'brand'),
        (u'PART #', 'part_number'),
        (u'Q', None),
        (u'ЗАМЕНА', None),
        (u'Manager', 'manager'),
        (u'COST', None),
        (u'Статус', None),
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
    
    qs = OrderedItem.objects.select_related().filter(client=request.user).filter(**filter.get_filters())
    if order_by:
        qs = qs.order_by(order_by)
    
    paginator = SimplePaginator(request, qs, items_per_page, 'page')
    
    response['items'] = paginator.get_page_items()
    response['paginator'] = paginator
    
    return response


@render_to('client/help/brand_list.html')
def help_brand_list(request, groupbrand_id):
    try:
        brands = Brand.objects.filter(brandgroup__id = groupbrand_id).order_by('title')
    except:
        brands = Brand.objects.all().order_by('title')
    else:
        if not brands:
            brands = []

    return {'list': brands,}

@render_to('client/help/car_list.html')
def help_car_list(request):
    return {'list': Car.objects.all(),}