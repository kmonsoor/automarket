# -*- coding:utf-8 -*-

from django import forms
from django.contrib.auth.models import User

from lib.dynamicforms import Form

from data.models import (
    OrderedItem, Area, Basket,
    ORDER_ITEM_STATUSES, INVOICE_STATUSES
)


STAFF_FIELD_LIST = (
    (u'PO', 'ponumber', 'ponumber', 'ponumber'),
    (u'Направление', 'brandgroup__title', 'brandgroup', 'brandgroup__title__contains'),
    (u'Поставщик', 'area__title', 'area', 'area__title__contains'),
    (u'BRAND',  'brand__title', 'brand', 'brand__title__contains'),
    (u'PART #', 'part_number', 'part_number', 'part_number__contains'),
    (u'ЗАМЕНА', 'part_number_superseded', 'part_number_superseded', 'part_number_superseded__contains'),
    (u'COMMENT 1', 'comment_customer', 'comment_customer', 'comment_customer__contains'),
    (u'COMMENT 2', 'comment_supplier', 'comment_supplier', 'comment_supplier__contains'),
    (u'Создано', 'created', 'created', None),
    (u'Получено', 'received_office_at', 'received_office_at', None),
    (u'Q', 'quantity', 'quantity', None),
    (u'PRICE IN', 'price_invoice', 'price_invoice', None),
    (u'TOTAL', 'total_w_ship', 'total_w_ship', None),
    (u'ID', 'manager__username', 'manager', 'manager__username__contains'),
    (u'CL', 'client__username', 'client', 'client__username__contains'),
    (u'RUS', 'description_ru', 'description_ru', 'description_ru__contains'),
    (u'ENG', 'description_en', 'description_en', 'description_en__contains'),
    (u'ORDER ID', 'id', 'id', 'id'),
    (u'RETAIL', 'price_base', 'price_base', None),
    (u'WEIGHT', 'weight', 'weight', None),
    (u'SHIPPING', 'delivery', 'delivery', None),
    (u'PRICE M', 'price_manager', 'price_manager', None),
    (u'TOTAL M', 'total_manager', 'total_manager', None),
    (u'PRICE', 'price_sale', 'price_sale', None),
    (u'NEW PRICE', 'price_discount', 'price_discount', None),
    (u'COST', 'cost', 'cost', None),
    (u'TOTAL', 'total_cost', 'total_cost', None),
    (u'Инвойс', 'invoice_code', 'invoice_code', 'invoice_code__contains'),
    (u'Статус', 'status', 'status', 'status'),
    (u'Отгружено', 'issued_at', 'issued_at', None),
)


manager_exclude_fields = (
    'comment_supplier', 'price_invoice', 'total_w_ship', 'manager',)
MANAGER_FIELD_LIST = tuple(
    filter(lambda f: f[2] not in manager_exclude_fields, STAFF_FIELD_LIST))


class OrderedItemsFilterForm(forms.Form):
    brandgroup__direction__po__icontains = forms.CharField(
        required=False, widget=forms.TextInput(attrs={'class': 'qs_filter'}))

    ponumber = forms.IntegerField(
        required=False,
        widget=forms.TextInput(
            attrs={'style': 'width: 42%;', 'class':'qs_filter'}))

    brandgroup__title__contains = forms.CharField(
        required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))

    area__title__contains = forms.CharField(
        required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))

    brand__title__contains = forms.CharField(
        required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))

    part_number__contains = forms.CharField(
        required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))

    comment_customer__contains = forms.CharField(
        required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))

    comment_supplier__contains = forms.CharField(
        required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))

    price_invoice__gte = forms.CharField(
        label='от', required=False,
        widget=forms.TextInput(attrs={'class':'qs_filter'}))

    price_invoice__lte = forms.CharField(
        label='до', required=False,
        widget=forms.TextInput(attrs={'class':'qs_filter'}))

    part_number_superseded__contains = forms.CharField(
        required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))

    description_ru__contains = forms.CharField(
        required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))

    description_en__contains = forms.CharField(
        required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))

    id = forms.IntegerField(
        required=False, widget=forms.TextInput(attrs={'class': 'qs_filter'}))

    manager__username__contains = forms.CharField(
        required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))

    client__username__contains = forms.CharField(
        required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))

    invoice_code__contains = forms.CharField(
        required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))

    status = forms.ChoiceField(
        required=False,
        choices=(('', u'Отображать все'),) + ORDER_ITEM_STATUSES,
        widget=forms.Select(attrs={'class':'qs_filter'}))

    shipment__id = forms.IntegerField(
        required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))

    shipment__isnull = forms.IntegerField(
        required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))

    created__gte = forms.DateTimeField(
        required=False, input_formats=['%Y-%m-%d %H:%M:%S'])


