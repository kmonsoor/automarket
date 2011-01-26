# -*- coding:utf-8 -*-

from django import forms
from data.models import OrderedItem, Brand, ORDER_ITEM_STATUSES

class OrderedItemsFilterForm(forms.Form):
    ponumber = forms.CharField(required=False, widget=forms.TextInput(attrs={'size':10, 'class':'qs_filter'}))
    brandgroup__title__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'size':10, 'class':'qs_filter'}))
    area__title__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'size':10,'class':'qs_filter'}))
    brand__title__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'size':10,'class':'qs_filter'}))
    part_number__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'size':10,'class':'qs_filter'}))
    comment_supplier__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'size':12,'class':'qs_filter'}))
    price_invoice__gte = forms.CharField(label='от', required=False, widget=forms.TextInput(attrs={'size':5, 'class':'qs_filter'}))
    price_invoice__lte = forms.CharField(label='до', required=False, widget=forms.TextInput(attrs={'size':6, 'class':'qs_filter'}))
    part_number_superseded__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'size':12,'class':'qs_filter'}))
    description_ru__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'size':12,'class':'qs_filter'}))
    description_en__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'size':12,'class':'qs_filter'}))
    manager__username__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'size':8,'class':'qs_filter'}))
    client__username__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'size':8,'class':'qs_filter'}))
    invoice_code__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'size':8,'class':'qs_filter'}))
    status = forms.ChoiceField(required=False, choices=(('', u'Отображать все'),) + ORDER_ITEM_STATUSES,\
            widget=forms.Select(attrs={'class':'qs_filter'}))

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

