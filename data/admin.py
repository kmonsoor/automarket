# -*- coding=utf-8 -*-
import mimetypes
import datetime
import os

from django import forms
from django.db.models import Q
from django.contrib import admin
from django.contrib.admin.filterspecs import FilterSpec, RelatedFilterSpec
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.models import User
from django.contrib.auth.forms import UserCreationForm
from django.utils.translation import ugettext_lazy as _
from django.core.files.storage import FileSystemStorage
from django.core.urlresolvers import reverse
from django.core.context_processors import csrf
from django.shortcuts import get_object_or_404, render_to_response
from django.http import HttpResponse, HttpResponseRedirect
from django.core import serializers
from django.conf import settings

from data.models import *
from data.forms import CLIENT_FIELD_LIST, STAFF_FIELD_LIST, MANAGER_FIELD_LIST
from data.tasks import (
    SavePriceFileCsvTask, SavePriceFileXlsTask, SavePartAnalog
)

def is_manager(user):
    try:
        user_profile = UserProfile.objects.get(user=user)
    except UserProfile.DoesNotExist:
        return False
    else:
        return user_profile.is_manager


class DirectionAdmin(admin.ModelAdmin):
    list_display = ('title', 'po',)


class BrandGroupAreaSettingsInline(admin.TabularInline):
    model = BrandGroupAreaSettings
    extra = 0
    fields = (
        'area', 'delivery', 'multiplier', 'cost_margin',
        'delivery_period', 'price')

    def get_formset(self, request, obj=None, **kwargs):
        return super(BrandGroupAreaSettingsInline, self).get_formset(
            request, obj, **kwargs)

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

        return super(BrandGroupAreaSettingsInline, self).formfield_for_foreignkey(
            db_field, request, **kwargs)


class BrandGroupAdmin(admin.ModelAdmin):
    list_display = (
        'title', 'direction', 'description', 'add_brand_to_comment',
        'show_delivery', 'show_multiplier', 'cost_margin',)
    list_filter = ('direction',)
    filter_horizontal = ['area']
    inlines = [BrandGroupAreaSettingsInline]

    def show_multiplier(self, obj):
        return obj.multiplier if obj.multiplier is not None else u''
    show_multiplier.short_description = BrandGroup._meta.get_field_by_name(
        'multiplier')[0].verbose_name

    def show_delivery(self, obj):
        return obj.delivery if obj.delivery is not None else u''
    show_delivery.short_description = BrandGroup._meta.get_field_by_name(
        'delivery')[0].verbose_name

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
            response = serializers.serialize('json',
                brand_group.area.all(), fields=('id', 'title'))
        return HttpResponse(response, mimetype="text/json")

    def save_formset(self, request, form, formset, change):
        super(BrandGroupAdmin, self).save_formset(
            request, form, formset, change)

        for inline_form in formset.forms:

            if not inline_form.changed_data:
                continue

            if not isinstance(inline_form.instance, BrandGroupAreaSettings):
                continue

            obj = inline_form.instance

            if 'price' in inline_form.changed_data:

                if not inline_form.cleaned_data.get('price'):
                    self.message_user(
                        request,
                        u"Цены для поставщика `%s` удалены." % (
                            unicode(obj.area.title)))

                handler = dict((
                    ('application/vnd.ms-excel', SavePriceFileXlsTask),
                )).get(
                    mimetypes.guess_type(obj.price.path)[0],
                    SavePriceFileCsvTask)

                handler.apply_async([obj])

                obj.price_updated_at = datetime.datetime.now()
                obj.save()

                self.message_user(
                    request,
                    u"Файл `%s` отправлен на обработку. Цены для поставщика `%s` будут изменены в ближайшее время. Уведомление о завершении будет выслано на %s." % (
                        unicode(inline_form.cleaned_data['price']),
                        unicode(obj.area.title),
                        ",".join(settings.MANAGERS_EMAILS)))

