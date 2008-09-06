# -*- coding:utf-8 -*-
from django import template

from data.models import OrderedItem, Brand
from cp.views import get_status_options as gso
status_options_str, status_options = gso()
register = template.Library()

@register.inclusion_tag('cp/items_by_brand.html')
def ordereditems_by_brand(brand_id, user=None):
    brand = Brand.active_objects.get(id=brand_id)
    items = OrderedItem.objects.filter(brand__id=brand_id, status='order').order_by("po", "ponumber")
    if user:
        items = items.filter(po__user=user)
    return {
            'brand':brand,
            'items':items,
            'status_options':status_options,
            }

@register.inclusion_tag('lib/table_header_sort.html', takes_context=True)
def table_header_sort(context, headers):
    return {
        'headers': headers,
    }

