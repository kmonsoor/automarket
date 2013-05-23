# -*- coding:utf-8 -*-

from django import forms
from data.models import OrderedItem, Brand, ORDER_ITEM_STATUSES, Area, INVOICE_STATUSES

STAFF_FIELD_LIST = (
    (u'PO', 'ponumber', 'ponumber', 'ponumber'),
    (u'Направление', 'brandgroup__title', 'brandgroup', 'brandgroup__title__contains'),
    (u'Поставщик', 'area__title', 'area', 'area__title__contains'),
    (u'BRAND',  'brand__title', 'brand', 'brand__title__contains'),
    (u'PART #', 'part_number', 'part_number', 'part_number__contains'),
    (u'COMMENT 1', 'comment_customer', 'comment_customer', 'comment_customer__contains'),
    (u'COMMENT 2', 'comment_supplier', 'comment_supplier', 'comment_supplier__contains'),
    (u'Создано', 'created', 'created', None),
    (u'Получено', 'received_office_at', 'received_office_at', None),
    (u'Q', 'quantity', 'quantity', None),
    (u'PRICE IN', 'price_invoice', 'price_invoice', None),
    (u'TOTAL', 'total_w_ship', 'total_w_ship', None),
    (u'ЗАМЕНА', 'part_number_superseded', 'part_number_superseded', 'part_number_superseded__contains'),
    (u'ID', 'manager__username', 'manager', 'manager__username__contains'),
    (u'CL', 'client__username', 'client', 'client__username__contains'),
    (u'RUS', 'description_ru', 'description_ru', 'description_ru__contains'),
    (u'ENG', 'description_en', 'description_en', 'description_en__contains'),
    (u'ORDER ID', 'id', 'id', 'id'),
    (u'LIST', 'price_base', 'price_base', None),
    (u'WEIGHT', 'weight', 'weight', None),
    (u'SHIPPING', 'delivery', 'delivery', None),
    (u'PRICE', 'price_sale', 'price_sale', None),
    (u'NEW PRICE', 'price_discount', 'price_discount', None),
    (u'COST', 'cost', 'cost', None),
    (u'TOTAL', 'total_cost', 'total_cost', None),
    (u'Инвойс', 'invoice_code', 'invoice_code', 'invoice_code__contains'),
    (u'Статус', 'status', 'status', 'status'),
    (u'Отгрузка', 'issued_at', 'issued_at', None),
)

class OrderedItemsFilterForm(forms.Form):
    brandgroup__direction__po__icontains = forms.CharField(required=False, widget=forms.TextInput(attrs={'class': 'qs_filter'}))
    ponumber = forms.IntegerField(required=False, widget=forms.TextInput(attrs={'style': 'width: 42%;', 'class':'qs_filter'}))
    brandgroup__title__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))
    area__title__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))
    brand__title__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))
    part_number__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))
    comment_customer__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))
    comment_supplier__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))
    price_invoice__gte = forms.CharField(label='от', required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))
    price_invoice__lte = forms.CharField(label='до', required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))
    part_number_superseded__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))
    description_ru__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))
    description_en__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))
    id = forms.IntegerField(required=False, widget=forms.TextInput(attrs={'class': 'qs_filter'}))
    manager__username__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))
    client__username__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))
    invoice_code__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))
    status = forms.ChoiceField(required=False, choices=(('', u'Отображать все'),) + ORDER_ITEM_STATUSES,\
            widget=forms.Select(attrs={'class':'qs_filter'}))


INVOICES_FIELD_LIST = (
    (u'Код инвойса', 'code', 'code', 'code__contains'),
    (u'Дата получения', 'received_at', 'received_at', None),
    (u'Состояние', 'status', 'status', 'status'),
)


class InvoicesFilterForm(forms.Form):
    code__contains = forms.CharField(
        required=False,
        widget=forms.TextInput(attrs={'class': 'qs_filter'})
    )

    status = forms.ChoiceField(
        required=False,
        choices=(('', u'Отображать все'),) + INVOICE_STATUSES,
        widget=forms.Select(attrs={'class': 'qs_filter'})
    )


CLIENT_FIELD_LIST = [
    (u'PO', 'ponumber', 'po_verbose', u"%s", "ponumber"),
    (u'Направление', 'brandgroup__title', 'brandgroup', u"%s", "brandgroup__title__contains"),
    (u'Поставщик', 'area__title', 'area', u"%s", "area__title__contains"),
    (u'BRAND', 'brand__title', 'brand', u"%s", "brand__title__contains"),
    (u'PART #', 'part_number', 'part_number', u"%s", "part_number__contains"),
    (u'Дата', 'created', 'created', u"date::%Y-%m-%d", None),
    (u'Q', None, 'quantity', u"%s", None),
    (u'ЗАМЕНА', None, 'part_number_superseded', u"%s", "part_number_superseded__contains"),
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
    (u'Отгрузка', 'issued_at', 'issued_at', None),
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
                raise forms.ValidationError('Введите десятичное значение с разделителем - точка!')
            return value
        else:
            return self.cleaned_data['price']


class PackageForm(forms.Form):
    description = forms.CharField(required=False)
    weight = forms.FloatField(required=False)
    quantity = forms.IntegerField(required=False)


class OrderedItemInlineForm(forms.ModelForm):
    class Meta:
        model = OrderedItem
        fields = \
            ['comment_supplier',
             'price_invoice',
             'part_number_superseded',
             'description_ru',
             'description_en',
             'price_base',
             'weight',
             'price_discount',
             'invoice_code']


class PartPriceUploadForm(forms.Form):
    area = forms.ModelChoiceField(queryset=Area.objects.all(), 
                                  to_field_name='title')
    data = forms.FileField()