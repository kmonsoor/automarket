# -*- coding:utf-8 -*-
from django import template
register = template.Library()

@register.inclusion_tag('lib/table_header_sort.html', takes_context=True)
def table_header_sort(context, headers):
    return {
        'headers': headers,
    }