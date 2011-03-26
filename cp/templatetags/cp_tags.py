# -*- coding:utf-8 -*-

from django import template
from data.models import OrderedItem, Brand
register = template.Library()

@register.inclusion_tag('cp/items_by_brandgroup.html')
def ordereditems_by_brandgroup(direction, brandgroup, orders):
    orders_by_area = {}
    for order in orders:
        if order.area not in orders_by_area.keys():
            orders_by_area[order.area] = []
        orders_by_area[order.area].append(order)
    return {
            'direction': direction,
            'brandgroup' : brandgroup,
            'orders_by_area' : orders_by_area,
            }

@register.inclusion_tag('lib/table_header_sort.html', takes_context=True)
def table_header_sort(context, headers):
    return {
        'headers': headers,
    }

