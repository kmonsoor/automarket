# -*- coding=UTF-8 -*-

from django import forms
from common.views import PartSearch

def makers():
    l = PartSearch().get_make_options()
    l.insert(0, ('', '----------'))
    return l

class SearchForm(forms.Form):

    def __init__(self, *args, **kwargs):
        maker_choices = kwargs.pop("maker_choices", makers())
        super(SearchForm, self).__init__(*args, **kwargs)
        self.fields['maker'].widget.choices = maker_choices

    maker = forms.CharField(widget=forms.Select(choices=[]), label=u'MAKE', required=True)
    part_number = forms.CharField(widget=forms.TextInput(attrs={'size':15}), label=u'Part Number', required=True)

