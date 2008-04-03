# -*- coding:utf-8 -*-
from django import template

from data.models import OrderedItem

register = template.Library()

@register.inclusion_tag('cp/items_by_brand.html')
def ordereditems_by_brand(brand_id):
    items = OrderedItem.objects.filter(brand__id=brand_id)
    return {'items':items}