class AreaAdmin(admin.ModelAdmin):
    list_display = ('title', 'in_groups')
    search_fields = ['title', 'brands__title']
    filter_horizontal = ['brands']

    def in_groups(self, obj):
        links = []
        for b in obj.brandgroup_set.all():
            links.append(
                (reverse("admin:data_brandgroup_change", args=[b.id]), b.title))
        if links:
            return u", ".join(map(lambda x: '<a href="%s">%s</a>' % x, links))
        return '---'
    in_groups.short_description = u"Входит в группы"
    in_groups.allow_tags = True


class BrandAdmin(admin.ModelAdmin):
    list_display = ('title',)
    search_fields = ('title',)


class DiscountAdmin(admin.ModelAdmin):
    list_display = ('user', 'area', 'discount',)
    list_filter = ('user', 'discount',)

    def formfield_for_foreignkey(self, db_field, request=None, **kwargs):
        if db_field == 'user':
            kwargs['queryset'] = User.objets.filter(is_staff=False).order_by('username')
        return super(DiscountAdmin, self).formfield_for_foreignkey(
            db_field, request, **kwargs)


class OrderedItemForm(forms.ModelForm):
    def __init__(self, *args, **kwargs):
        super(OrderedItemForm, self).__init__(*args, **kwargs)
        self.fields['client'].queryset = User.objects.all().order_by('username')
        self.fields['manager'].queryset = User.objects.all().order_by('username')


class OrderedItemAdmin(admin.ModelAdmin):
    list_display = ('po_number', 'created', 'manager', 'client', 'area',
        'brand', 'part_number', 'quantity')
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


class GroupDiscountInlineForm(forms.ModelForm):
    def __init__(self, *args, **kwargs):
        super(GroupDiscountInlineForm, self).__init__(*args, **kwargs)
        if 'area' in self.fields:
            if self.instance.brand_group:
                self.fields['area'].queryset = self.instance.brand_group.area.all()
            else:
                if not self.is_bound:
                    self.fields['area'].queryset = Area.objects.get_empty_query_set()
                else:
                    self.fields['area'].queryset = Area.objects.all()


class UserProfileInline(admin.StackedInline):
    model = UserProfile
    fk_name = 'user'
    exclude = []
    template = 'admin/data/user/userprofile_inline.html'
    extra = 0


class StaffProfileInline(UserProfileInline):
    exclude = [
        'client_group', 'client_manager', 'is_manager',
        'is_client', 'manager_group', 'can_edit_weight',
        'can_edit_price_base', 'order_without_margin',]


class StaffAdmin(UserAdmin):
    add_form = UserCreationForm
    readonly_fields = ['is_staff']
    inlines = [StaffProfileInline]
    change_form_template = 'admin/data/user/change_form.html'
    add_form_template = 'admin/data/user/change_form.html'
    filter_horizontal = ['user_permissions', 'groups']
    list_display = (
        'username', 'email', 'first_name', 'last_name', 'last_login',)
    list_filter = []

    def queryset(self, request):
        qs = super(StaffAdmin, self).queryset(request)
        qs = qs.filter(Q(is_staff=True) | Q(is_superuser=True))
        return qs

    def save_model(self, request, obj, form, change):
        if not change:
            obj.is_staff = True
        obj.save()

    def change_view(self, request, object_id, extra_context=None):
        extra_context = {}
        obj = get_object_or_404(User, pk=object_id)

        try:
            profile = obj.get_profile()
        except Exception:
            profile = None

        if not profile:
            profile = UserProfile.objects.create(user=obj)

        extra_context['order_item_fields'] = []

        fff = profile.order_item_fields

        extra_context['original_order_item_fields'] = (fff and fff.split(',')) or ""

        if request.POST:
            extra_context['original_order_item_fields'] = request.POST.get(
                "order_item_fields", "").split(",")

        for a in [(x[2], x[0]) for x in STAFF_FIELD_LIST]:
            a = list(a)
            a.append(a[0] in extra_context['original_order_item_fields'])
            extra_context['order_item_fields'].append(a)

        return super(StaffAdmin, self).change_view(
            request, object_id, extra_context)


