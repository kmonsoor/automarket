# -*- coding=utf-8 -*-

from django.utils.translation import ugettext_lazy as _
from django.core.urlresolvers import reverse
from admin_tools.dashboard import modules, Dashboard, AppIndexDashboard
# to activate your index dashboard add the following to your settings.py:
#
# ADMIN_TOOLS_INDEX_DASHBOARD = 'admin_tools_dashboard_settings.CustomIndexDashboard'

class MyDashboard(Dashboard):

    # we want a 3 columns layout
    columns = 2
    title = u'Настройки и администрирование сайта'
    def __init__(self, **kwargs):
        Dashboard.__init__(self, **kwargs)
        # append an app list module for "Applications"
        self.children.append(modules.ModelList(
            u'Настройки приложения и данные',
            ['data.models.Direction',
             'data.models.BrandGroup',
             'data.models.Area',
             'data.models.Brand',
             'data.models.OrderedItem',
             'data.models.Discount',
             'data.models.ClientGroup',
             'data.models.Part',
             'data.models.BalanceItem',
             ]
        ))

        # append an app list module for "Administration"
        self.children.append(modules.ModelList(
            u'Управление пользователями',
            ['data.admin.Staff',
             'data.admin.CustomerAccount',
             'django.contrib.auth.models.Group',
             ]))

        # append a recent actions module
        self.children.append(modules.RecentActions(
            title=_('Recent Actions'),
            limit=5
        ))

# to activate your app index dashboard add the following to your settings.py:
#
# ADMIN_TOOLS_APP_INDEX_DASHBOARD = 'admin_tools_dashboard.CustomAppIndexDashboard'

class CustomAppIndexDashboard(AppIndexDashboard):
    """
    Custom app index dashboard for automototrade.
    """
    def __init__(self, *args, **kwargs):
        AppIndexDashboard.__init__(self, *args, **kwargs)

        # we disable title because its redundant with the model list module
        self.title = ''

        # append a model list module

        # for data app
        if self.app_title.lower() == "data":
            self.children.append(modules.ModelList(
                u'Настройки приложения и данные',
                ['data.models.Direction',
                 'data.models.BrandGroup',
                 'data.models.Area',
                 'data.models.Brand',
                 'data.models.OrderedItem',
                 'data.models.Discount',
                 'data.models.ClientGroup',
                 'data.models.Part',]
            ))
        # default
        else:
            self.children.append(modules.ModelList(
                title=self.app_title,
                models=self.models,
            ))
        # append a recent actions module
        self.children.append(modules.RecentActions(
            title=_('Recent Actions'),
            include_list=self.get_app_content_types(),
        ))

    def init_with_context(self, context):
        """
        Use this method if you need to access the request context.
        """
        pass

