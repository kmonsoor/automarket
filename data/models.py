# -*- coding=UTF-8 -*-
import datetime, time

from django.db import models
from django.contrib.auth.models import User

from data.managers import *

class Po(models.Model):
    user = models.ForeignKey(User, verbose_name=u"Пользователь")
    po = models.CharField(max_length=255, verbose_name=u"Буквенная часть РО")
    
    class Meta:
        verbose_name = u'PO'
        verbose_name_plural = u'PO'
    
    def get_po_tariff_link(self):
        return u'<a href="/admin/data/po/tarif/%d/">Установить тарифы</a>' % self.id
    
    get_po_tariff_link.allow_tags = True
    get_po_tariff_link.short_description = u'Дополнительные действия'
        
    def __unicode__(self):
        return u'%s: %s' % (self.user.username, self.po)

# part maker
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
        else :
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

    po = models.ForeignKey(Po, verbose_name=u"РО")
    ponumber = models.IntegerField(verbose_name=u"Номер заказа")
    # car details
    car_maker = models.CharField(max_length=255, null=True, blank=True, verbose_name=u"Производитель машины")
    car_model = models.CharField(max_length=255, null=True, blank=True, verbose_name=u"Модель")
    year = models.CharField(max_length=4, null=True, blank=True, verbose_name=u"Год выпуска")
    engine_volume = models.CharField(max_length=10, null=True, blank=True, verbose_name=u"Объем двигателя")
    side = models.CharField(max_length=1, choices=CAR_SIDES, blank=True, null=True, verbose_name=u"Сторона")
    # item details
    part_number = models.CharField(max_length=255, verbose_name=u"Номер")
    part_number_superseded = models.CharField(max_length=255, null=True, blank=True , verbose_name=u"Новый номер")
    price = models.FloatField(null=True, blank=True, verbose_name=u"Цена")
    quantity = models.IntegerField(verbose_name=u"Количество")
    quantity_ship = models.IntegerField(verbose_name=u"Отгружено")
    status = models.CharField(max_length=50, choices=ORDER_ITEM_STATUSES, default='order', verbose_name=u"Статус")
    previous_status = models.CharField(max_length=50, verbose_name=u"Прежний статус", null=True, blank=True,)
    description = models.TextField(verbose_name=u"Описание")
    brand = models.ForeignKey(Brand, null=True, blank=True, verbose_name=u"Производитель запчасти")
    created = models.DateTimeField(auto_now_add=True, verbose_name=u"Дата заказа")
    modified = models.DateTimeField(auto_now=True, verbose_name=u"Дата изменения", editable=False)
    status_modified = models.DateTimeField(verbose_name=u"Дата изменения статуса", editable=False)
    confirmed = models.BooleanField(default=False, verbose_name=u"Подтверждено")

    comments = models.TextField(blank=True, null=True, verbose_name=u"Комментарии")


    objects = OrderedItemManager()

    def get_numbered_po(self):
        return u'%s%d' % (self.po.po, self.ponumber)

    get_numbered_po.short_description = u"РО позиции"

    def user(self):
        return self.po.user
    user.short_description = u"Заказчик"
    class Admin:
        list_display =('get_numbered_po','created', 'user', 'po','part_number','part_number_superseded','quantity')
        list_filter = ('created',)
        search_fields = ('part_number',)

    def __unicode__(self):
        return "%s-%d" % (self.created, self.id)

    def save(self, *args, **kwargs):
        self.quantity_backorder = int(self.quantity) - int(self.quantity_ship)
        self.brand = self.brand.unify()

        super(OrderedItem, self).save(*args, **kwargs)

    def status_verbose(self):
        return dict(ORDER_ITEM_STATUSES).get(self.status,self.status)

    class Meta:
        verbose_name = u"позицию"
        verbose_name_plural = u"Заказанные позиции"

class TrustedUsers(models.Model):
    user = models.ForeignKey(User, unique=True, verbose_name=u"Пользователь")

    def __unicode__(self):
        return self.user.username

    class Admin:
        pass

    class Meta:
        verbose_name = u"пользователя в доверенные"
        verbose_name_plural = u"Доверенные пользователи"

# Extend User model
def is_trusted(self):
    return self.id in [x.id for x in TrustedUsers.objects.all()]

User.add_to_class('is_trusted', is_trusted)


