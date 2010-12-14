# -*- coding=UTF-8 -*-

import datetime
from django import forms
from django.conf import settings
from django.contrib.auth.models import User
from data.models import BrandGroup, Brand, OrderedItem, Car
from common.views import PartSearch
from lib.widgets import JQueryAutoComplete
from lib.dynamicforms import Form


def users():
    users = [(x.id, str(x)) for x in User.objects.filter(is_staff=False)]
    users.insert(0, ('', 'выбрать',))
    return users

def brandgroups():
    list = [(x.id, "%s :: %s" % (x.direction, x.title)) for x in BrandGroup.objects.all()]
    list.insert(0, ('', 'выбрать'))
    return list


class OrderItemForm(Form):
    TEMPLATE = 'cp/ordereditem_form.html'
    CORE = ('part_number',)

    supplier = forms.CharField(widget=forms.Select(choices=()), label=u'DIR', required=True)
    brand = forms.CharField(widget=forms.TextInput(attrs={'size':15}), label=u'BRAND', required=True)
    part_number = forms.CharField(widget=forms.TextInput(attrs={'size':15}), label=u'PART #',required=True)
    comment_customer = forms.CharField(widget=forms.Textarea(attrs={'cols':15, 'rows':3}), label=u'COMMENT 1', required=False)
    comment_supplier = forms.CharField(widget=forms.TextInput(attrs={'size':15}), label=u'COMMENT 2', required=True)
    quantity = forms.IntegerField(min_value=1, widget=forms.TextInput(attrs={'size':5, 'class':'quantity'}), label=u'Q', required=True)
    client_id = forms.CharField(widget=forms.Select(choices=users()), label=u'CL', required=True)
    description_ru = forms.CharField(widget=forms.Textarea(attrs={'cols':15, 'rows':3}), label=u'RUS', required=False)
    description_en = forms.CharField(widget=forms.Textarea(attrs={'cols':15, 'rows':3}), label=u'ENG', required=False)
    price_base = forms.FloatField(widget=forms.TextInput(attrs={'size':5}), label=u'LIST', required=True)
    price_sale = forms.FloatField(widget=forms.TextInput(attrs={'size':5, 'class': 'priceSale'}), label=u'PRICE', required=True)
    def __init__(self, *args, **kwargs):
        super(OrderItemForm, self).__init__(*args, **kwargs)
        self.fields['client_id'].widget.choices = users()
        self.fields['supplier'].widget.choices = brandgroups()


    def clean_brand(self):
        brand = self.cleaned_data['brand']
        try:
            brand = Brand.objects.get(title=brand)
        except Brand.DoesNotExist:
            raise forms.ValidationError(u"Такого бренда не существует")

        return brand
    
    def clean_comment_supplier(self):
        car = self.cleaned_data['comment_supplier']
        try:
            car = Car.objects.get(title=car)
        except Car.DoesNotExist:
            raise forms.ValidationError(u"Такой марки не существует")
        
        return car

def makers():
    list = PartSearch().get_make_options()
    list.insert(0, ('', 'Select Make'))
    return list

class SearchForm(forms.Form):
    maker = forms.CharField(widget=forms.Select(choices=makers()), label=u'MAKE', required=True)
    part_number = forms.CharField(widget=forms.TextInput(attrs={'size':15}), label=u'Part Number', required=True)

class ImportXlsForm(forms.Form):
    xls_file = forms.Field(widget=forms.FileInput(), required=False, label="Файл")
