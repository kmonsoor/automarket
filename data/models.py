# -*- coding=UTF-8 -*-

import datetime, time
from django.db import models
from django.contrib.auth.models import User, Group
from data.managers import OrderedItemManager

Group.add_to_class('discount', models.PositiveIntegerField(blank=True, null=True, default=0, verbose_name=u'Скидка в %'))

class Direction(models.Model):
    title = models.CharField(max_length=255, verbose_name=u"Название")
    po = models.CharField(max_length=255, verbose_name=u"PO")
    
    class Meta:
        verbose_name = u'Направление'
        verbose_name_plural = u'Направления'
    
    def __unicode__(self):
        return u"%s" % self.title


class BrandGroup(models.Model):
    direction = models.ForeignKey(Direction, verbose_name=u"Направление")
    title = models.CharField(verbose_name=u"Название", max_length=10)
    description = models.TextField(verbose_name=u"Описание", null=True, blank=True)
    area = models.ManyToManyField('Area', verbose_name=u"Поставщики", null=True, blank=True)
    delivery = models.FloatField(verbose_name=u"Доставка", default=0)
    add_brand_to_comment = models.BooleanField(verbose_name=u"В поле 'Comment2' добавляется значение поля 'Brand'", default = False)

    class Meta:
        verbose_name = u'Группа поставщиков'
        verbose_name_plural = u'Группы поставщиков'

    def __unicode__(self):
        return u"%s::%s" % (self.direction, self.title)
    
    
class Area(models.Model):
    title = models.CharField(max_length=255, verbose_name=u"Название")
    brands = models.ManyToManyField('Brand', null=True, blank=True, verbose_name=u'Бренды')
    
    class Meta:
        verbose_name = u"Поставщик"
        verbose_name_plural = u"Поставщики"

    def __unicode__(self):
        return u"%s" % self.title    


class Brand(models.Model):
    title = models.CharField(max_length=255, verbose_name=u"Название")

    class Meta:
        verbose_name = u"Бренд"
        verbose_name_plural = u"Бренды"

    def __unicode__(self):
        return u"%s" % self.title

ORDER_ITEM_STATUSES = (
    ('order',u'новый заказ'),
    ('obtained',u'получено в заказ'),
    ('in_processing',u'в работе'),
    ('failure',u'отказ'),
    ('wrong_number',u'нккорректный номер'),
    ('out_of_stock',u'отсутствует на складе'),
    ('superseded',u'замена номера'),
    ('back_order',u'back order'),
    ('received_supplier',u'получено поставщиком'),
    ('in_delivery',u'в доставке'),
    ('received_warehouse',u'получено со склада'),
    ('sent_representative',u'отправлено представителю'),
    ('received_office',u'получено офисом'),
    ('issued',u'выдано'),
)


class Discount(models.Model):
    user = models.ForeignKey(User, verbose_name = u"Пользователь")
    area = models.ForeignKey(Area, verbose_name = u"Поставщик")
    discount = models.FloatField(verbose_name = u"Скидка (%)")
    
    class Meta:
        verbose_name = u"Скидка"
        verbose_name_plural = u"Скидки"
        unique_together = ('user', 'area',)

    def __unicode__(self):
        return u"%s:%s: %s" % (self.user.username, self.area.title, self.discount)


