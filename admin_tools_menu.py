# -*- coding=utf-8 -*-
from django.core.urlresolvers import reverse
from django.utils.translation import ugettext_lazy as _
from admin_tools.menu import items, Menu

# to activate your custom menu add the following to your settings.py:
#
# ADMIN_TOOLS_MENU = 'netting.admin_tools_menu.CustomMenu'

class CustomMenu(Menu):
    """
    Custom Menu for netting admin site.
    """
    def __init__(self, **kwargs):
        Menu.__init__(self, **kwargs)
        self.children.append(items.MenuItem(
            title=u"Менеджемент",
            url='/cp/'
        ))
        self.children.append(items.MenuItem(
            title = u'Настройки',
            url=reverse('admin:index')
        ))
        self.children.append(items.Bookmarks(title=_(u'Bookmarks')))

    def init_with_context(self, context):
        """
        Use this method if you need to access the request context.
        """
        pass

