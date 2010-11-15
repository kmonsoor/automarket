# -*- coding=UTF-8 -*-

import datetime
from django import forms
from django.conf import settings
from data.models import *
from lib.widgets import JQueryAutoComplete
from lib.dynamicforms import Form


def pos(user):
    return ((x.id, x.po) for x in Po.objects.filter(user=user))

def directions_for_select():
    directions = list(DIRECTIONS)
    directions.insert(0, (0, 'выбрать',))
    return directions


class OrderItemForm(Form):
    TEMPLATE = 'client/ordereditem_form.html'
    CORE = ('part_number',)
    
    direction = forms.CharField(widget=forms.Select(choices=directions_for_select()), required=True)
    brand = forms.CharField(widget=forms.TextInput(attrs={'size':8}), required=True)
    part_number = forms.CharField(widget=forms.TextInput(attrs={'size':8}), required=True)
    coment1 = forms.CharField(widget=forms.Textarea(attrs={'cols':'17', 'rows':5}))
    coment2 = forms.CharField(widget=forms.Textarea(attrs={'cols':'17', 'rows':5}))
    quantity = forms.IntegerField(min_value=1, widget=forms.TextInput(attrs={'size':5, 'class':'quantity'}), required=True)
    description_ru = forms.CharField(widget=forms.Textarea(attrs={'cols':'17', 'rows':5}))
    description_en = forms.CharField(widget=forms.Textarea(attrs={'cols':'17', 'rows':5}))
    price_base = forms.CharField(widget=forms.TextInput(attrs={'size':8}))
    price_sale = forms.CharField(widget=forms.TextInput(attrs={'size':8, 'class': 'priceSale'}))
    
    def clean_brand(self):
        if 'brand' in self.cleaned_data.keys() :
            self.cleaned_data['brand'] = self.cleaned_data['brand'].lower()
            if self.cleaned_data['brand'] not in brands() :
                raise forms.ValidationError("Такого производителя нет!")
        return self.cleaned_data['brand']        