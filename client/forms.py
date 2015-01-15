# -*- coding=UTF-8 -*-

from django import forms
from data.models import Basket


SEARCH_TYPE_CHOICES = (
    ('oem', u'OEM (AUTO)'),
    ('aftermarket', u'AFTERMARKET'),
    ('moto', u'OEM (MOTO)'),
)


class SearchForm(forms.Form):

    def __init__(self, *args, **kwargs):
        maker_choices = kwargs.pop("maker_choices")
        super(SearchForm, self).__init__(*args, **kwargs)
        self.fields['maker'].widget.choices = maker_choices

    maker = forms.CharField(
        widget=forms.Select(choices=[], attrs={'style':'width: 278px'}),
        label=u'MAKE',
        required=False)

    part_number = forms.CharField(
        widget=forms.TextInput(attrs={'style':'width: 269px;'}),
        label=u'Part Number',
        required=True)

    search_type = forms.ChoiceField(
        required=True,
        widget=forms.RadioSelect(attrs={'onchange': 'onchange_search_type()'}),
        choices=SEARCH_TYPE_CHOICES,
        initial='oem')

    search_in_analogs = forms.BooleanField(
        required=False,
        widget=forms.CheckboxInput,
        initial=False)


class BasketForm(forms.Form):
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
        self.user = kwargs.pop('user')
        super(BasketForm, self).__init__(*args, **kwargs)

    def save(self):
        'creates new Basket object'
        cd = self.cleaned_data
        cd['user'] = self.user
        b = Basket(**cd)
        b.save()
        return b

