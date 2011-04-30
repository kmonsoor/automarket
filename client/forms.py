# -*- coding=UTF-8 -*-

from django import forms
from common.views import PartSearch

def makers():
    list = PartSearch().get_make_options()
    list.insert(0, ('', '----------'))
    return list

class SearchForm(forms.Form):
    maker = forms.CharField(widget=forms.Select(choices=makers()), label=u'MAKE', required=True)
    part_number = forms.CharField(widget=forms.TextInput(attrs={'size':15}), label=u'Part Number', required=True)

