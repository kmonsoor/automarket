# -*- coding:utf-8 -*-
from django import newforms as forms

from data.models import OrderedItem, Brand, TrustedUsers, ORDER_ITEM_STATUSES, TRUSTED_USER_ORDER_ITEM_STATUSES, CAR_SIDES

class OrderedItemsFilterForm(forms.Form):
    po__po = forms.CharField(required=False, widget=forms.TextInput(attrs={'size':3, 'class':'qs_filter'}))
    ponumber = forms.IntegerField(required=False, widget=forms.TextInput(attrs={'size':3, 'class':'qs_filter'}))
    description__contains = forms.CharField(required=False, widget=forms.TextInput(attrs={'class':'qs_filter'}))
    status = forms.ChoiceField(label='Статус', choices=(('',u''),)+ORDER_ITEM_STATUSES, required=False, widget=forms.Select(attrs={'class':'qs_filter'}))
    part_number__contains = forms.CharField(label=u'Part #', required=False, widget=forms.TextInput(attrs={'size':12,'class':'qs_filter'}))
    part_number_superseded__contains = forms.CharField(label=u'part_number_superseded', required=False, widget=forms.TextInput(attrs={'size':12,'class':'qs_filter'}))
    price__gte = forms.CharField(label='Цена, от', required=False, widget=forms.TextInput(attrs={'size':3, 'class':'qs_filter'}))
    price__lte = forms.CharField(label='Цена, до', required=False, widget=forms.TextInput(attrs={'size':3, 'class':'qs_filter'}))
    quantity = forms.IntegerField(label='QTY', required=False, widget=forms.TextInput(attrs={'size':3, 'class':'qs_filter'}))
    quantity_ship = forms.IntegerField(label='QTY BO', required=False, widget=forms.TextInput(attrs={'size':3, 'class':'qs_filter'}))
    brand__name__contains = forms.CharField(label='Brand', required=False, widget=forms.TextInput(attrs={'size':8,'class':'qs_filter'}))
    side = forms.ChoiceField(label='Сторона', choices=CAR_SIDES, required=False, widget=forms.Select(attrs={'class':'qs_filter'}))
    
class OrderedItemForm(forms.Form):
    status = forms.ChoiceField(choices=ORDER_ITEM_STATUSES, required=False)
    price = forms.CharField(required=False)
    part_number_superseded = forms.CharField(required=False)
    brand = forms.CharField(required=False)
    quantity_ship = forms.IntegerField(required=False)
    
    def clean_price(self):
        if self.clean_data['price']:
            try:
                value = float(self.clean_data['price'])
            except:
                raise forms.ValidationError('This field requires a decimal value.')
            return value
        else:
            return self.clean_data['price']
        
class InvoiceFilterForm(forms.Form):
    po_po = forms.CharField()
    
class InvoiceForm(forms.Form):
    places_num = forms.IntegerField(required=True, label='Количество мест')
    weight_kg = forms.CharField(required=True, label='Вес, кг')
    shipping_cost = forms.CharField(required=True, label='Стоимость доставки')
    
    def clean_shipping_cost(self):
        if self.clean_data['shipping_cost']:
            try:
                value = float(self.clean_data['shipping_cost'])
            except:
                raise forms.ValidationError('This field requires a decimal value.')
            return value
        else:
            return self.clean_data['shipping_cost']
        
class InvoiceItemForm(forms.Form):
    price = forms.CharField(required=False)
    quantity = forms.IntegerField(required=False)
    
    def clean_price(self):
        if self.clean_data['price']:
            try:
                value = float(self.clean_data['price'])
            except:
                raise forms.ValidationError('This field requires a decimal value.')
            return value
        else:
            return self.clean_data['price']
        
    