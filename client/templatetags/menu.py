# -*- coding=UTF-8 -*-
from django import template
register = template.Library()

menu_items = [
    {'action':'index','name':"Мои заказы",'access':'user'},
    {'action':'order','name':"Новый заказ",'access':'user'},
    {'action':'cp','name':"Редактировать заказы",'access':'trusted_user'},
    {'action':'import_order','name':"Загрузить XLS",'access':'user'},
]

@register.inclusion_tag('client/tags/menu.html')
def client_menu(current_action):
    for data in menu_items:
        if data['action'] == current_action :
            data['class'] = 'current'
        else :
            data['class'] = 'usual'               
    return {'items': menu_items}