class ManagerProfileInline(UserProfileInline):
    exclude = [
        'is_manager', 'is_client', 'client_group', 'client_manager',
        'order_without_margin',]

    def formfield_for_foreignkey(self, db_field, *args, **kwargs):
        if db_field.name == 'manager_group':
            kwargs['queryset'] = ManagerGroup.objects.all().order_by('title')

        return super(ManagerProfileInline, self).formfield_for_foreignkey(
            db_field, *args, **kwargs)


class ManagerCreationForm(UserCreationForm):
    manager_group = forms.ModelChoiceField(
        queryset=ManagerGroup.objects.all().order_by('title'),
        label="Группа",
        required=False)

    def save(self, *args, **kwargs):
        user = super(ManagerCreationForm, self).save(*args, **kwargs)
        user.save()

        try:
            profile = user.get_profile()
        except Exception:
            profile = None

        if not profile:
            manager_group = self.cleaned_data.get('manager_group')
            if not manager_group:
                manager_group = ManagerGroup.objects.get_default()

            UserProfile.objects.create(
                user=user,
                manager_group=manager_group,
                is_manager=True)

        return user


class ManagerAdmin(UserAdmin):
    add_form = ManagerCreationForm
    inlines = [ManagerProfileInline, UserBrandGroupDiscountInline, DiscountInline]
    change_form_template = 'admin/data/user/change_form.html'
    add_form_template = 'admin/data/user/change_form.html'
    list_display = ('username', 'email', 'first_name', 'last_name', 'last_login',)
    list_filter = []
    fieldsets = (
        (None, {'fields': ('username', 'password')}),
        (_('Personal info'), {'fields': ('first_name', 'last_name', 'email')}),
        (_('Important dates'), {'fields': ('last_login', 'date_joined')}),
    )

    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': (
                'username', 'password1',
                'password2', 'manager_group')}
        ),
    )

    def has_change_permission(self, request, obj=None):
        if request.user.has_perm('auth.can_change_managers'):
            return True
        return False

    def has_add_permission(self, request):
        if request.user.has_perm('auth.can_add_managers'):
            return True
        return False

    def has_delete_permission(self, request, obj=None):
        if request.user.has_perm('auth.can_delete_managers'):
            return True
        return False

    def queryset(self, request):
        qs = super(ManagerAdmin, self).queryset(request)
        ids = list(
            UserProfile.objects
            .filter(is_manager=True)
            .values_list('user_id', flat=True))
        qs = qs.filter(id__in=ids)
        return qs

    def change_view(self, request, object_id, extra_context=None):
        extra_context = {}
        obj = get_object_or_404(User, pk=object_id)

        try:
            profile = obj.get_profile()
        except Exception:
            profile = None

        if not profile:
            profile = UserProfile.objects.create(
                user=obj,
                is_manager=True,
                manager_group=ManagerGroup.objects.get_default())

        extra_context['order_item_fields'] = []

        fff = profile.order_item_fields
        if not fff and profile.manager_group:
            fff = profile.manager_group.order_item_fields

        extra_context['original_order_item_fields'] = (fff and fff.split(',')) or ""

        if request.POST:
            extra_context['original_order_item_fields'] = request.POST.get(
                "order_item_fields", "").split(",")

        for a in [(x[2], x[0]) for x in MANAGER_FIELD_LIST]:
            a = list(a)
            a.append(a[0] in extra_context['original_order_item_fields'])
            extra_context['order_item_fields'].append(a)

        return super(ManagerAdmin, self).change_view(
            request, object_id, extra_context)


class ManagerGroupAddForm(forms.ModelForm):
    class Meta:
        model = ManagerGroup
        fields = ['title']


class BrandGroupManagerGroupDiscountInline(admin.TabularInline):
    model = BrandGroupManagerGroupDiscount
    extra = 0


class ManagerGroupDiscountInlineForm(GroupDiscountInlineForm):
    class Meta:
        model = ManagerGroupDiscount


class ManagerGroupDiscountInline(admin.TabularInline):
    model = ManagerGroupDiscount
    form = ManagerGroupDiscountInlineForm
    extra = 0