INVOICES_FIELD_LIST = (
    (u'Код инвойса', 'code', 'code', 'code__contains'),
    (u'Дата получения', 'received_at', 'received_at', None),
    (u'Состояние', 'status', 'status', None),
)


class InvoicesFilterForm(forms.Form):
    code__contains = forms.CharField(
        required=False, widget=forms.TextInput(attrs={'class': 'qs_filter'}))

    status = forms.ChoiceField(
        required=False,
        choices=(('', u'Отображать все'),) + INVOICE_STATUSES,
        widget=forms.Select(attrs={'class': 'qs_filter'}))


SHIPMENTS_FIELD_LIST = (
    (u'Дата', 'created_at', 'created_at', None),
    (u'ID', 'manager', 'manager', 'manager__username__contains'),
    (u'CL', 'client', 'client', 'client__username__contains'),
    (u'Код отгрузки', 'code', 'code', 'code__contains'),
    (u'Общий вес, кг', '', '', None),
    (u'Итоговая сумма', '', '', None),
)


MANAGER_SHIPMENTS_FIELD_LIST = tuple(
    filter(
        lambda f: f[2] not in ('manager',),
        SHIPMENTS_FIELD_LIST))


CLIENT_SHIPMENTS_FIELD_LIST = tuple(
    filter(
        lambda f: f[2] not in ('client',),
        SHIPMENTS_FIELD_LIST))


class ShipmentsFilterForm(forms.Form):
    code__contains = forms.CharField(
        required=False,
        widget=forms.TextInput(attrs={'class': 'qs_filter'})
    )

    manager__username__contains = forms.CharField(
        required=False, widget=forms.TextInput(attrs={'class': 'qs_filter'})
    )

    client__username__contains = forms.CharField(
        required=False, widget=forms.TextInput(attrs={'class': 'qs_filter'})
    )


BALANCE_FIELD_LIST = (
    (u'CL', 'user', 'user', 'user__username__contains'),
    (u'Группа', '', '', None),
    (u'Имя', 'user', 'user', 'user__first_name__contains'),
    (u'Email', 'user', 'user', 'user__email__contains'),
    (u'Последнее изменение', 'created_at', 'created_at', None),
    (u'Баланс $', '', '', None),
)


class BalanceFilterForm(forms.Form):
    user__username__contains = forms.CharField(
        required=False, widget=forms.TextInput(attrs={'class': 'qs_filter'}))

    user__email__contains = forms.CharField(
        required=False, widget=forms.TextInput(attrs={'class': 'qs_filter'}))

    user__first_name__contains = forms.CharField(
        required=False, widget=forms.TextInput(attrs={'class': 'qs_filter'}))


BALANCE_CLIENT_FIELD_LIST = (
    (u'Дата', 'created_at', 'created_at', None),
    (u'Тип', 'item_type', 'item_type', None),
    (u'Комментарий', 'comment', 'comment', 'comment__contains'),
    (u'Сумма', 'amount', 'amount', 'amount'),
    (u'Удалить', '', '', None),
)

BALANCE_CLIENT_FIELD_LIST_CLIENT = BALANCE_CLIENT_FIELD_LIST[:-1]


class BalanceClientFilterForm(forms.Form):
    amount = forms.CharField(
        required=False, widget=forms.TextInput(attrs={'class': 'qs_filter'})
    )
    comment__contains = forms.CharField(
        required=False, widget=forms.TextInput(attrs={'class': 'qs_filter'})
    )


CLIENT_FIELD_LIST = [
    (u'PO', 'ponumber', 'po_verbose', u"%s", "ponumber"),
    (u'Направление', 'brandgroup__title', 'brandgroup', u"%s", "brandgroup__title__contains"),
    (u'Поставщик', 'area__title', 'area', u"%s", "area__title__contains"),
    (u'BRAND', 'brand__title', 'brand', u"%s", "brand__title__contains"),
    (u'PART #', 'part_number', 'part_number', u"%s", "part_number__contains"),
    (u'ЗАМЕНА', None, 'part_number_superseded', u"%s", "part_number_superseded__contains"),
    (u'Дата', 'created', 'created', u"date::%Y-%m-%d", None),
    (u'Q', None, 'quantity', u"%s", None),
    (u'RUS', None, 'description_ru', u"%s", "description_ru__contains"),
    (u"Комментарий", None, 'comment_customer', u"%s", "comment_customer__contains"),
    (u'WEIGHT', None, 'weight', u"%s", None),
    (u'SHIPPING', None, 'delivery', u"%s", None),
    (u'PRICE', None, 'price_sale', u"%s", None),
    (u'NEW PRICE', None, 'price_discount', u"%s", None),
    (u'COST', None, 'cost', u"%s", None),
    (u'TOTAL', None, 'total_cost', u"%s", None),
    (u'Инвойс', 'invoice_code', 'invoice_code', u"%s", "invoice_code__contains"),
    (u'Статус', 'status', 'status_display', u"%s", "status"),
    (u'Отгрузка', 'issued_at', 'issued_at', u"date::%Y-%m-%d", None),
]

