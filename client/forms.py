# -*- coding=UTF-8 -*-

from django import newforms as forms
from data.models import *


class OrderItemForm(forms.Form):
    producer = 