# -*- coding=UTF-8 -*-
import datetime
from django import newforms as forms

from data.models import *

from lib.widgets import JQueryAutoComplete
from lib.dynamicforms import Form
CH = CAR_SIDES

data = [x.name for x in Brand.objects.all()]

def pos(user):
    return ((x.id, x.po) for x in Po.objects.filter(user=user))

class OrderItemForm(Form):
    
    TEMPLATE = 'client/ordereditem_form.html'
    CORE = ('part_number',)
    
    car_maker = forms.CharField(widget=forms.TextInput(attrs={'size':10}), required=False)
    car_model = forms.CharField(widget=forms.TextInput(attrs={'size':10}), required=False)
    engine_volume = forms.CharField(widget=forms.TextInput(attrs={'size':4}), required=False)
    year = forms.IntegerField(max_value=9999, min_value=1900, widget=forms.TextInput(attrs={'size':4}), required=False)
    #brand = forms.CharField(widget=JQueryAutoComplete(source=data))
    brand = forms.CharField()
    description = forms.CharField(max_length=255, widget=forms.Textarea(attrs={'cols':'20', 'rows':5}))
    side = forms.CharField(widget=forms.Select(choices=CH), required=False)
    part_number = forms.CharField(max_length=50)
    quantity = forms.IntegerField(min_value=1, widget=forms.TextInput(attrs={'size':8}))
    
    
    def clean_brand(self):
        if 'brand' in self.clean_data.keys() :
            if self.clean_data['brand'] not in data :
                raise forms.ValidationError("Такого производителя нет!")
        return self.clean_data['brand']

class PoForm(Form):
    
    def __init__(self, *ar, **kw):
        if 'user' in kw :
            self.user = kw.pop('user')
        self.base_fields['po'].widget.choices = pos(self.user)
        super(PoForm, self).__init__(*ar, **kw)
    
    po = forms.ChoiceField()

class ImportXlsForm(forms.Form):
    xls_file = forms.Field(widget=forms.FileInput(), required=False, label="Файл")        