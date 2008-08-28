# -*- coding=utf-8 -*-
# $Id$
from data.models import Po, Brand, OrderedItem, TrustedUsers, TarifClass
from django.contrib import admin
from django.utils.translation import ugettext_lazy as _

class BrandOptions(admin.ModelAdmin):
    list_display = ('name','_parents_repr')

class OrderedItemOptions(admin.ModelAdmin):
    list_display =('get_numbered_po','created', 'user', 'po','part_number','part_number_superseded','quantity')
    list_filter = ('created',)
    search_fieldsets = ('part_number',)

class PoOptions(admin.ModelAdmin):
    list_display = ('po','user','get_po_tariff_link')

class TarifClassOptions(admin.ModelAdmin):
    list_display = ('tarif','brand', 'value')
    list_filter = ('brand',)
    search_fieldsets = ('tarif.po',)

admin.site.register(Brand, BrandOptions)
admin.site.register(OrderedItem, OrderedItemOptions)
admin.site.register(Po, PoOptions)
admin.site.register(TarifClass, TarifClassOptions)
admin.site.register(TrustedUsers)
