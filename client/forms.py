# -*- coding=UTF-8 -*-

from django import forms
from common.views import PartSearch
from data.models import Basket

def makers():
    l = PartSearch().get_make_options()
    l.insert(0, ('', '----------'))
    return l

class SearchForm(forms.Form):

    def __init__(self, *args, **kwargs):
        maker_choices = kwargs.pop("maker_choices")
        super(SearchForm, self).__init__(*args, **kwargs)
        self.fields['maker'].widget.choices = maker_choices

    maker = forms.CharField(widget=forms.Select(choices=[], attrs={'style':'width: 200px'}), label=u'MAKE', required=True)
    part_number = forms.CharField(widget=forms.TextInput(attrs={'style':'width: 192px'}), label=u'Part Number', required=True)


class BasketForm(forms.Form):
    part_number = forms.CharField(required=False)
    description = forms.CharField(required=False)
    msrp = forms.FloatField(required=False)
    user_price = forms.FloatField(required=False)
    brand_name = forms.CharField(required=False)
    core_price = forms.FloatField(required=False)

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

