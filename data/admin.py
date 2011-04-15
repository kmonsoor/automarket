# -*- coding=utf-8 -*-
# $Id$
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.models import User as DjangoUser
from django.utils.translation import ugettext_lazy as _
from data.models import Direction, BrandGroup, Brand, OrderedItem, Area, Discount
from django import forms
from django.contrib.auth.models import User
admin.site.unregister(DjangoUser)

class DirectionAdmin(admin.ModelAdmin):
    list_display = ('title', 'po',)


class BrandGroupAdmin(admin.ModelAdmin):
    list_display = ('title', 'direction', 'description', 'add_brand_to_comment')
    list_filter = ('direction',)
    filter_horizontal = ['area']


class AreaAdmin(admin.ModelAdmin):
    list_display = ('title',)
    filter_horizontal = ['brands']


class BrandAdmin(admin.ModelAdmin):
    list_display = ('title',)



class DiscountAdmin(admin.ModelAdmin):
    list_display = ('user', 'area', 'discount',)
    list_filter = ('user', 'discount',)


class OrderedItemForm(forms.ModelForm):
    def __init__(self, *args, **kwargs):
        super(OrderedItemForm, self).__init__(*args, **kwargs)
        self.fields['client'].queryset = \
                User.objects.all().order_by('username')
        self.fields['manager'].queryset = \
                User.objects.all().order_by('username')

class OrderedItemAdmin(admin.ModelAdmin):
    list_display =('po_number', 'created', 'manager', 'client', 'part_number', 'quantity')
    list_filter = ('created',)
    search_fieldsets = ('part_number',)

    form = OrderedItemForm

    def po_number(self, obj):
        return '%s%s' % (obj.brandgroup.direction.po, obj.ponumber or '-',)
    po_number.allow_tags = True
    po_number.short_description = u'PO'


class MyUserAdmin(UserAdmin):
    list_display = ('id', 'username', 'email','first_name', 'last_name', 'groups_list', 'is_staff', 'last_login',)

    def groups_list(self, obj):
        groups = [x['name'] for x in obj.groups.values()]
        return (',').join(groups) if groups else u'Нет группы'
    groups_list.allow_tags = True
    groups_list.short_description = u'Группа'
    filter_horizontal = ['groups']



admin.site.register(Brand, BrandAdmin)
admin.site.register(Direction, DirectionAdmin)
admin.site.register(BrandGroup, BrandGroupAdmin)
admin.site.register(Area, AreaAdmin)
admin.site.register(OrderedItem, OrderedItemAdmin)
admin.site.register(Discount, DiscountAdmin)
admin.site.register(DjangoUser, MyUserAdmin)

