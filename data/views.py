# -*- coding=UTF-8 -*-

import re
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User
from django.db import connection
from django.http import HttpResponseRedirect
from django.shortcuts import get_object_or_404
from django.utils.html import escape

from data.models import OrderedItem, Brand, BrandGroup, Area, Basket
from data.forms import BasketForm


re_RUS = re.compile(u'^([-_+.,:;!?><*&%$#@а-яА-Я0-9\u0451\u0401]|\s)+$')


def _redirect(request):
    path = request.GET.get('redirect_path')
    if path:
        return HttpResponseRedirect(path)
    return HttpResponseRedirect("/")


@login_required
def basket_add(request):
    form = BasketForm(request.POST or None, creator=request.user)

    if not form.is_valid():
        messages.add_message(request, messages.ERROR, u"Ошибка корзины")
        return _redirect(request)
    else:
        form.save()
        return _redirect(request)


@login_required
def basket_delete(request, item_id):
    b = get_object_or_404(Basket, creator=request.user, pk=item_id)
    b.delete()
    return _redirect(request)


@login_required
def basket_clear(request):
    Basket.objects.filter(creator=request.user, order_item_id__isnull=True).delete()
    messages.add_message(request, messages.SUCCESS, u"Корзина очищена")
    return _redirect(request)


def description_ru_validate(value=None):
    if value and re_RUS.match(value):
        return True
    return False


@login_required
def basket_update(request, redirect=True):
    bitems = [(x, y) for x, y in request.POST.copy().items() if x.startswith("quantity_")]
    errors = {'quantity': False, 'description_ru': False, 'comment1': False}
    # quantity
    for index, q in bitems:
        try:
            q = int(q)
            assert q >= 0
            item_id = int(index.split("_")[1])
            b = Basket.objects.get(creator=request.user, pk=item_id)
        except (AssertionError, TypeError, ValueError, IndexError, Basket.DoesNotExist):
            errors['quantity'] = True
        else:
            b.quantity = q
            b.save()

    # find description RUS
    descriptions = [(x, y) for x, y in request.POST.copy().items() if x.startswith("descriptionru_")]
    for index, value in descriptions:
        try:
            item_id = int(index.split("_")[1])
            assert description_ru_validate(value) is True

            b = Basket.objects.get(creator=request.user, pk=item_id)
            b.description_ru = value
            b.save()
        except (AssertionError, TypeError, ValueError, Basket.DoesNotExist):
            errors['description_ru'] = True

    # find comments
    comments = [(x, y) for x, y in request.POST.copy().items() if x.startswith("comment1_")]

    for index, value in [(x, y) for x, y in comments if y]:
        item_id = index.split("_")[1]
        try:
            b = Basket.objects.get(creator=request.user, pk=item_id)
            b.comment1 = escape(value)
            b.save()
        except Basket.DoesNotExist:
            pass

    if errors['quantity']:
        messages.add_message(request, messages.ERROR, u"Количество должно быть больше 0. Проверьте позиции")
    if errors['description_ru']:
        messages.add_message(request, messages.ERROR, u"Поле `Описание RUS` должно быть заполнено русскими буквами для каждой позиции. Пожалуйста, проверьте!")

    if redirect:
        messages.add_message(request, messages.SUCCESS, u"Корзина обновлена")
        return _redirect(request)
    else:
        return not any(errors.values())


@login_required
def basket_order(request):

    ok = basket_update(request, redirect=False)
    if not ok:
        return  _redirect(request)

    bi = Basket.objects.filter(creator=request.user, order_item_id__isnull=True)
    if not bi:
        messages.add_message(request, messages.ERROR, u"Ваша корзина пуста")
        return  _redirect(request)

    admin_default = User.objects.get(pk=1)

    try:
        user_profile = request.user.get_profile()
    except:
        manager = None
    else:
        manager = user_profile.client_manager or (user_profile.is_manager and request.user)

    brandgroup_default = BrandGroup.objects.get(title="OEM")

    def get_orderitem_data(item):
        data = {}

        if all([item.brandgroup, item.area, item.brand_name]):
            data['brandgroup'] = BrandGroup.objects.get(title__iexact=item.brandgroup)
            data['area'] = Area.objects.get(title__iexact=item.area)
            try:
                data['brand'] = Brand.objects.get(title__iexact=item.brand_name)
            except Brand.DoesNotExist:
                b = Brand(title=item.brand_name.capitalize())
                b.save()
                b.area_set.add(data['area'])
                data['brand'] = b
        else:  # remove it
            sql = """
            select a.area_id, a.brand_id from data_area_brands a
            left join data_brand b on (b.id=a.brand_id)
            left join data_area c on (c.id=a.area_id)
            where c.id in (select area_id from data_brandgroup_area where brandgroup_id=%s)
            and b.title=%s;
            """
            cursor = connection.cursor()
            cursor.execute(sql, [brandgroup_default.id, item.brand_name])
            rows = cursor.fetchall()
            cursor.close()

            if not rows:
                return (None, item)
            row = dict(zip(('area_id', 'brand_id'), rows[0]))
            data['brandgroup'] = brandgroup_default
            data['area'] = Area.objects.get(pk=row['area_id'])
            data['brand'] = Brand.objects.get(pk=row['brand_id'])

        data['description_en'] = item.description
        data['description_ru'] = item.description_ru or u""
        data['comment_customer'] = item.comment1 or u""
        data['client'] = item.user
        data['quantity'] = item.quantity
        data['part_number'] = item.part_number
        data['manager'] = manager or admin_default
        if user_profile.is_manager or request.user.is_staff:
            data['status'] = 'order'
        data['price_base'] = item.msrp
        data['price_sale'] = item.get_price()
        data['core_price'] = item.core_price
        return (data, item)

    to_save = [x for x in map(get_orderitem_data, list(bi)) if x[0]]
    client_order_id = OrderedItem.objects.get_next_client_order_id(request.user)

    for t, item in to_save:
        oi = OrderedItem(**t)
        oi.client_order_id = client_order_id
        oi.save()
        item.order_item_id = oi.id
        item.save()

    messages.add_message(request, messages.SUCCESS, u"Заказ оформлен")
    return _redirect(request)