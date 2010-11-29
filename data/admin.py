# -*- coding=utf-8 -*-
# $Id$

from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.models import User as DjangoUser
from django.utils.translation import ugettext_lazy as _
from data.models import Brand, OrderedItem, Supplier


admin.site.unregister(DjangoUser)



class SupplierAdmin(admin.ModelAdmin):
    list_display = ('title', 'direction', 'po', 'description',)
    list_filter = ('direction',)

class BrandOptions(admin.ModelAdmin):
    list_display = ('name','_parents_repr','active')

class OrderedItemOptions(admin.ModelAdmin):
    list_display =('ponumber', 'created', 'manager', 'client','part_number','part_number_superseded','quantity')
    list_filter = ('created',)
    search_fieldsets = ('part_number',)

class MyUserAdmin(UserAdmin):
    list_display = ('id', 'username', 'email','first_name', 'last_name', 'is_staff', 'last_login',)
    filter_horizontal = ['groups']

admin.site.register(Supplier, SupplierAdmin)
admin.site.register(Brand, BrandOptions)
admin.site.register(OrderedItem, OrderedItemOptions)
admin.site.register(DjangoUser, MyUserAdmin)

