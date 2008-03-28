# -*- coding=UTF-8 -*-
import datetime
from django import newforms as forms
from data.models import *

from lib.widgets import JQueryAutoComplete

CH = ((None,''),)+CAR_SIDES

data = [x.name for x in Brand.objects.all()]

class OrderItemForm(forms.Form):
    car_maker = forms.CharField(widget=forms.TextInput(attrs={'size':20}))
    car_model = forms.CharField(widget=forms.TextInput(attrs={'size':20}))
    engine_volume = forms.CharField(widget=forms.TextInput(attrs={'size':4}))
    year = forms.DateField(input_formats="%Y", widget=forms.TextInput(attrs={'size':4}))
    # TODO - jquery etc.
    brand = forms.CharField(widget=JQueryAutoComplete(source=data))
    #
    description = forms.CharField(max_length=255, widget=forms.TextInput(attrs={'size':'80'}))
    side = forms.CharField(widget=forms.Select(choices=CH), required=False)
    part_number = forms.CharField(max_length=50)
    quntity = forms.IntegerField(min_value=1)
    
  