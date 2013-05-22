# -*- coding:utf-8 -*-

from django import template
from data.models import OrderedItem, Brand
from django.core.urlresolvers import reverse
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


@register.inclusion_tag("cp/tags/table/td.html", takes_context=True)
def table_td(context, item, field_name, editable, jscallback, show_if_failed=1, prefix=""):

    value = getattr(item, field_name)

    show_if_failed = bool(show_if_failed)

    if callable(value):
        value = value()

    return {
        'item': item,
        'editable': editable,
        'field_name': field_name,
        'jscallback': jscallback,
        'value': value,
        #'class_line': class_line,
        'show_if_failed': show_if_failed,
        'prefix': prefix,
    }


@register.simple_tag
def navactive(request, urls):
    if request.path in (reverse(url) for url in urls.split()):
        return "menu-active"
    return ""
