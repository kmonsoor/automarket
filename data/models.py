# -*- coding=UTF-8 -*-

import datetime, time
from django.db import models
from django.contrib.auth.models import User
from data.managers import OrderedItemManager, ActiveBrandManager


DIRECTIONS = (
    ('US', 'United States'),
    ('MSK', 'Moscow'),
)


class Supplier(models.Model):
    direction = models.CharField(choices=DIRECTIONS, verbose_name=u"Направление", max_length=3)
    po = models.CharField(verbose_name=u"РО", max_length=255)
    title = models.CharField(verbose_name=u"Название", max_length=10)
    description = models.TextField(verbose_name=u"Описание", null=True, blank=True)
    brands = models.ManyToManyField('Brand', verbose_name=u"Бренды")
    
    class Meta:
        verbose_name = u'Поставщик'
        verbose_name_plural = u'Поставщики'
    
    def __unicode__(self):
        return u"%s :: %s" % (self.title, self.direction)
    
    def get_next_ponumber(self):
        print self
        

class Brand(models.Model):
    name = models.CharField(max_length=255, verbose_name=u"Наименование")
    parent = models.ForeignKey('self',null=True,blank=True, verbose_name=u"Родитель")
    active = models.BooleanField(default=True, verbose_name=u"Активен")
    
    objects = models.Manager()
    active_objects = ActiveBrandManager()
    
    class Admin:
        list_display = ('name','_parents_repr')

    class Meta:
        verbose_name = u"производителя"
        verbose_name_plural = u"Производители запчастей"

    def __unicode__(self):
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

    def save(self, *args, **kwargs):
        p_list = self._recurse_for_parents(self)
        if self.name in p_list:
            raise validators.ValidationError(u"You can not add Brand into itself!")
        super(Brand, self).save(*args, **kwargs)

    def delete(self):
        self.active = False
        self.save()
        
    
    def unify(self):
        p_list = self._recurse_for_parents(self)
        if len(p_list) > 0:
            return p_list[len(p_list-1)]
        else:
            return self

    def unify(self):
        if self.parent != None:
            return self.parent
        else:
            return self


def get_brand_children(brand):
        try:
            return Brand.objects.filter(parent=brand)
        except:
            return False    

ORDER_ITEM_STATUSES = (
    ('order','НОВЫЙ ЗАКАЗ'),
    ('obtained','ПОЛУЧЕНО В ЗАКАЗ'),
    ('in_processing','В РАБОТЕ'),
    ('failure','ОТКАЗ'),
    ('wrong_number','НЕКОРРЕКТНЫЙ НОМЕР'),
    ('out_of_stock','ОТСУТСТВУЕТ НА СКЛАДЕ'),
    ('superseded','ЗАМЕНА НОМЕРА'),
    ('back_order','BACK ORDER'),
    ('received_supplier','ПОЛУЧЕНО ПОСТАВЩИКОМ'),
    ('in_delivery','В ДОСТАВКЕ'),
    ('received_warehouse','ПОЛУЧЕНО НА СКЛАД'),
    ('sent_representative','ОТПРАВЛЕНО ПРЕДСТАВИТЕЛЮ'),
    ('received_office','ПОЛУЧЕНО ОФИСОМ'),
    ('issued','ВЫДАНО'),
)


class OrderedItem(models.Model):
    supplier = models.ForeignKey(Supplier, verbose_name=u"Направление")
    ponumber = models.IntegerField(verbose_name=u"PO номер заказа")
    brand = models.ForeignKey(Brand, verbose_name=u"Бренд")
    part_number = models.CharField(verbose_name=u"Номер детали", max_length=255)
    part_number_superseded = models.CharField(max_length=255, null=True, blank=True , verbose_name=u"Новый номер(замена)")
    comment_customer = models.TextField(verbose_name=u"Комментарий заказчика", blank=True, null=True)
    comment_supplier = models.TextField(verbose_name=u"Комментарий поставщика", blank=True, null=True)
    
    #quantity_ship = models.IntegerField(verbose_name=u"Отгружено")
    quantity = models.PositiveIntegerField(verbose_name=u'Количество', null=True, blank=True)
    price_invoice = models.FloatField(verbose_name=u"Цена из инвойса от поставщика", blank=True, null=True)
    # quantity*price_invoice
    total_w_ship = models.FloatField(verbose_name=u"TOTAL", null=True, blank=True)
    
    client = models.ForeignKey(User, verbose_name=u"Клиент", related_name=u"client")
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

    objects = OrderedItemManager() 

    def __unicode__(self):
        return "%s-%d" % (self.created, self.id)
    
    class Meta:
        verbose_name = u"позицию"
        verbose_name_plural = u"Заказанные позиции"

    def save(self, *args, **kwargs):
        super(OrderedItem, self).save(*args, **kwargs)

    def get_status_verbose(self):
        return dict(ORDER_ITEM_STATUSES).get(self.status,self.status)
    
    def get_po_verbose(self):
        return u"%s%s" % (self.supplier.po, self.ponumber,)
        