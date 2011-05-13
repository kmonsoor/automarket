# -*- coding=utf-8 -*-
# $Id$
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.models import User
from django.db.models import Q
from django.utils.translation import ugettext_lazy as _
from django.core.urlresolvers import reverse
from data.models import *
from django import forms
from data.models import ClientGroup
from django.shortcuts import get_object_or_404
from data.forms import CLIENT_FIELD_LIST

class DirectionAdmin(admin.ModelAdmin):
    list_display = ('title', 'po',)


class BrandGroupAreaSettingsInline(admin.TabularInline):
    model = BrandGroupAreaSettings
    extra = 0

    def get_formset(self, request, obj=None, **kwargs):
        return super(BrandGroupAreaSettingsInline, self).get_formset(request, obj, **kwargs)

    def get_object(self, request):
        object_id = request.META['PATH_INFO'].strip('/').split('/')[-1]
        try:
            object_id = int(object_id)
        except ValueError:
            return None
        return BrandGroup.objects.get(pk=object_id)

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == 'area':
            brand_group = self.get_object(request)
            if brand_group:
                kwargs['queryset'] = brand_group.area.all().order_by('title')
        return super(BrandGroupAreaSettingsInline, self) \
               .formfield_for_foreignkey(db_field, request, **kwargs)

class BrandGroupAdmin(admin.ModelAdmin):
    list_display = ('title', 'direction', 'description', 'add_brand_to_comment', 'show_delivery', 'show_multiplier')
    list_filter = ('direction',)
    filter_horizontal = ['area']
    inlines = [BrandGroupAreaSettingsInline]

    def show_multiplier(self, obj):
        return obj.multiplier if obj.multiplier is not None else u''
    show_multiplier.short_description = \
    BrandGroup._meta.get_field_by_name('multiplier')[0].verbose_name


    def show_delivery(self, obj):
        return obj.delivery if obj.delivery is not None else u''
    show_delivery.short_description = \
    BrandGroup._meta.get_field_by_name('delivery')[0].verbose_name

class AreaAdmin(admin.ModelAdmin):
    list_display = ('title', 'in_groups')
    search_fields = ['title', 'brands__title']
    filter_horizontal = ['brands']

    def in_groups(self, obj):
        links = []
        for b in obj.brandgroup_set.all():
            links.append((reverse("admin:data_brandgroup_change", args=[b.id]), b.title))
        if links:
            return u", ".join(map(lambda x: '<a href="%s">%s</a>' % x, links))
        return '---'
    in_groups.short_description = u"Входит в группы"
    in_groups.allow_tags = True


class BrandAdmin(admin.ModelAdmin):
    list_display = ('title',)



class DiscountAdmin(admin.ModelAdmin):
    list_display = ('user', 'area', 'discount',)
    list_filter = ('user', 'discount',)

    def formfield_for_foreignkey(self, db_field, request=None, **kwargs):
        if db_field == 'user':
            kwargs['queryset'] = User.objets.filter(is_staff=False).order_by('username')
        return super(DiscountAdmin, self) \
        .formfield_for_foreignkey(db_field, request, **kwargs)

class OrderedItemForm(forms.ModelForm):
    def __init__(self, *args, **kwargs):
        super(OrderedItemForm, self).__init__(*args, **kwargs)
        self.fields['client'].queryset = \
                User.objects.all().order_by('username')
        self.fields['manager'].queryset = \
                User.objects.all().order_by('username')

class OrderedItemAdmin(admin.ModelAdmin):
    list_display =('po_number', 'created', 'manager', 'client', 'area', 'brand', 'part_number', 'quantity')
    list_filter = ('created',)
    search_fieldsets = ('part_number',)

    form = OrderedItemForm

    def po_number(self, obj):
        return '%s%s' % (obj.brandgroup.direction.po, obj.ponumber or '-',)
    po_number.allow_tags = True
    po_number.short_description = u'PO'


class CustomerAccount(User):
    class Meta:
        proxy = True
        app_label = 'auth'
        verbose_name = u"аккаунт клиента"
        verbose_name_plural = u"аккаунты клиентов"

class Staff(User):
    class Meta:
        proxy = True
        app_label = 'auth'
        verbose_name = u"аккаунт менеджера"
        verbose_name_plural = u"аккаунты менеджеров"

# User administration

class CustomUserAdmin(UserAdmin):
    list_display = ('username', 'email','first_name', 'last_name', 'groups_list', 'is_staff', 'last_login',)
    list_filter = ['is_active']

    def groups_list(self, obj):
        groups = [x['name'] for x in obj.groups.values()]
        return (',').join(groups) if groups else u'Нет группы'
    groups_list.allow_tags = True
    groups_list.short_description = u'Группа'
    filter_horizontal = ['groups']


