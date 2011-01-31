# -*- coding:utf-8 -*-

from django import template
from data.models import OrderedItem, Brand
register = template.Library()

@register.inclusion_tag('cp/items_by_brandgroup.html')
def ordereditems_by_brandgroup(direction, brandgroup, orders):
    orders_by_brand = {}
    for order in orders:
        if order.brand not in orders_by_brand.keys():
            orders_by_brand[order.brand] = []
        orders_by_brand[order.brand].append(order)
    return {
            'direction': direction,
            'brandgroup' : brandgroup,
            'orders_by_brand' : orders_by_brand,
            }

@register.inclusion_tag('lib/table_header_sort.html', takes_context=True)
def table_header_sort(context, headers):
    return {
        'headers': headers,
    }