class OrderedItemForm(forms.Form):
    part_number = forms.CharField(required=False)
    comment_supplier = forms.CharField(required=False)
    price_invoice = forms.FloatField(required=False)
    part_number_superseded = forms.CharField(required=False)
    description_ru = forms.CharField(required=False)
    description_en = forms.CharField(required=False)
    price_base = forms.FloatField(required=False)
    weight = forms.FloatField(required=False)
    price_discount = forms.FloatField(required=False)
    invoice_code = forms.CharField(required=False)
    status = forms.ChoiceField(choices=(('_return_','Прежний'),) + ORDER_ITEM_STATUSES, required=False)

    def clean_price(self):
        if self.cleaned_data['price']:
            try:
                value = float(self.cleaned_data['price'])
            except:
                raise forms.ValidationError(
                    u'Введите десятичное значение с разделителем - точка!')
            return value
        else:
            return self.cleaned_data['price']


class PackageForm(forms.Form):
    description = forms.CharField(required=False)
    weight = forms.FloatField(required=False)
    quantity = forms.IntegerField(required=False)
    status = forms.IntegerField(required=False)


class OrderedItemInlineForm(forms.ModelForm):
    class Meta:
        model = OrderedItem
        fields = [
            'comment_supplier', 'price_invoice', 'part_number_superseded',
            'description_ru', 'description_en', 'price_base', 'weight',
            'price_discount', 'invoice_code']


class PartPriceUploadForm(forms.Form):
    area = forms.ModelChoiceField(
        queryset=Area.objects.all(),
        to_field_name='title')

    data = forms.FileField()


def users():
    users = [
        (x.id, str(x))
        for x in User.objects.filter(is_staff=False).order_by('username')]
    users.insert(0, ('', 'выбрать',))
    return users


class PackageItemForm(Form):
    TEMPLATE = 'data/packageitem_form.html'
    CORE = ('weight',)

    description = forms.CharField(
        widget=forms.TextInput(attrs={'size': 20}),
        label=u'Описание',
        required=True)

    quantity = forms.IntegerField(
        min_value=1,
        widget=forms.TextInput(attrs={'size': 5, 'class': 'quantity'}),
        label=u'Q',
        required=True)

    weight = forms.FloatField(
        widget=forms.TextInput(attrs={'size': 7, 'class': 'weight'}),
        label=u'Weight',
        required=True)

    client = forms.CharField(
        widget=forms.Select(),
        label=u'CL',
        required=False)

    def __init__(self, *args, **kwargs):
        self.client_choice = kwargs.pop('client_choice', None)
        super(PackageItemForm, self).__init__(*args, **kwargs)
        self.fields['client'].widget.choices = self.client_choice or users()

    def clean_client(self):
        client = self.cleaned_data.get('client')
        if client:
            try:
                client = User.objects.get(id=client)
            except User.DoesNotExist:
                raise forms.ValidationError(
                    u"Такого пользователя не существует")
            return client


class BalanceAddForm(Form):
    TEMPLATE = 'data/balance_add_form.html'
    CORE = ('amount',)

    comment = forms.CharField(
        widget=forms.TextInput(attrs={'class': 'balance_add_form_comment'}),
        label=u'Комментарий',
        required=True)

    amount = forms.FloatField(
        widget=forms.TextInput(attrs={'class': 'balance_add_form_amount'}),
        label=u'Сумма',
        required=True)


class BasketForm(forms.Form):
    user = forms.IntegerField(required=False)
    brandgroup = forms.CharField(required=False)
    area = forms.CharField(required=False)
    part_number = forms.CharField()
    description = forms.CharField(required=False)
    description_ru = forms.CharField(required=False)
    msrp = forms.FloatField(required=False)
    user_price = forms.FloatField(required=False)
    brand_name = forms.CharField(required=False)
    core_price = forms.FloatField(required=False)
    quantity = forms.IntegerField(required=False)

    def __init__(self, *args, **kwargs):
        self.creator = kwargs.pop('creator')
        super(BasketForm, self).__init__(*args, **kwargs)

    def clean_user(self):
        userid = self.cleaned_data.get('user')
        if userid:
            user = User.objects.get(id=userid)
            if user.get_profile().client_manager == self.creator:
                return user
        return self.creator

    def save(self):
        cd = self.cleaned_data
        cd['creator'] = self.creator
        b = Basket(**cd)
        b.save()
        return b


class ImportOrderXlsForm(forms.Form):
    xls_file = forms.Field(widget=forms.FileInput(), label="Файл")