class ManagerGroupAdmin(admin.ModelAdmin):
    list_display = ['title', 'is_default']
    add_form = ManagerGroupAddForm
    inlines = [BrandGroupManagerGroupDiscountInline, ManagerGroupDiscountInline]

    def get_form(self, request, obj=None, **kwargs):
        defaults = {}
        if obj is None:
            defaults.update({'form': self.add_form, 'fields': ['title']})
        defaults.update(kwargs)
        return super(ManagerGroupAdmin, self).get_form(request, obj, **defaults)

    def change_view(self, request, object_id, extra_context=None):
        extra_context = {}
        obj = get_object_or_404(ManagerGroup, id=object_id)
        extra_context['order_item_fields'] = []
        fff = obj.order_item_fields

        extra_context['original_order_item_fields'] = (fff and fff.split(',')) or ""

        if request.POST:
            extra_context['original_order_item_fields'] = request.POST.get(
                "order_item_fields", "").split(",")

        for a in [(x[2], x[0]) for x in MANAGER_FIELD_LIST]:
            a = list(a)
            a.append(a[0] in extra_context['original_order_item_fields'])
            extra_context['order_item_fields'].append(a)
        return super(ManagerGroupAdmin, self).change_view(
            request, object_id, extra_context)


class ClientProfileInline(UserProfileInline):
    exclude = [
        'is_manager', 'is_client', 'manager_group',
        'can_edit_weight', 'can_edit_price_base',]

    def get_formset(self, request, obj=None, **kwargs):
        if request.user.get_profile().is_manager:
            self.exclude = self.exclude + ['client_manager']
        return super(ClientProfileInline, self).get_formset(request, obj, **kwargs)

    def formfield_for_foreignkey(self, db_field, *args, **kwargs):
        if db_field.name == 'client_group':
            request = args[0]
            user_profile = request.user.get_profile()

            # OMG FIXME
            if not user_profile.is_manager or not user_profile.manager_group:
                kwargs['queryset'] = ClientGroup.objects.all().order_by('title')
            else:

                try:
                    level = int(user_profile.manager_group.title.split(" ")[1])

                    cgs = []
                    for cg in ClientGroup.objects.all():
                        try:
                            if level >= int(cg.title.split(" ")[1]):
                                cgs.append(x.id)
                        except:
                            cgs.append(cg.id)

                    kwargs['queryset'] = ClientGroup.objects.filter(
                        id__in=cgs).order_by('title')
                except:
                    kwargs['queryset'] = ClientGroup.objects.all().order_by('title')

        if db_field.name == 'client_manager':
            ids = list(
                UserProfile.objects
                .filter(is_manager=True)
                .values_list('user_id', flat=True))
            kwargs['queryset'] = User.objects.filter(
                id__in=ids).order_by('username')

        return super(ClientProfileInline, self).formfield_for_foreignkey(
            db_field, *args, **kwargs)


class ClientCreationForm(UserCreationForm):
    client_group = forms.ModelChoiceField(
        queryset=ClientGroup.objects.all().order_by('title'),
        label="Группа",
        required=False)

    creator = forms.IntegerField()

    def save(self, *args, **kwargs):
        user = super(ClientCreationForm, self).save(*args, **kwargs)
        user.save()

        try:
            profile = user.get_profile()
        except Exception:
            profile = None

        if not profile:
            client_group = self.cleaned_data.get('client_group')
            if not client_group:
                client_group = ClientGroup.objects.get_default()

            client_manager = None
            creator = User.objects.get(id=self.cleaned_data['creator'])
            if creator.get_profile().is_manager:
                client_manager = creator

            UserProfile.objects.create(
                user=user,
                client_group=client_group,
                client_manager=client_manager,
                is_client=True)

        return user


class ClientBrandGroupDiscountInlineForm(forms.ModelForm):
    class Meta:
        model = BrandGroupDiscount

    def clean_discount(self):
        client_discount = self.cleaned_data['discount']
        client = self.cleaned_data['user']
        manager = client.get_profile().client_manager
        brand_group = self.cleaned_data['brand_group']

        if manager:
            manager_discount = manager.get_profile(
                ).get_discount(brand_group=brand_group)
            if client_discount > manager_discount:
                raise forms.ValidationError(
                    u"Не более %s%%" % manager_discount)

        return self.cleaned_data['discount']


