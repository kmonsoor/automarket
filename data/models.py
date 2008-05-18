# -*- coding=UTF-8 -*-

from django.db import models
from django.contrib.auth.models import User

import datetime, time

class Po(models.Model):
    user = models.ForeignKey(User, verbose_name="Пользователь")
    po = models.CharField(maxlength=255, verbose_name="Буквенная часть РО")
    class Meta:
        verbose_name = 'PO'
        verbose_name_plural = 'PO'
    class Admin:
        pass
    def __str__(self):
        return '%s: %s' % (self.user.username, self.po)
    
# part maker
class Brand(models.Model):
    name = models.CharField(maxlength=255, verbose_name="Наименование")
    parent = models.ForeignKey('self',null=True,blank=True, verbose_name="Родитель")
    
    class Admin:
        list_display = ('name','_parents_repr')
    
    class Meta:
        verbose_name = "производителя"
        verbose_name_plural = "Производители запчастей"
    
    def __str__(self):
        p_list = self._recurse_for_parents(self)
        p_list.append(self.name)
        return self.get_separator().join(p_list)
    
    def _recurse_for_parents(self, cat_obj):
        p_list = []
        if cat_obj.parent_id:
            p = cat_obj.parent
            p_list.append(p.name)
            more = self._recurse_for_parents(p)
            p_list.extend(more)
        if cat_obj == self and p_list:
            p_list.reverse()
        return p_list
        
    def get_separator(self):
        return ' :: '
    
    def _parents_repr(self):
        p_list = self._recurse_for_parents(self)
        return self.get_separator().join(p_list)
    _parents_repr.short_description = "Parents"
    
    def save(self):
        p_list = self._recurse_for_parents(self)
        if self.name in p_list:
            raise validators.ValidationError(u"You can not add Brand into itself!")
        super(Brand, self).save()
    
    def unify(self):
        p_list = self._recurse_for_parents(self)
        if len(p_list) > 0:
            return p_list[len(p_list-1)]
        else :
            return self            
    
    def unify(self):
        if self.parent != None:
            return self.parent
        else:
            return self


CAR_SIDES = ((None,''),('R','R'),('L','L'),)

ORDER_ITEM_STATUSES = (
                       ('order',u'Новый заказ'),
                       ('in_processing',u'В работе'),
                       ('superseded',u'Замена'),
                       ('out_of_stock',u'Нет на складе'),
                       ('back_order',u'Остаток'),
                       ('wrong_number',u'Неверный номер'),
                       ('not_produce',u'Не производится'),
                       ('on_stock',u'Получено'),
)

TRUSTED_USER_ORDER_ITEM_STATUSES = (
                       ('order',u'Новый заказ'),
                       ('in_processing',u'В работе'),
                       ('superseded',u'Замена'),
                       ('out_of_stock',u'Нет на складе'),
                       ('back_order',u'Остаток'),
                       ('wrong_number',u'Неверный номер'),
                       ('not_produce',u'Не производится'),
)

from data.managers import OrderedItemManager
class OrderedItem(models.Model):

    po = models.ForeignKey(Po, verbose_name="РО")
    ponumber = models.IntegerField(verbose_name="Номер заказа")
    # car details
    car_maker = models.CharField(maxlength=255, null=True, blank=True, verbose_name="Производитель машины")
    car_model = models.CharField(maxlength=255, null=True, blank=True, verbose_name="Модель")
    year = models.CharField(maxlength=4, null=True, blank=True, verbose_name="Год выпуска")
    engine_volume = models.CharField(maxlength=10, null=True, blank=True, verbose_name="Объем двигателя")
    side = models.CharField(maxlength=1, choices=CAR_SIDES, blank=True, null=True, verbose_name="Сторона")
    # item details
    part_number = models.CharField(maxlength=255, verbose_name="Номер")
    part_number_superseded = models.CharField(maxlength=255, null=True, blank=True , verbose_name="Новый номер")
    price = models.FloatField(max_digits=15, decimal_places=2,  null=True, blank=True, verbose_name="Цена")
    quantity = models.IntegerField(verbose_name="Количество")
    quantity_backorder = models.IntegerField(verbose_name="Осталось довести")
    quantity_ship = models.IntegerField(verbose_name="Отгружено")
    status = models.CharField(maxlength=50, choices=ORDER_ITEM_STATUSES, default='order', verbose_name="Статус")
    description = models.TextField(verbose_name="Описание")
    brand = models.ForeignKey(Brand, null=True, blank=True, verbose_name="Производитель запчасти")
    created = models.DateTimeField(auto_now=True, verbose_name="Дата заказа")
    confirmed = models.BooleanField(default=False, verbose_name="Подтверждено")
    
    comments = models.TextField(blank=True, null=True, verbose_name="Комментарии")
    
    
    objects = OrderedItemManager()
    
    def get_numbered_po(self):
        return '%s%d' % (self.po.po, self.ponumber)
    
    get_numbered_po.short_description = "РО позиции"
    
    def user(self):
        return self.po.user
    user.short_description = "Заказчик"
    class Admin:
        list_display =('get_numbered_po','created', 'user', 'po','part_number','part_number_superseded','quantity')
        list_filter = ('created',)
        search_fields = ('part_number',)
    
    def __str__(self):
        return "%s-%d" % (self.created, self.id)
    
    def save(self):
        self.quantity_backorder = int(self.quantity) - int(self.quantity_ship)
        self.brand = self.brand.unify()

        super(OrderedItem, self).save()
    
    def status_verbose(self):
        return dict(ORDER_ITEM_STATUSES).get(self.status,self.status)
    
    class Meta:
        verbose_name = "позицию"
        verbose_name_plural = "Заказанные позиции"

class TrustedUsers(models.Model):
    user = models.ForeignKey(User, unique=True, verbose_name="Пользователь")
    
    def __str__(self):
        return self.user.username
    
    class Admin:
        pass
    
    class Meta:
        verbose_name = "пользователя в доверенные"
        verbose_name_plural = "Доверенные пользователи"
        
class Managers(models.Model):
    user = models.ForeignKey(User, unique=True, verbose_name="Пользователь")
    
    def __str__(self):
        return self.user.username
    
    class Admin:
        pass
    
    class Meta:
        verbose_name = "пользователя в менеджеры"
        verbose_name_plural = "Менеджеры"