# Invoices model
class Invoice(models.Model):
    creator = models.ForeignKey(User, verbose_name=u'Создатель инвойса', related_name=u'invoice_creator')
    po = models.ForeignKey(Po, verbose_name=u'Po', related_name=u'invoice_po')
    created = models.DateTimeField(auto_now_add=True)
    modified = models.DateTimeField(auto_now=True)
    places_num = models.IntegerField(blank=True, null=True, verbose_name=u"Количество мест")
    weight_kg = models.FloatField(blank=True, null=True, verbose_name=u"Количество кг")
    shipping_cost = models.FloatField(blank=True, null=True, verbose_name=u"Стоимость доставки")
    
    
    def __unicode__(self):
        return u"%s - %s" % (self.po, self.created)
    
    def get_item_sum(self):
        return InvoiceItem.objects.summarize_by_invoice(self)
    
    def get_shipping_sum(self):
        return self.shipping_cost
    
    def get_total_sum(self):
        return self.get_item_sum() + self.get_shipping_sum()
    
    objects = InvoiceManager()

class InvoiceItem(models.Model):
    invoice = models.ForeignKey(Invoice)
    ordered_item = models.ForeignKey(OrderedItem)
    quantity = models.IntegerField(default=0)
    price = models.FloatField(null=True, blank=True, verbose_name=u"Цена")
    objects = InvoiceItemManager()


# Bill TO user
class Bill(models.Model):
    user = models.ForeignKey(User)
    payment_for = models.CharField(max_length=255)
    payment_sum = models.FloatField(default=0)
    created = models.DateTimeField(auto_now_add=True)
    modified = models.DateTimeField(auto_now=True)
    
    objects = BillManager()

# Payments from user
class Payment(models.Model):
    user = models.ForeignKey(User)
    payment_for = models.CharField(max_length=255)
    payment_sum = models.FloatField(default=0)
    created = models.DateTimeField(auto_now_add=True)
    
    objects = PaymentManager()

class Tarif(models.Model):
    po = models.ForeignKey(Po, verbose_name=u'PO')
    default_value = models.FloatField(verbose_name=u'Множитель по умолчанию', default=1, blank=True)
    
    def __unicode__(self):
        return u'%s (%d)' % ( self.po, self.id )

class TarifClass(models.Model):
    tarif = models.ForeignKey(Tarif, verbose_name=u'Тариф', editable=False)
    brand = models.ForeignKey(Brand, verbose_name=u'Производитель', editable=False)
    value = models.FloatField(verbose_name=u'Множитель', default=1, blank=True)
    
    def __unicode__(self):
        return u'%s - %s' % (self.tarif, self.brand)
    
    class Meta:
        verbose_name = u'тарифный план'
        verbose_name_plural = u'Tарифные планы'
        unique_together = (('tarif', 'brand'),)
    
    class Admin:
        list_display = ('tarif','brand', 'value')
        list_filter = ('brand',)
        search_fields = ('tarif.po',)
        
    def save(self, *args, **kwargs):
        update_tarif_classes(self)
        super(TarifClass, self).save(*args, **kwargs)

def update_tarif_classes(tarif_class):
    brands = get_brand_children(tarif_class.brand)
    if brands:
        for b in brands:
            try:
                tc = TarifClass.objects.get(tarif=tarif_class.tarif, brand=b)
                tc.value = tarif_class.value
                tc.save()
            except Exception, e:
                pass


def get_tarif_value(oi):
    if not isinstance(oi, OrderedItem):
        raise AttributeError(u"OrderedItem object expected!")
    value = 1
    try:
        tarif = Tarif.objects.get(po=oi.po)
        tarif_class = TarifClass.objects.get(tarif=tarif, brand=oi.brand)
        value = tarif_class.value
    except TarifClass.DoesNotExist:
        value = tarif.default_value
        
    return value


def createTarifClasses(po):
    tarif, created = Tarif.objects.get_or_create(po=po)
    brands = Brand.objects.all()        
    for b in brands:
        tc, created = TarifClass.objects.get_or_create(brand=b, tarif=tarif)

"""
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
"""
from django.db.models.signals import post_save

def on_po_save(sender, **kwargs):
    if 'created' in kwargs:  
        if kwargs['created']:
            instance = kwargs['instance']
            createTarifClasses(instance)
post_save.connect(on_po_save, sender=Po)

def on_brand_save(sender, **kwargs):
    if 'created' in kwargs:
        if kwargs['created']:
            instance = kwargs['instance']
            for po in Po.objects.all():
                tarif, created = Tarif.objects.get_or_create(po=po)
                tc, created = TarifClass.objects.get_or_create(brand=instance, tarif=tarif)
post_save.connect(on_brand_save, sender=Brand)