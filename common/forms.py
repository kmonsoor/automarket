# -*- coding=UTF-8 -*-
from django import newforms as forms

class UserAuthForm(forms.Form):
    username = forms.CharField(label='Имя')
    password = forms.CharField(widget=forms.PasswordInput(), label='Пароль')

    