class ClientBrandGroupDiscountInline(UserBrandGroupDiscountInline):
    form = ClientBrandGroupDiscountInlineForm


class ClientDiscountInlineForm(forms.ModelForm):
    class Meta:
        model = Discount

    def clean_discount(self):
        client_discount = self.cleaned_data['discount']
        client = self.cleaned_data['user']
        manager = client.get_profile().client_manager
        brand_group = self.cleaned_data['brand_group']
        area = self.cleaned_data['area']

        if manager:
            manager_discount = manager.get_profile(
                ).get_discount(brand_group=brand_group, area=area)
            if client_discount > manager_discount:
                raise forms.ValidationError(
                    u"Не более %s%%" % manager_discount)

        return self.cleaned_data['discount']


class ClientDiscountInline(DiscountInline):
    form = ClientDiscountInlineForm


class ClientAdmin(UserAdmin):
    readonly_fields = ['is_staff', 'is_superuser', 'last_login', 'date_joined']
    add_form = ClientCreationForm
    inlines = [ClientProfileInline, ClientBrandGroupDiscountInline, ClientDiscountInline]
    change_form_template = 'admin/data/user/change_form.html'
    add_form_template = 'admin/data/user/change_form.html'
    list_display = ['username', 'email', 'first_name', 'last_name', 'is_active']
    list_filter = []

    fieldsets = (
        (None, {'fields': ('username', 'password')}),
        (_('Personal info'), {'fields': ('first_name', 'last_name', 'email')}),
        (_('Important dates'), {'fields': ('last_login', 'date_joined')}),
    )
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': (
                'username', 'password1',
                'password2', 'client_group', 'creator')}
        ),
    )

    def has_change_permission(self, request, obj=None):
        if request.user.has_perm('auth.can_change_clients'):
            return True
        return is_manager(request.user)

    def has_add_permission(self, request):
        if request.user.has_perm('auth.can_add_clients'):
            return True
        return is_manager(request.user)

    def has_delete_permission(self, request, obj=None):
        if request.user.has_perm('auth.can_delete_clients'):
            return True
        return is_manager(request.user)

    def queryset(self, request):
        qs = super(ClientAdmin, self).queryset(request)
        ids = list(
            UserProfile.objects
            .filter(is_client=True)
            .values_list('user_id', flat=True))
        qs = qs.filter(id__in=ids)
        if is_manager(request.user):
            client_ids = list(UserProfile.objects.filter(
                client_manager=request.user
            ).values_list('user', flat=True))
            qs = qs.filter(id__in=client_ids)
        return qs

    def change_view(self, request, object_id, extra_context=None):
        extra_context = {}
        obj = get_object_or_404(User, pk=object_id)
        try:
            profile = obj.get_profile()
        except Exception:
            profile = None

        if not profile:
            profile = UserProfile.objects.create(
                user=obj, is_client=True,
                client_group=ClientGroup.objects.get_default())

        extra_context['order_item_fields'] = []

        fff = profile.order_item_fields or profile.client_group.order_item_fields

        extra_context['original_order_item_fields'] = (fff and fff.split(',')) or ""

        if request.POST:
            extra_context['original_order_item_fields'] = request.POST.get(
                "order_item_fields", "").split(",")

        for a in [(x[2], x[0]) for x in CLIENT_FIELD_LIST]:
            a = list(a)
            a.append(a[0] in extra_context['original_order_item_fields'])
            extra_context['order_item_fields'].append(a)

        return super(ClientAdmin, self).change_view(
            request, object_id, extra_context)


class ClientGroupAddForm(forms.ModelForm):
    class Meta:
        model = ClientGroup
        fields = ['title']


class ClientGroupDiscountInlineBase(admin.TabularInline):

    def get_formset(self, request, obj=None, **kwargs):
        if is_manager(request.user):
            kwargs.update({
                'can_delete': False,
                'max_num': len(self.model.objects.filter(client_group=obj))})
        return super(
            ClientGroupDiscountInlineBase, self
        ).get_formset(request, obj, **kwargs)

    def get_readonly_fields(self, request, obj=None):
        if is_manager(request.user):
            fields = []
            for field in self.model._meta.get_all_field_names():
                if (not field == 'id'):
                    fields.append(field)
            return fields
        return super(
            ClientGroupDiscountInlineBase, self
        ).get_readonly_fields(request, obj)


