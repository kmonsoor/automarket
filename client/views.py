# -*- coding=UTF-8 -*-

from datetime import datetime
from django.db.models import Q
from django.contrib.auth.models import User
from django.http import HttpResponseRedirect
from django.contrib.auth.decorators import login_required
from django.shortcuts import Http404
from data.models import OrderedItem, Brand
from data.forms import OrderedItemsFilterForm
from lib.decorators import render_to
from lib.paginator import SimplePaginator
from lib.sort import SortHeaders
from lib.qs_filter import QSFilter
from client.forms import OrderItemForm


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
        items_per_page = 20
    items_per_page = int(items_per_page)
    response['items_per_page'] = items_per_page
    # Set filter
    filter = QSFilter(request, OrderedItemsFilterForm)
    if filter.modified:
        current_page = 1
    response['filter'] = filter
    # Set table headers sortable 
    from django.utils.html import mark_safe
    LIST_HEADERS = (
                ('Дата', 'created'),
                ('Авто', None),
                ('Описание', None),
                ('Сторона', None),
                ('Производитель', 'brand'),
                ('OEM #', 'part_number'),
                ('Замена', 'part_number_superseded'),
                ('Цена', 'price'),
                (mark_safe('QTY<br />ORD'), 'quantity'),
                (mark_safe('QTY<br />SH'), 'quantity_ship'),
                ('Статус', 'status'),
                (mark_safe('Статус<br /> изменен'),'status_modified')
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
    
    paginator = SimplePaginator(request, qs, items_per_page, 'page')
    #paginator.set_page(current_page)
    
    response['items'] = paginator.get_page_items()
    response['paginator'] = paginator
    return response


@render_to('client/help/brand_list.html')
def help_brand_list(request, supplier_id):
    try:
        brands = Brand.active_objects.filter(supplier__id = supplier_id).order_by('name')
    except:
        brands = []

    return {'list': brands,}