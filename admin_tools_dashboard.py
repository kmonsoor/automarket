# -*- coding=utf-8 -*-

from django.utils.translation import ugettext_lazy as _
from admin_tools.dashboard import modules, Dashboard, AppIndexDashboard


class MyDashboard(Dashboard):

    # we want a 3 columns layout
    columns = 2
    title = u'Настройки и администрирование сайта'

    def __init__(self, **kwargs):
        Dashboard.__init__(self, **kwargs)

        self.children.append(modules.ModelList(
            u'Настройки приложения и данные',
            [
                'data.models.Direction',
                'data.models.BrandGroup',
                'data.models.Area',
                'data.models.Brand',
                'data.models.OrderedItem',
                'data.models.Discount',
                'data.models.Part',
                'data.models.PartAnalog',
                'data.models.BalanceItem',
                'data.models.Shipment'
            ]))

        self.children.append(modules.ModelList(
            u'Управление пользователями',
            [
                'data.models.Staff',
                'django.contrib.auth.models.Group',
                'data.models.CustomerAccount',
                'data.models.ClientGroup',
                'data.models.Manager',
            ]))

        self.children.append(modules.RecentActions(
            title=_('Recent Actions'),
            limit=5))

        self.children.append(modules.ModelList(
            u'Боты', ['common.models.Bot1']))


class CustomAppIndexDashboard(AppIndexDashboard):

    def __init__(self, *args, **kwargs):
        AppIndexDashboard.__init__(self, *args, **kwargs)

        # we disable title because its redundant with the model list module
        self.title = ''

        if self.app_title.lower() == "data":
            self.children.append(modules.ModelList(
                u'Настройки приложения и данные',
                [
                    'data.models.Direction',
                    'data.models.BrandGroup',
                    'data.models.Area',
                    'data.models.Brand',
                    'data.models.OrderedItem',
                    'data.models.Discount',
                    'data.models.Part',
                    'data.models.PartAnalog',
                    'data.models.BalanceItem',
                    'data.models.Shipment'
                ]))
        elif self.app_title.lower() == "auth":
            self.children.append(modules.ModelList(
                u'Управление пользователями',
                [
                    'data.models.Staff',
                    'django.contrib.auth.models.Group',
                    'data.models.CustomerAccount',
                    'data.models.ClientGroup',
                    'data.models.Manager',
                ]))
        else:
            self.children.append(modules.ModelList(
                title=self.app_title,
                models=self.models))

        self.children.append(modules.RecentActions(
            title=_('Recent Actions'),
            include_list=self.get_app_content_types()))

    def init_with_context(self, context):
        """
        Use this method if you need to access the request context.
        """
        pass


class ManagerDashboard(Dashboard):

    columns = 1
    title = u''

    def __init__(self, **kwargs):
        Dashboard.__init__(self, **kwargs)

        self.children.append(modules.ModelList(
            u'Управление пользователями',
            [
                'data.models.CustomerAccount',
                'data.models.ClientGroup',
            ]))


class ManagerAppIndexDashboard(AppIndexDashboard):

    def __init__(self, *args, **kwargs):
        AppIndexDashboard.__init__(self, *args, **kwargs)

        # we disable title because its redundant with the model list module
        self.title = ''

        if self.app_title.lower() == "auth":
            self.children.append(modules.ModelList(
                u'Управление пользователями',
                [
                    'data.models.CustomerAccount',
                    'data.models.ClientGroup',
                ]))
        else:
            self.children.append(modules.ModelList(
                title=self.app_title,
                models=self.models))

    def init_with_context(self, context):
        """
        Use this method if you need to access the request context.
        """
        pass

