# -*- coding=UTF-8 -*-
from django import forms
#from django.contrib.admin.widgets import AdminDateWidget
#from django.newforms.extras.widgets import SelectDateWidget 
from lib.extras.widgets import SelectDateWidget
from lib.date import date_month_ago, date_today

class UserAuthForm(forms.Form):
    username = forms.CharField(label='Имя')
    password = forms.CharField(widget=forms.PasswordInput(), label='Пароль')

class Selectperiod(forms.Form):
    from_date = forms.DateField(initial=date_month_ago(), label=u"Начало периода", widget=SelectDateWidget())
    to_date = forms.DateField(label=u"Конец периода", initial=date_today(), widget=SelectDateWidget())
    
    