class BrandGroupClientGroupDiscountInline(ClientGroupDiscountInlineBase):
    model = BrandGroupClientGroupDiscount
    extra = 0


class ClientGroupDiscountInlineForm(GroupDiscountInlineForm):
    class Meta:
        model = ClientGroupDiscount


class ClientGroupDiscountInline(ClientGroupDiscountInlineBase):
    model = ClientGroupDiscount
    form = ClientGroupDiscountInlineForm
    extra = 0


class ClientGroupAdmin(admin.ModelAdmin):
    list_display = ['title', 'is_default']
    add_form = ClientGroupAddForm
    inlines = [BrandGroupClientGroupDiscountInline, ClientGroupDiscountInline]

    def get_actions(self, request):
        if is_manager(request.user):
            return []
        return super(ClientGroupAdmin, self).get_actions(request)

    def get_readonly_fields(self, request, obj=None):
        if is_manager(request.user):
            return ('title',)
        return super(ClientGroupAdmin, self).get_readonly_fields(request, obj)

    def has_change_permission(self, request, obj=None):
        if is_manager(request.user):
            return True
        return super(ClientGroupAdmin, self).has_change_permission(request, obj)

    def get_form(self, request, obj=None, **kwargs):
        defaults = {}
        if obj is None:
            defaults.update({'form': self.add_form, 'fields': ['title']})
        defaults.update(kwargs)
        return super(ClientGroupAdmin, self).get_form(request, obj, **defaults)

    def change_view(self, request, object_id, extra_context=None):
        extra_context = {}
        obj = get_object_or_404(ClientGroup, id=object_id)
        extra_context['order_item_fields'] = []
        fff = obj.order_item_fields

        extra_context['original_order_item_fields'] = (fff and fff.split(',')) or ""

        if request.POST:
            extra_context['original_order_item_fields'] = request.POST.get(
                "order_item_fields", "").split(",")

        for a in [(x[2], x[0]) for x in CLIENT_FIELD_LIST]:
            a = list(a)
            a.append(a[0] in extra_context['original_order_item_fields'])
            extra_context['order_item_fields'].append(a)
        return super(ClientGroupAdmin, self).change_view(
            request, object_id, extra_context)


class PartAdmin(admin.ModelAdmin):
    list_display = (
        'partnumber', 'area_link', 'MSRP', 'cost',
        'description', 'core_price',)
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
                part = self.model.objects.get(
                    partnumber=obj.substitution, area=obj.area)
                href = reverse("admin:data_part_change", args=[part.id])
            except self.model.DoesNotExist:
                return unicode(obj.substitution)
            else:
                return u'<a href="%s">%s</a>' % (href, part.partnumber)
        return u'Ничего'
    substitution_link.short_description = u"Замена"
    substitution_link.allow_tags = True


class UserOrderingFilter(RelatedFilterSpec):
    def __init__(self, f, request, params, model, model_admin):
        super(UserOrderingFilter, self).__init__(f, request, params, model, model_admin)
        self.lookup_choices = sorted(f.get_choices(include_blank=False), key=lambda x: x[1])
FilterSpec.filter_specs.insert(0, (lambda f: f.name == 'user', UserOrderingFilter))


class BalanceItemAdmin(admin.ModelAdmin):
    list_display = ('created_at', 'user', 'amount', 'item_type', 'comment')
    list_filter = ('created_at', 'user',)

    def formfield_for_dbfield(self, db_field, **kwargs):
        formfield = super(BalanceItemAdmin, self).formfield_for_dbfield(db_field, **kwargs)

        if db_field.name == 'shipment':
            formfield.choices = (
                ('', '---------',),) + tuple((x.id, x.__unicode__())
                for x in Shipment.objects.all().order_by('client__username', 'code'))

        if db_field.name == 'invoice':
            formfield.choices = (
                ('', '---------',),) + tuple((x.id, x.__unicode__())
                for x in Invoice.objects.all().order_by('-code'))

        if db_field.name == 'user':
            formfield.choices = (
                ('', '---------',),) + tuple((x.id, x.__unicode__())
                for x in User.objects.all().order_by('username'))

        return formfield


