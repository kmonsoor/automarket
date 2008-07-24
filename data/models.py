# -*- coding=UTF-8 -*-

from django.db import models

from django.contrib.auth.models import User

from data.managers import *

import datetime, time

class Po(models.Model):
    user = models.ForeignKey(User, verbose_name="Пользователь")
    po = models.CharField(maxlength=255, verbose_name="Буквенная часть РО")
    
    class Meta:
        verbose_name = 'PO'
        verbose_name_plural = 'PO'
    
    def get_po_tariff_link(self):
        return '<a href="/admin/data/po/tarif/%d/">Установить тарифы</a>' % self.id
    
    get_po_tariff_link.allow_tags = True
    get_po_tariff_link.short_description = 'Дополнительные действия'
    
    class Admin:
        list_display = ('po','user','get_po_tariff_link')
        
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


CAR_SIDES = (('',''),('R','R'),('L','L'),)

ORDER_ITEM_STATUSES = (
                       ('order','Новый заказ'),
                       ('in_processing','В работе'),
                       ('superseded','Замена'),
                       ('out_of_stock','Нет на складе'),
                       ('back_order','Остаток'),
                       ('wrong_number','Неверный номер'),
                       ('on_stock','Получено'),
                       ('shipped','Отгружено'),
)

TRUSTED_USER_ORDER_ITEM_STATUSES = (
                       ('order','Новый заказ'),
                       ('in_processing','В работе'),
                       ('superseded','Замена'),
                       ('out_of_stock','Нет на складе'),
                       ('back_order','Остаток'),
                       ('wrong_number','Неверный номер'),
                       ('shipped','Отгружено'),
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
    quantity_ship = models.IntegerField(verbose_name="Отгружено")
    status = models.CharField(maxlength=50, choices=ORDER_ITEM_STATUSES, default='order', verbose_name="Статус")
    description = models.TextField(verbose_name="Описание")
    brand = models.ForeignKey(Brand, null=True, blank=True, verbose_name="Производитель запчасти")
    created = models.DateTimeField(auto_now_add=True, verbose_name="Дата заказа")
    modified = models.DateTimeField(auto_now=True, verbose_name="Дата изменения", editable=False)
    status_modified = models.DateTimeField(verbose_name="Дата изменения статуса", editable=False)
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

# Extend User model
def is_trusted(self):
    return self.id in [x.id for x in TrustedUsers.objects.all()]

User.add_to_class('is_trusted', is_trusted)


# Invoices model
class Invoice(models.Model):
    creator = models.ForeignKey(User, verbose_name='Создатель инвойса', related_name='invoice_creator')
    po = models.ForeignKey(Po, verbose_name='Po', related_name='invoice_po')
    created = models.DateTimeField(auto_now_add=True)
    modified = models.DateTimeField(auto_now=True)
    places_num = models.IntegerField(blank=True, null=True, verbose_name="Количество мест")
    weight_kg = models.FloatField(blank=True, null=True, verbose_name="Количество кг", max_digits=15, decimal_places=3)
    shipping_cost = models.FloatField(blank=True, null=True, verbose_name="Стоимость доставки", max_digits=15, decimal_places=2)

class InvoiceItem(models.Model):
    invoice = models.ForeignKey(Invoice)
    ordered_item = models.ForeignKey(OrderedItem)
    quantity = models.IntegerField(default=0)
    price = models.FloatField(max_digits=15, decimal_places=2,  null=True, blank=True, verbose_name="Цена")
    objects = InvoiceItemManager()


# Bill TO user
class Bill(models.Model):
    user = models.ForeignKey(User)
    invoice = models.ForeignKey(Invoice, null=True, blank=True)
    payment_for = models.CharField(maxlength=255)
    payment_sum = models.FloatField(default=0, max_digits=15, decimal_places=2)
    created = models.DateTimeField(auto_now_add=True)

# Payments from user
class Payment(models.Model):
    user = models.ForeignKey(User)
    payment_for = models.CharField(maxlength=255)
    payment_sum = models.FloatField(default=0, max_digits=15, decimal_places=2)
    created = models.DateTimeField(auto_now_add=True)

class Tarif(models.Model):
    po = models.ForeignKey(Po, verbose_name='PO')
    default_value = models.FloatField(max_digits=15, decimal_places=2, verbose_name='Множитель по умолчанию', default=1, blank=True)
    
    def __str__(self):
        return '%s (%d)' % ( self.po, self.id )

class TarifClass(models.Model):
    tarif = models.ForeignKey(Tarif, verbose_name='Тариф', editable=False)
    brand = models.ForeignKey(Brand, verbose_name='Производитель', editable=False)
    value = models.FloatField(max_digits=15, decimal_places=2, verbose_name='Множитель', default=1, blank=True)
    
    def __str__(self):
        return '%s - %s' % (self.tarif, self.brand)
    
    class Meta:
        verbose_name = 'тарифный план'
        verbose_name_plural = 'Tарифные планы'
        unique_together = (('tarif', 'brand'),)
    
    class Admin:
        list_display = ('tarif','brand', 'value')
        list_filter = ('brand',)
        search_fields = ('tarif.po',)
    
               

def createTarifClasses(po):
    tarif, created = Tarif.objects.get_or_create(po=po)
    brands = Brand.objects.all()        
    for b in brands:
        tc, created = TarifClass.objects.get_or_create(brand=b, tarif=tarif)


from django.dispatch import dispatcher  
from django.db.models import signals 


def on_po_save(sender, instance, signal, *args, **kwargs):
    if 'created' in kwargs:  
        if kwargs['created']:
            createTarifClasses(instance)
dispatcher.connect(on_po_save, signal=signals.post_save, sender=Po)

def on_brand_save(sender, instance, signal, *args, **kwargs):
    if 'created' in kwargs:
        if kwargs['created']:
            for po in Po.objects.all():
                tarif, created = Tarif.objects.get_or_create(po=po)
                tc, created = TarifClass.objects.get_or_create(brand=instance, tarif=tarif)
dispatcher.connect(on_brand_save, signal=signals.post_save, sender=Brand)