class StaffAdmin(CustomUserAdmin):
    readonly_fields = ['is_staff']
    def queryset(self, request):
        qs = super(UserAdmin, self).queryset(request)
        qs = qs.filter(Q(is_staff=True) | Q(is_superuser=True))
        return qs

    def save_model(self, request, obj, form, change):
        if not change:
            obj.is_staff = True # For new records only
        obj.save()


from django.contrib.auth.forms import UserCreationForm

class CUserCreationForm(UserCreationForm):
    client_group = forms.ModelChoiceField( \
        queryset=ClientGroup.objects.all().order_by('title'), \
        label="Группа")

class BrandGroupDiscountInline(admin.TabularInline):
    model = BrandGroupDiscount
    extra = 0

class UserProfileInline(admin.StackedInline):
	model = UserProfile
	extra = 0
	template = 'admin/data/user/userprofile_inline.html'

class CustomerAdmin(CustomUserAdmin):
    readonly_fields = ['is_staff', 'is_superuser', 'last_login','date_joined']
    list_display = ('username', 'id', 'email','first_name', 'last_name', 'groups_list', 'is_staff', 'last_login',)

    add_form = CUserCreationForm

    inlines = [UserProfileInline, BrandGroupDiscountInline]

    fieldsets = (
        (None, {'fields': ('username', 'password')}),
        (_('Personal info'), {'fields': ('first_name', 'last_name', 'email')}),
        (_('Important dates'), {'fields': ('last_login', 'date_joined')}),
    )
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('username', 'password1', 'password2', 'client_group')}
        ),
    )
    def queryset(self, request):
        qs = super(UserAdmin, self).queryset(request)
        qs = qs.exclude(Q(is_staff=True) | Q(is_superuser=True))
        return qs

    change_form_template = 'admin/data/user/change_form.html'
    list_display = ['username', 'email','first_name', 'last_name','is_active']

    def change_view(self, request, object_id, extra_context=None):
        extra_context = {}
        obj = get_object_or_404(User, pk=object_id)
        try:
            profile = obj.get_profile()
        except Exception, e:
            profile = None
        if not profile:
            profile = \
            UserProfile.objects.create(user=obj, \
                                       client_group=ClientGroup.objects.all()[0])

        extra_context['client_order_item_fields'] = []

        fff = profile.order_item_fields

        if not fff:
            fff = profile.client_group.order_item_fields

        if fff:
            extra_context['original_order_item_fields'] = \
                fff.split(',')
        else:
            extra_context['original_order_item_fields'] = ""
        if request.POST:
            extra_context['original_order_item_fields'] = \
            request.POST.get("order_item_fields", "").split(",")
        for a in [(x[2], x[0]) for x in CLIENT_FIELD_LIST]:
            a = list(a)
            if a[0] in extra_context['original_order_item_fields']:
                a.append(True)
            else:
                a.append(False)
            extra_context['client_order_item_fields'].append(a)
        return super(CustomerAdmin, self).change_view(request, object_id, extra_context)

class ClientGroupAddForm(forms.ModelForm):
    class Meta:
        model = ClientGroup
        fields = ['title']

class BrandGroupClientGroupDiscountInline(admin.TabularInline):
    extra = 0
    model = BrandGroupClientGroupDiscount
    can_delete = False

class ClientGroupAdmin(admin.ModelAdmin):
    display_list = ['title']
    add_form = ClientGroupAddForm
    inlines = [BrandGroupClientGroupDiscountInline]

    def get_form(self, request, obj=None, **kwargs):
        """
        Use special form during user creation
        """
        defaults = {}
        if obj is None:
            defaults.update({
                'form': self.add_form,
                'fields': ['title'],
            })
        defaults.update(kwargs)
        return super(ClientGroupAdmin, self).get_form(request, obj, **defaults)

    def change_view(self, request, object_id, extra_context=None):
        extra_context = {}
        obj = get_object_or_404(ClientGroup, id=object_id)
        extra_context['client_order_item_fields'] = []

        fff = obj.order_item_fields
        if fff:
            extra_context['original_order_item_fields'] = \
                fff.split(',')
        else:
            extra_context['original_order_item_fields'] = ""
        if request.POST:
            extra_context['original_order_item_fields'] = \
            request.POST.get("order_item_fields", "").split(",")
        for a in [(x[2], x[0]) for x in CLIENT_FIELD_LIST]:
            a = list(a)
            if a[0] in extra_context['original_order_item_fields']:
                a.append(True)
            else:
                a.append(False)
            extra_context['client_order_item_fields'].append(a)
        return super(ClientGroupAdmin, self) \
                      .change_view(request, object_id, extra_context)



admin.site.register(Brand, BrandAdmin)
admin.site.register(Direction, DirectionAdmin)
admin.site.register(BrandGroup, BrandGroupAdmin)
admin.site.register(Area, AreaAdmin)
admin.site.register(OrderedItem, OrderedItemAdmin)
admin.site.unregister(User)
admin.site.register(Staff, StaffAdmin)
admin.site.register(CustomerAccount, CustomerAdmin)
admin.site.register(ClientGroup, ClientGroupAdmin)