class PartAnalogAdmin(admin.ModelAdmin):
    list_display = ('partnumber', 'brand', 'partnumber_analog', 'brand_analog',)
    search_fields = ('partnumber_original', 'partnumber_analog',)

    def get_urls(self):
        from django.conf.urls.defaults import patterns, url
        urls = super(PartAnalogAdmin, self).get_urls()
        my_urls = patterns('',
            url(r'^upload/$',
                self.admin_site.admin_view(self.upload_analogs),
                name='partanalog_upload')
        )
        return my_urls + urls

    def upload_analogs(self, request):
        model = self.model
        opts = model._meta

        class PartAnalogForm(forms.Form):
            analog_file  = forms.FileField(label=u'Файл')

        if request.method == 'POST':
            form = PartAnalogForm(request.POST, request.FILES)
            if form.is_valid():

                storage = FileSystemStorage(
                    location=settings.PART_ANALOG_UPLOAD_DIR)
                filename = storage.save(None, request.FILES['analog_file'])

                filepath = os.path.join(
                    settings.PROJECT_ROOT,
                    settings.PART_ANALOG_UPLOAD_DIR,
                    filename)

                SavePartAnalog.apply_async([filepath])

                self.message_user(
                    request,
                    u"Файл с аналогами `%s` отправлен на обработку. Уведомление о завершении будет выслано на %s." % (
                        unicode(filename), ",".join(settings.MANAGERS_EMAILS)))

                return HttpResponseRedirect(
                    reverse('admin:data_partanalog_changelist'))
        else:
            form = PartAnalogForm()

        ctx = {
            'form': form,
            'root_path': self.admin_site.root_path,
            'app_label': opts.app_label,
            'opts': opts,
        }
        ctx.update(csrf(request))

        return render_to_response(
            'admin/data/partanalog/upload_analogs.html', ctx)


class ShipmentAdmin(admin.ModelAdmin):
    list_display = ('full_code', '_client', '_manager')
    search_fields = ('code', 'client__username', 'manager__username',)

    def full_code(self, obj):
        return "%s-%s" % (obj.code, obj.number)
    full_code.short_description = u"Код"
    full_code.allow_tags = True

    def _manager(self, obj):
        return obj.manager and obj.manager.username
    _manager.short_description = u"Менеджер"
    _manager.allow_tags = True

    def _client(self, obj):
        return obj.client and obj.client.username
    _client.short_description = u"Клиент"
    _client.allow_tags = True


admin.site.register(Brand, BrandAdmin)
admin.site.register(Direction, DirectionAdmin)
admin.site.register(BrandGroup, BrandGroupAdmin)
admin.site.register(Area, AreaAdmin)
admin.site.register(OrderedItem, OrderedItemAdmin)
admin.site.register(Shipment, ShipmentAdmin)
admin.site.register(Part, PartAdmin)
admin.site.register(BalanceItem, BalanceItemAdmin)
admin.site.register(PartAnalog, PartAnalogAdmin)

admin.site.unregister(User)
admin.site.register(Client, ClientAdmin)
admin.site.register(Manager, ManagerAdmin)
admin.site.register(Staff, StaffAdmin)
admin.site.register(ClientGroup, ClientGroupAdmin)
admin.site.register(ManagerGroup, ManagerGroupAdmin)


class ManagerAdminSite(admin.sites.AdminSite):
    def has_permission(self, request):
        try:
            user_profile = UserProfile.objects.get(user=request.user)
        except:
            return False
        else:
            return user_profile.is_manager


manager_admin_site = ManagerAdminSite(name='manageradminsite')
manager_admin_site.register(Client, ClientAdmin)
manager_admin_site.register(ClientGroup, ClientGroupAdmin)