class OrderedItem(models.Model):
    brandgroup = models.ForeignKey(BrandGroup, verbose_name=u"Группа поставщиков")
    area = models.ForeignKey(Area, verbose_name=u"Поставщик")
    brand = models.ForeignKey(Brand, verbose_name=u"Бренд")
    ponumber = models.IntegerField(verbose_name=u"Номер заказа", blank=True, null=True)
    part_number = models.CharField(verbose_name=u"Номер детали", max_length=255)
    part_number_superseded = models.CharField(max_length=255, null=True, blank=True , verbose_name=u"Новый номер(замена)")
    comment_customer = models.TextField(verbose_name=u"Комментарий заказчика", blank=True, null=True)
    comment_supplier = models.TextField(verbose_name=u"Комментарий поставщика", blank=True, null=True)

    quantity = models.PositiveIntegerField(verbose_name=u'Количество', null=True, blank=True)
    price_invoice = models.FloatField(verbose_name=u"Цена из инвойса от поставщика", blank=True, null=True)
    # quantity*price_invoice
    total_w_ship = models.FloatField(verbose_name=u"TOTAL", null=True, blank=True)

    client = models.ForeignKey(User, verbose_name=u"Клиент", related_name=u"client")
    client_order_id = models.IntegerField(verbose_name=u"Номер заказа для клиента", blank=True, null=True)
    manager = models.ForeignKey(User, verbose_name=u"Менеджер", related_name=u"manager")
    description_ru = models.TextField(verbose_name=u"Описание RUS", blank=True, null=True)
    description_en = models.TextField(verbose_name=u"Описание ENG", blank=True, null=True)

    price_base = models.FloatField(verbose_name=u'Базовая Цена', null=True, blank=True)
    price_sale = models.FloatField(verbose_name=u"Цена продажи", null=True, blank=True)
    price_discount = models.FloatField(verbose_name=u"Цена продажи со скидкой", null=True, blank=True)
    weight = models.FloatField(verbose_name=u"Вес одной детали", null=True, blank=True)
    #weight*Const
    delivery = models.FloatField(verbose_name=u"Доставка", null=True, blank=True)

    # price_discount + delievery OR price_sale + delivery
    cost = models.FloatField(verbose_name=u"Окончательная цена за деталь", null=True, blank=True)
    # cost*quantity
    total_cost = models.FloatField(verbose_name=u"Окончательная цена за все", null=True, blank=True)

    status = models.CharField(max_length=50, choices=ORDER_ITEM_STATUSES, default='order', verbose_name=u"Статус")
    status_modified = models.DateTimeField(verbose_name=u"Дата изменения статуса", editable=False, null=True, blank=True)

    previous_status = models.CharField(max_length=50, verbose_name=u"Прежний статус", null=True, blank=True,)
    created = models.DateTimeField(auto_now_add=True, verbose_name=u"Дата заказа")
    modified = models.DateTimeField(auto_now=True, verbose_name=u"Дата изменения", editable=False)
    invoice_code = models.CharField(max_length=255, verbose_name=u'Инвойс', default='')

    objects = OrderedItemManager()
    def __unicode__(self):
        return u"%s-%d" % (self.created, self.id)

    class Meta:
        verbose_name = u"Заказанная позиция"
        verbose_name_plural = u"Заказанные позиции"

    def save(self, *args, **kwargs):

        #if self.brandgroup.delivery and self.weight and self.quantity:
            #self.delivery = self.brandgroup.delivery*self.weight*self.quantity
        if self.weight and self.quantity:
            self.delivery = 13*self.weight

        if self.quantity and self.price_invoice:
            self.total_w_ship = self.price_invoice*self.quantity

        if self.price_sale and self.client and self.area and not self.price_discount:
            try:
                discount = Discount.objects.get(user=self.client, area=self.area)
                self.price_discount = self.price_sale - self.price_sale*discount.discount/100
            except Discount.DoesNotExist:
                self.price_discount = ''
            
        if self.delivery and self.price_sale and not self.price_discount:
            self.cost = self.delivery + self.price_sale
        elif self.delivery and self.price_discount:
            self.cost = self.delivery + self.price_discount

        if self.cost and self.quantity:
            self.total_cost = self.cost*self.quantity

        super(OrderedItem, self).save(*args, **kwargs)

    def get_status_verbose(self):
        return dict(ORDER_ITEM_STATUSES).get(self.status,self.status)

    def get_po_verbose(self):
        return u"%s%s" % (self.brandgroup.direction.po, self.ponumber,) if self.ponumber else ''