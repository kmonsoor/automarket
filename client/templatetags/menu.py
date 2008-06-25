# -*- coding=UTF-8 -*-
from django import template
register = template.Library()

menu_items = [
    {'action':'index','name':"Мои заказы",'access':'user'},
    {'action':'order','name':"Новый заказ",'access':'user'},
    {'action':'cp','name':"Редактировать заказы",'access':'trusted_user'},
    {'action':'import_order','name':"Загрузить XLS",'access':'user'},
    {'action':'invoices','name':"Инвойсы",'access':'user'},
    {'action':'balance','name':"Баланс",'access':'user'},
]

trusted_actions = ('cp',)

@register.inclusion_tag('client/tags/menu.html')
def client_menu(current_action, user):
    menu = []
    for i in menu_items :
        if i['action'] in trusted_actions :
            if user.is_trusted() :
                menu.append(i) 
        else:
            menu.append(i)
    for data in menu :
        if data['action'] == current_action :
            data['class'] = 'current'
        else :
            data['class'] = 'usual'               
    return {'items': menu}
