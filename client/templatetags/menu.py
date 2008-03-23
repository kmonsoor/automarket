# -*- coding=UTF-8 -*-
from django import template
register = template.Library()

menu_items = [{'action':'index','name':"Мои заказы"},]

@register.inclusion_tag('client/tags/menu.html')
def client_menu(current_action):
    for data in menu_items:
        if data['action'] == current_action :
            data['class'] = 'current'
        else :
            data['class'] = 'usual'               
    return {'items': menu_items}
