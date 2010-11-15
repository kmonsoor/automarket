# -*- coding=UTF-8 -*-
from django import template
register = template.Library()

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
