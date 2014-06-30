# -*- coding=utf-8 -*-

from django.contrib import admin

from common.models import Bot1, Bot2


class Bot1Admin(admin.ModelAdmin):
    list_display = ('partnumber', 'area',)
    search_fields = ('partnumber',)
    list_filter = ('area',)

    def has_add_permission(self, request):
        return False

    def has_delete_permission(self, request, obj=None):
        return False


class Bot2Admin(admin.ModelAdmin):
    list_display = ('maker', 'year', 'model', 'refoenumber', 'itemnumber', 'listprice', 'yourprice',)
    search_fields = ('refoenumber', 'itemnumber',)
    list_filter = ('maker',)

    def has_add_permission(self, request):
        return False

    def has_delete_permission(self, request, obj=None):
        return False


admin.site.register(Bot1, Bot1Admin)
admin.site.register(Bot2, Bot2Admin)
