# -*- coding=utf-8 -*-

from django.contrib import admin

from common.models import Bot1


class Bot1Admin(admin.ModelAdmin):
    list_display = ('partnumber', 'area', 'price_cost', 'price_plus_core',)
    search_fields = ('partnumber',)
    list_filter = ('area',)

    def has_add_permission(self, request):
        return False

    def has_delete_permission(self, request, obj=None):
        return False


admin.site.register(Bot1, Bot1Admin)
