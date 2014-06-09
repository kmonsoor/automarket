# -*- coding=UTF-8 -*-

from django import template
register = template.Library()


@register.simple_tag
def subtract_float(v1, v2):
    return float(v1) - float(v2)


@register.simple_tag
def division_perc(v1, v2, res=2):
    return "%.2f" % (100 - float(v1) / float(v2) * 100)