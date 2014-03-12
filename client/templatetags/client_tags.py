# -*- coding=UTF-8 -*-

from django import template

register = template.Library()

@register.inclusion_tag('client/founds.html')
def founds(founds, delta_formid=0):
    return {'founds': founds, 'delta': delta_formid}