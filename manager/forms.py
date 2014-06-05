# -*- coding=UTF-8 -*-

from django import forms
from django.contrib.auth.models import User

from lib.dynamicforms import Form

from data.models import BrandGroup, Brand, Area


def brandgroups():
    g = [
        (x.id, "%s :: %s" % (x.direction, x.title))
        for x in BrandGroup.objects.all().order_by('-direction__title')]
    g.insert(0, ('', 'выбрать'))
    return g


def users():
    users = [(x.id, str(x)) for x in User.objects.filter(is_staff=False).order_by('username')]
    users.insert(0, ('', 'выбрать',))
    return users


class OrderItemForm(Form):
    TEMPLATE = 'manager/order_form.html'
    CORE = ('part_number',)

    supplier = forms.CharField(
        widget=forms.Select(choices=(), attrs={'onchange': 'changeDir(this);'}),
        label=u'DIR',
        required=True)

    area = forms.CharField(
        widget=forms.TextInput(),
        label=u'Поставщик',
        required=True)

    brand = forms.CharField(
        widget=forms.TextInput(),
        label=u'Бренд',
        required=True)

    part_number = forms.CharField(
        widget=forms.TextInput(),
        label=u'PART #',
        required=True)

    comment_customer = forms.CharField(
        widget=forms.Textarea(),
        label=u'COMMENT 1',
        required=False)

    quantity = forms.IntegerField(
        min_value=1,
        widget=forms.TextInput(attrs={'class': 'quantity'}),
        label=u'Q',
        required=True)

    client = forms.CharField(
        widget=forms.Select(),
        label=u'CL',
        required=True)

    description_ru = forms.CharField(
        widget=forms.Textarea(),
        label=u'RUS',
        required=False)

    description_en = forms.CharField(
        widget=forms.Textarea(),
        label=u'ENG',
        required=False)

    price_base = forms.FloatField(
        widget=forms.TextInput(),
        label=u'LIST',
        required=True)

    price_sale = forms.FloatField(
        widget=forms.TextInput(attrs={'class': 'priceSale'}),
        label=u'PRICE',
        required=True)

    def __init__(self, *args, **kwargs):
        self.client_choice = kwargs.pop('client_choice')
        super(OrderItemForm, self).__init__(*args, **kwargs)
        self.fields['client'].widget.choices = self.client_choice
        self.fields['supplier'].widget.choices = brandgroups()


    def clean_area(self):
        area = self.cleaned_data.get('area')
        if area:
            try:
                area = Area.objects.get(title__iexact=area)
            except Area.DoesNotExist:
                raise forms.ValidationError(
                    u"Такого поставщика не существует")
            else:
                supplier = self.cleaned_data.get('supplier')
                if supplier:
                    brandgroup = BrandGroup.objects.get(id=supplier)
                    if area not in brandgroup.area.all():
                        raise forms.ValidationError(
                            u"Этот поставщик не входит в выбранное направление")
            return area


    def clean_brand(self):
        brand = self.cleaned_data.get('brand')
        if brand:
            try:
                brand = Brand.objects.get(title__iexact=brand)
            except Brand.DoesNotExist:
                raise forms.ValidationError(u"Такого бренда не существует")
            else:
                area = self.cleaned_data.get('area')
                if area and brand not in area.brands.all():
                    raise forms.ValidationError(
                        u"Этот бренд не входит в выбранное направление")

            return brand

    def clean_client(self):
        client = self.cleaned_data.get('client')
        if client:
            try:
                client = User.objects.get(id=client)
            except User.DoesNotExist:
                raise forms.ValidationError(
                    u"Такого пользователя не существует")
            return client


class SearchForm(forms.Form):

    maker = forms.CharField(
        widget=forms.Select(choices=[]),
        label=u'MAKE', required=False)

    part_number = forms.CharField(
        widget=forms.TextInput(),
        label=u'Part Number',
        required=True)

    def __init__(self, *args, **kwargs):
        maker_choices = kwargs.pop("maker_choices")
        super(SearchForm, self).__init__(*args, **kwargs)
        self.fields['maker'].widget.choices = maker_choices