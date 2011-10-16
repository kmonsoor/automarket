# -*- coding=utf-8 -*-

from django import template
from django.contrib.messages import constants
register = template.Library()


MESSAGE_TAGS = {
    constants.DEBUG: 'debug',
    constants.INFO: 'information',
    constants.SUCCESS: 'success',
    constants.WARNING: 'warning',
    constants.ERROR: 'error',
}

def get_tag(message):
    print type(message), dir(message)
    return MESSAGE_TAGS.get(message.level, 'information')

@register.simple_tag
def li_message(message):
    return u'<li class=%s>%s</li>' % (get_tag(message), message)

