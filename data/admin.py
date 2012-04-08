# -*- coding=utf-8 -*-
# $Id$
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.models import User
from django.db import transaction
from django.db.models import Q
from django.utils.translation import ugettext_lazy as _
from django.core.urlresolvers import reverse
from django import forms
from django import template
from django.shortcuts import get_object_or_404, render_to_response
from django.http import HttpResponse
from django.core import serializers
from django.conf import settings

from data.models import *
from data.forms import CLIENT_FIELD_LIST, PartPriceUploadForm


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

    def get_urls(self):
        from django.conf.urls.defaults import patterns
        urls = super(BrandGroupAdmin, self).get_urls()
        my_urls = patterns('',
            (r'^(.+)/areas/$', self.admin_site.admin_view(self.get_areas))
        )
        return my_urls + urls

    def get_areas(self, request, object_id):
        response = ''
        try:
            brand_group = BrandGroup.objects.get(pk=object_id)
        except BrandGroup.DoesNotExist:
            response = ''
        else:
            response = serializers.serialize('json', brand_group.area.all(), fields=('id','title'))
        return HttpResponse(response, mimetype="text/json")

class AreaAdmin(admin.ModelAdmin):
    list_display = ('title', 'in_groups')
    search_fields = ['title', 'brands__title']
    filter_horizontal = ['brands']
    
    def in_groups(self, obj):
        links = []
        for b in obj.brandgroup_set.all():
            links.append((reverse("admin:data_brandgroup_change", 
                                  args=[b.id]), b.title))
        if links:
            return u", ".join(map(lambda x: '<a href="%s">%s</a>' % \
                                  x, links))
        return '---'
    in_groups.short_description = u"Входит в группы"
    in_groups.allow_tags = True

    def save_model(self, request, obj, form, change):
        super(AreaAdmin, self).save_model(request, obj, form, change)
        field = u'pricefile'
        if change and field in form.changed_data:
            from data.tasks import SavePriceFileTask
            SavePriceFileTask.apply_async([obj])
            if field in form.cleaned_data and form.cleaned_data[field]:
                self.message_user(request, 
                                  u"Файл `%s` отправлен на обработку. Цены для поставщика `%s` будут изменены в ближайшее время. Уведомление о завершении будет выслано на %s." % \
                                  (unicode(form.cleaned_data[field]), 
                                   unicode(obj.title),
                                   ",".join(settings.MANAGERS_EMAILS)))
            else:
                self.message_user(request, 
                                  u"Цены для поставщика `%s` удалены." % \
                                  unicode(obj.title))


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
    search_fields = ('part_number', 'ponumber', 'brandgroup__direction__po')
    valid_lookups = ('id',)

    form = OrderedItemForm
    
    def lookup_allowed(self, lookup, *args, **kwargs):
        if lookup.startswith(self.valid_lookups):
            return True
        return super(OrderedItemAdmin, self).lookup_allowed(lookup, *args, **kwargs)

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
        label="Группа", required=False)

    def save(self, *args, **kwargs):
        user = super(CUserCreationForm, self).save(*args, **kwargs)
        user.save()
        try:
            profile = user.get_profile()
        except Exception, e:
            profile = None
        if not profile:
            group = self.cleaned_data.get('client_group')
            if not group:
                group = ClientGroup.objects.get_default()
            profile = UserProfile.objects.create(user=user, client_group=group)
        return user

class UserBrandGroupDiscountInline(admin.TabularInline):
    model = BrandGroupDiscount
    extra = 0

class UserDiscountInlineForm(forms.ModelForm):
    class Meta:
        model = Discount
    def __init__(self, *args, **kwargs):
        super(UserDiscountInlineForm, self).__init__(*args, **kwargs)
        if self.instance.brand_group:
            self.fields['area'].queryset = self.instance.brand_group.area.all()
        else:
            self.fields['area'].queryset = Area.objects.all()

class DiscountInline(admin.TabularInline):
    model = Discount
    extra = 0
    form = UserDiscountInlineForm

class UserProfileInline(admin.StackedInline):
    model = UserProfile
    extra = 0
    template = 'admin/data/user/userprofile_inline.html'

    def formfield_for_foreignkey(self, db_field, *args, **kwargs):
        if db_field.name == 'client_group':
            kwargs['queryset'] = ClientGroup.objects.all().order_by('title')
        return super(UserProfileInline, self) \
                .formfield_for_foreignkey(db_field, *args, **kwargs)


class CustomerAdmin(CustomUserAdmin):
    readonly_fields = ['is_staff', 'is_superuser', 'last_login','date_joined']
    list_display = ('username', 'id', 'email','first_name', 'last_name', 'groups_list', 'is_staff', 'last_login',)

    add_form = CUserCreationForm

    inlines = [UserProfileInline, UserBrandGroupDiscountInline, DiscountInline]

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
    add_form_template = 'admin/data/user/change_form.html'
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
                                       client_group=ClientGroup.objects.get_default())

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


class ClientGroupDiscountInlineForm(forms.ModelForm):
    class Meta:
        model = ClientGroupDiscount
    def __init__(self, *args, **kwargs):
        super(ClientGroupDiscountInlineForm, self).__init__(*args, **kwargs)
        if self.instance.brand_group:
            self.fields['area'].queryset = self.instance.brand_group.area.all()
        else:
            if not self.is_bound:
                self.fields['area'].queryset = Area.objects.get_empty_query_set()
            else:
                self.fields['area'].queryset = Area.objects.all()


class ClientGroupDiscountInline(admin.TabularInline):
    extra = 0
    model = ClientGroupDiscount
    form = ClientGroupDiscountInlineForm

class ClientGroupAdmin(admin.ModelAdmin):
    list_display = ['title', 'is_default']
    add_form = ClientGroupAddForm
    inlines = [BrandGroupClientGroupDiscountInline, ClientGroupDiscountInline]

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


class PartAdmin(admin.ModelAdmin):
    list_display = ('partnumber', 'area_link', 'MSRP', 'cost', 'description', 
                    'substitution_link',)
    search_fields = ('partnumber', 'substitution',)
    list_filter = ('area',)

    def area_link(self, obj):
        if obj.area:
            try:
                href = reverse("admin:data_area_change", args=[obj.area.id])
            except:
                return unicode(obj.area)
            else:
                return u'<a href="%s">%s</a>' % (href, obj.area)
        return u'Ничего'
    area_link.short_description = u"Поставщик"
    area_link.allow_tags = True

    def substitution_link(self, obj):
        if obj.substitution:
            try:
                part = self.model.objects\
                    .get(partnumber=obj.substitution, area=obj.area)
                href = reverse("admin:data_part_change", args=[part.id])
            except self.model.DoesNotExist:
                return unicode(obj.substitution)
            else:
                return u'<a href="%s">%s</a>' % (href, part.partnumber)
        return u'Ничего'
    substitution_link.short_description = u"Замена"
    substitution_link.allow_tags = True


admin.site.register(Brand, BrandAdmin)
admin.site.register(Direction, DirectionAdmin)
admin.site.register(BrandGroup, BrandGroupAdmin)
admin.site.register(Area, AreaAdmin)
admin.site.register(OrderedItem, OrderedItemAdmin)
admin.site.unregister(User)
admin.site.register(Staff, StaffAdmin)
admin.site.register(CustomerAccount, CustomerAdmin)
admin.site.register(ClientGroup, ClientGroupAdmin)
admin.site.register(Part, PartAdmin)