# -*- coding=UTF-8 -*-

from django import template

register = template.Library()

@register.inclusion_tag('common/tags/form_error.html')
def field_error(form_field):
    return {'errors': form_field.errors}