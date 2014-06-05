# -*- coding=utf-8 -*-
import itertools
import datetime
import logging
logger = logging.getLogger('data.models')

from django.db import models, transaction
from django.conf import settings
from django.contrib.auth.models import User
from django.utils.html import mark_safe

from data.managers import OrderedItemManager
from data.settings import (
    AREA_MULTIPLIER_DEFAULT, AREA_DISCOUNT_DEFAULT,
    DELIVERY_DEFAULT, DELIVERY_PERIOD_DEFAULT,
    COST_MARGIN_DEFAULT
)


class Direction(models.Model):
    title = models.CharField(max_length=255, verbose_name=u"Название")
    po = models.CharField(max_length=255, verbose_name=u"PO")
    delivery = models.FloatField(
        verbose_name=u"доставка", blank=True, null=True)
    multiplier = models.DecimalField(
        u'множитель', max_digits=7, decimal_places=3, blank=True, null=True)
    cost_margin = models.FloatField(
        verbose_name=u"Коэффициент минимального профита", blank=True, null=True)
    delivery_period = models.IntegerField(
        u'Срок доставки (в днях)', blank=True, null=True)

    class Meta:
        verbose_name = u'Направление'
        verbose_name_plural = u'Направления'

    def __unicode__(self):
        return u"%s" % self.title


class BrandGroup(models.Model):
    direction = models.ForeignKey(Direction, verbose_name=u"Направление")
    title = models.CharField(verbose_name=u"Название", max_length=10)
    description = models.TextField(
        verbose_name=u"Описание", null=True, blank=True)
    delivery = models.FloatField(
        verbose_name=u"доставка", blank=True, null=True)
    multiplier = models.DecimalField(
        u'множитель', max_digits=7, decimal_places=3, blank=True, null=True)
    cost_margin = models.FloatField(
        verbose_name=u"Коэффициент минимального профита", blank=True, null=True)
    delivery_period = models.IntegerField(
        u'Срок доставки (в днях)', blank=True, null=True)
    area = models.ManyToManyField(
        'Area', verbose_name=u"Поставщики", null=True, blank=True)
    add_brand_to_comment = models.BooleanField(
        verbose_name=u"В поле 'Comment2' добавляется значение поля 'Brand'",
        default=False)

    class Meta:
        verbose_name = u'Группа поставщиков'
        verbose_name_plural = u'Группы поставщиков'

    def __unicode__(self):
        return u"%s::%s" % (self.direction, self.title)

    def price_settings(self):
        class ps(dict):
            __slots__ = ['area', 'multiplier', 'delivery']

        current_settings = dict(
            (x.area.id, x)
            for x in BrandGroupAreaSettings.objects.select_related().filter(
                brand_group=self))

        for area in self.area.all():
            if area.id in current_settings:
                multiplier, delivery = (
                    getattr(current_settings.get(area.id), x)
                    for x in ['multiplier', 'delivery'])
            else:
                multiplier = delivery = None

            yield ps(area=area, multiplier=multiplier, delivery=delivery)

    def get_settings(self):
        m = [
            self.multiplier,
            self.direction.multiplier,
            AREA_MULTIPLIER_DEFAULT]

        d = [
            self.delivery,
            self.direction.delivery,
            DELIVERY_DEFAULT]

        dp = [
            self.delivery_period,
            self.direction.delivery_period,
            DELIVERY_PERIOD_DEFAULT]

        cm = [
            self.cost_margin,
            self.direction.cost_margin,
            COST_MARGIN_DEFAULT]

        first = lambda xs: [x for x in xs if x is not None][0]
        return first(m), first(d), first(dp), None, first(cm)


class Area(models.Model):
    title = models.CharField(max_length=255, verbose_name=u"Название")
    brands = models.ManyToManyField(
        'Brand', null=True, blank=True, verbose_name=u'Бренды')

    class Meta:
        verbose_name = u"Поставщик"
        verbose_name_plural = u"Поставщики"
        ordering = ['title']

    def __unicode__(self):
        return u"%s" % self.title

    def get_brandgroup_settings(self, brand_group):
        try:
            s = BrandGroupAreaSettings.objects.get(
                area=self, brand_group=brand_group)
        except BrandGroupAreaSettings.DoesNotExist:
            return brand_group.get_settings()
        else:
            m = [
                s.multiplier,
                brand_group.multiplier,
                brand_group.direction.multiplier,
                AREA_MULTIPLIER_DEFAULT]

            d = [
                s.delivery,
                brand_group.delivery,
                brand_group.direction.delivery,
                DELIVERY_DEFAULT]

            dp = [
                s.delivery_period,
                brand_group.delivery_period,
                brand_group.direction.delivery_period,
                DELIVERY_PERIOD_DEFAULT]

            pu = s.price_updated_at

            cm = [
                s.cost_margin,
                brand_group.cost_margin,
                brand_group.direction.cost_margin,
                COST_MARGIN_DEFAULT]

            first = lambda xs: [x for x in xs if x is not None][0]
            return first(m), first(d), first(dp), pu, first(cm)


class BrandGroupAreaSettings(models.Model):

    brand_group = models.ForeignKey(
        BrandGroup, verbose_name=BrandGroup._meta.verbose_name)

    area = models.ForeignKey(
        Area, verbose_name=Area._meta.verbose_name)

    delivery = models.FloatField(
        verbose_name=u"Стоимость доставки (за кг)", blank=True, null=True)

    multiplier = models.DecimalField(
        u'множитель', max_digits=7, decimal_places=3, blank=True, null=True)

    cost_margin = models.FloatField(
        verbose_name=u"Коэффициент минимального профита",
        blank=True, null=True)

    delivery_period = models.IntegerField(
        u'Срок доставки (в днях)', blank=True, null=True)

    price = models.FileField(
        u"Файл с ценами", upload_to=settings.PRICE_UPLOAD_DIR,
        null=True, blank=True)

    price_updated_at = models.DateTimeField(
        u"Дата обновления цен", null=True, blank=True)

    def __unicode__(self):
        return u"%s - %s" % (self.brand_group, self.area)

    class Meta:
        unique_together = ('area', 'brand_group')
        verbose_name = u"запись настроек"
        verbose_name_plural = u"Настройки для поставщиков"


class Brand(models.Model):
    title = models.CharField(
        max_length=255, verbose_name=u"Название", unique=True)

    class Meta:
        verbose_name = u"Бренд"
        verbose_name_plural = u"Бренды"
        ordering = ['title']

    def __unicode__(self):
        return u"%s" % self.title


class Shipment(models.Model):
    code = models.CharField(
        verbose_name=u"Код", max_length=255)
    number = models.IntegerField(
        verbose_name=u"Номер", default=1)
    client = models.ForeignKey(
        User, verbose_name=u"Клиент", related_name=u"shipment_client")
    manager = models.ForeignKey(
        User, verbose_name=u"Менеджер", related_name=u"shipment_manager")
    user = models.ForeignKey(
        User, verbose_name=u"Создатель отгрузки", related_name=u"user")
    created_at = models.DateTimeField(
        verbose_name=u"Время создания", auto_now_add=True)
    created_at.editable = True

    class Meta:
        unique_together = ('code', 'number', 'client',)
        verbose_name = u"Отгрузка"
        verbose_name_plural = u"Отгрузки"

    def __unicode__(self):
        return u"%s %s" % (self.client, self.code,)

    @property
    def items(self):
        return OrderedItem.objects.filter(shipment=self)

    @property
    def packages(self):
        return Package.objects.filter(shipment=self)

    def full_code(self):
        return u"%s-%s" % (self.code, self.number)

    @property
    def cost(self):
        total_costs = []
        for item in self.items:
            total_costs.append(item.total_cost or 0)
        for package in self.packages:
            total_costs.append(package.total_cost or 0)
        return sum(total_costs)

    @property
    def weight(self):
        weights = []
        for item in self.items:
            if item.weight and item.quantity:
                weights.append(item.weight * item.quantity)
        for package in self.packages:
            if package.weight and package.quantity:
                weights.append(package.weight * package.quantity)
        return sum(weights)

    @classmethod
    @transaction.commit_on_success
    def _create(cls, request, orders=[], packages=[]):
        shipment_code = datetime.datetime.now().strftime("%d%m%y")
        by_clients_and_managers = {}

        orders_by_clients = {}
        for order in orders:
            orders_by_clients.setdefault(order.client, []).append(order)

        packages_by_clients = {}
        for package in packages:
            packages_by_clients.setdefault(package.client, []).append(package)

        for client, orders in orders_by_clients.iteritems():
            by_clients_and_managers.setdefault(client, {})
            for order in orders:
                by_clients_and_managers[client].setdefault(
                    order.manager, {'orders': [], 'packages': []}
                )['orders'].append(order)

        for client, packages in packages_by_clients.iteritems():
            by_clients_and_managers.setdefault(client, {})
            for package in packages:
                by_clients_and_managers[client].setdefault(
                    package.manager, {'orders': [], 'packages': []}
                )['packages'].append(package)

        shipments = []
        for client, by_manager in by_clients_and_managers.iteritems():

            shipment_number = Shipment.objects.filter(
                client=client,
                code=shipment_code
            ).aggregate(models.Max('number'))['number__max'] or 0

            for manager, items in by_manager.iteritems():
                shipment_number += 1
                shipment = Shipment(
                    code=shipment_code,
                    number=shipment_number,
                    client=client,
                    manager=manager,
                    user=request.user
                )
                shipment.save()

                if items['orders']:
                    (OrderedItem.objects
                    .filter(id__in=set(x.id for x in items['orders']))
                    .update(
                        shipment=shipment,
                        status='issued',
                        issued_at=datetime.datetime.now()))

                if items['packages']:
                    (Package.objects
                    .filter(id__in=set(x.id for x in items['packages']))
                    .update(
                        shipment=shipment,
                        status=PACKAGE_STATUS_ISSUED,
                        issued_at=datetime.datetime.now()))

                BalanceItem.create_by_shipment(
                    shipment, items['orders'], items['packages'])

                shipments.append(shipment)

        return shipments

    @transaction.commit_on_success
    def _delete(self):
        orders = OrderedItem.objects.filter(shipment=self)
        packages = Package.objects.filter(shipment=self)
        BalanceItem.backup_balanceitems_post_shipment_delete(
            self, orders, packages)
        orders.update(
            shipment=None, status='received_office', issued_at=None)
        packages.update(
            shipment=None, status=PACKAGE_STATUS_RECEIVED, issued_at=None)
        self.delete()
        return True


ORDER_ITEM_STATUSES = (
    ('order', u'новый заказ'),
    ('moderation', u'на модерации'),
    ('in_processing', u'в работе'),
    ('wrong_number', u'отказ: некорректный номер'),
    ('out_of_stock', u'отказ: отсутствует на складе'),
    ('cancelled_customer', u'отказ: снято заказчиком'),
    ('export_part', u'отказ: экспортная запчасть'),
    ('back_order', u'back order'),
    ('superseded', u'замена номера'),
    ('received_supplier', u'получено поставщиком'),
    ('in_delivery', u'в доставке'),
    ('sent_representative', u'отправлено представителю'),
    ('not_obtained_from_supplier', u'не получено от поставщика'),
    ('received_office', u'получено офисом'),
    ('issued', u'выдано'),
)


class OrderedItem(models.Model):
    brandgroup = models.ForeignKey(
        BrandGroup, verbose_name=u"Группа поставщиков")
    area = models.ForeignKey(Area, verbose_name=u"Поставщик")
    brand = models.ForeignKey(Brand, verbose_name=u"Бренд")
    ponumber = models.IntegerField(
        verbose_name=u"Номер заказа", blank=True, null=True)
    part_number = models.CharField(
        verbose_name=u"Номер детали", max_length=255, db_index=True)
    part_number_superseded = models.CharField(
        max_length=255, null=True, blank=True,
        verbose_name=u"Новый номер(замена)")
    comment_customer = models.TextField(
        verbose_name=u"Комментарий заказчика", blank=True, null=True)
    comment_supplier = models.TextField(
        verbose_name=u"Комментарий поставщика", blank=True, null=True)

    quantity = models.PositiveIntegerField(
        verbose_name=u'Количество', null=True, blank=True)
    price_invoice = models.FloatField(
        verbose_name=u"Цена из инвойса от поставщика", blank=True, null=True)
    # quantity*price_invoice
    total_w_ship = models.FloatField(
        verbose_name=u"TOTAL", null=True, blank=True)

    client = models.ForeignKey(
        User, verbose_name=u"Клиент", related_name=u"client")
    client_order_id = models.IntegerField(
        verbose_name=u"Номер заказа для клиента", blank=True, null=True)
    manager = models.ForeignKey(
        User, verbose_name=u"Менеджер", related_name=u"manager")
    description_ru = models.TextField(
        verbose_name=u"Описание RUS", blank=True, null=True)
    description_en = models.TextField(
        verbose_name=u"Описание ENG", blank=True, null=True)

    price_manager = models.FloatField(
        verbose_name=u'Цена менеджера', null=True, blank=True)
    weight_manager = models.FloatField(
        verbose_name=u"Вес одной детали менеджера", null=True, blank=True)

    price_base = models.FloatField(
        verbose_name=u'Базовая Цена', null=True, blank=True)
    price_sale = models.FloatField(
        verbose_name=u"Цена продажи", null=True, blank=True)
    price_discount = models.FloatField(
        verbose_name=u"Цена продажи со скидкой", null=True, blank=True)
    weight = models.FloatField(
        verbose_name=u"Вес одной детали", null=True, blank=True)
    #weight*Const
    delivery_coef = models.FloatField(
        verbose_name=u"Цена доставки за кг", blank=True, null=True)
    delivery = models.FloatField(
        verbose_name=u"Доставка", null=True, blank=True)

    # price_discount + delievery OR price_sale + delivery
    cost = models.FloatField(
        verbose_name=u"Окончательная цена за деталь", null=True, blank=True)
    # cost*quantity
    total_cost = models.FloatField(
        verbose_name=u"Окончательная цена за все", null=True, blank=True)

    status = models.CharField(
        max_length=50, choices=ORDER_ITEM_STATUSES,
        default='moderation', verbose_name=u"Статус")
    status_modified = models.DateTimeField(
        verbose_name=u"Дата изменения статуса", editable=False,
        null=True, blank=True)

    previous_status = models.CharField(
        max_length=50, verbose_name=u"Прежний статус", null=True, blank=True)
    created = models.DateTimeField(
        auto_now_add=True, verbose_name=u"Дата создания")
    received_office_at = models.DateTimeField(
        null=True, blank=True, verbose_name=u"Получено офисом")
    issued_at = models.DateTimeField(
        null=True, blank=True, verbose_name=u"Отгружено")
    modified = models.DateTimeField(
        auto_now=True, verbose_name=u"Дата изменения", editable=False)
    invoice_code = models.CharField(
        max_length=255, verbose_name=u'Инвойс',
        null=True, blank=True, db_index=True)
    parent = models.ForeignKey('self', null=True, blank=True)

    big_price_invoice_order_mail_sent = models.BooleanField(
        verbose_name=u'Цена в инвойсе больше цены продажи. Отправлено письмо.',
        default=False)
    editable = models.BooleanField(verbose_name=u"Редактируемая", default=True)

    shipment = models.ForeignKey(
        Shipment, verbose_name=u"Отгрузка", null=True, blank=True)

    objects = OrderedItemManager()

    def __unicode__(self):
        return u"%s-%d" % (self.created, self.id)

    class Meta:
        verbose_name = u"Заказанная позиция"
        verbose_name_plural = u"Заказанные позиции"

    @property
    def do_calc_totals_by_status(self):
        s = {
            'US': ['received_office', 'issued'],
            'MSK': ['receiced_office', 'sent_representative']
        }
        return self.status in s.get(self.brandgroup.direction.title, [])

    def save(self, *args, **kwargs):

        if self.delivery_coef is None:
            multiplier, delivery, delivery_period, price_updated_at, mc = \
                self.area.get_brandgroup_settings(self.brandgroup)
            self.delivery_coef = delivery

        if self.weight is not None and self.delivery_coef:
            self.delivery = self.delivery_coef * self.weight
        if not self.weight:
            self.delivery = None

        if self.quantity and self.price_invoice:
            self.total_w_ship = self.price_invoice * self.quantity

        calc_price = self.price_discount or self.price_sale or 0
        cost = total_cost = None
        cost = (self.delivery or 0) + calc_price
        if cost and self.quantity:
            total_cost = cost * self.quantity

        # US processing
        if str(self.brandgroup.direction.title.lower()) == 'us':
            if self.weight is not None and self.weight != 0 and self.do_calc_totals_by_status:
                # calculate cost and total cost
                self.cost = cost
                self.total_cost = total_cost
            if not self.weight and self.status == 'received_office':
                # weight was removed and status is reseived:
                self.switch_status()
                self.cost = None
                self.total_cost = None
        if str(self.brandgroup.direction.title.lower()) == 'msk':
            if self.do_calc_totals_by_status:
                self.cost = cost
                self.total_cost = total_cost

        if self.status == 'issued' and not self.issued_at:
            self.issued_at = datetime.datetime.now()

        super(OrderedItem, self).save(*args, **kwargs)

    def switch_status(self, new_status=None, save=False):
        if new_status:
            self.previous_status = self.status
            self.status = new_status
        else:
            self.status, self.previous_status = self.previous_status, self.status
        if save:
            self.save()

    def get_status_verbose(self):
        return dict(ORDER_ITEM_STATUSES).get(self.status, self.status)

    def get_po_verbose(self):
        return self.ponumber and u"%s%s" % (
            self.brandgroup.direction.po, self.ponumber,) or ''

    @property
    def status_display(self):
        return self.get_status_display()

    @property
    def status_verbose(self):
        return self.get_status_verbose()

    @property
    def po_verbose(self):
        return self.get_po_verbose()

    @property
    def failed(self):
        return self.status == 'failure'

    @property
    def exist_in_stk(self):
        parts = Part.objects.filter(
            brand=self.brand,
            brandgroup__direction__title='STK',
            partnumber=self.part_number)
        return bool(len(parts))


INVOICE_STATUS_NONE = 0
INVOICE_STATUS_IN_DELIVERY = 1
INVOICE_STATUS_RECEIVED = 2
INVOICE_STATUS_CLOSED = 3
INVOICE_STATUSES = (
    (INVOICE_STATUS_NONE, u'---'),
    (INVOICE_STATUS_IN_DELIVERY, u'в доставке'),
    (INVOICE_STATUS_RECEIVED, u'получено офисом'),
    (INVOICE_STATUS_CLOSED, u'закрыт'),
)


class Invoice(models.Model):
    code = models.CharField(
        verbose_name=u"Код", max_length=255, db_index=True)
    brandgroup = models.ForeignKey(
        BrandGroup, verbose_name=u"Группа поставщиков", null=True, blank=True)
    status = models.IntegerField(
        verbose_name=u"Состояние", choices=INVOICE_STATUSES,
        default=INVOICE_STATUS_IN_DELIVERY)
    received_at = models.DateTimeField(
        verbose_name=u"Дата получения", null=True, blank=True)
    closed_at = models.DateTimeField(
        verbose_name=u"Дата закрытия", null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __unicode__(self):
        return self.code

    class Meta:
        verbose_name = u"Инвойс"
        verbose_name_plural = u"Инвойсы"
        unique_together = ('code',)

    @property
    def orders(self):
        return OrderedItem.objects.filter(invoice_code=self.code)

    def calculate_status(self):
        old_status = self.status
        if old_status not in (INVOICE_STATUS_CLOSED,):
            order_statuses = list(
                self.orders.values_list('status', flat=True)
            )
            if any(map(lambda x: x == 'in_delivery', order_statuses)):
                self.status = INVOICE_STATUS_IN_DELIVERY
            elif any(map(lambda x: x == 'received_office', order_statuses)):
                self.status = INVOICE_STATUS_RECEIVED
            self.save()

            if old_status != self.status:
                BalanceItem.create_or_update_by_invoice(self)


PACKAGE_STATUS_RECEIVED = 2
PACKAGE_STATUS_ISSUED = 3
PACKAGE_STATUSES = (
    (PACKAGE_STATUS_RECEIVED, u'получено офисом'),
    (PACKAGE_STATUS_ISSUED, u'выдано'),
)

ORDER_ITEM_STATUSES = (
    ('order', u'новый заказ'),
    ('moderation', u'на модерации'),
    ('in_processing', u'в работе'),
    ('wrong_number', u'отказ: некорректный номер'),
    ('out_of_stock', u'отказ: отсутствует на складе'),
    ('cancelled_customer', u'отказ: снято заказчиком'),
    ('export_part', u'отказ: экспортная запчасть'),
    ('back_order', u'back order'),
    ('superseded', u'замена номера'),
    ('received_supplier', u'получено поставщиком'),
    ('in_delivery', u'в доставке'),
    ('sent_representative', u'отправлено представителю'),
    ('not_obtained_from_supplier', u'не получено от поставщика'),
    ('received_office', u'получено офисом'),
    ('issued', u'выдано'),
)

MAP_STATUS_ORDER_TO_INVOICE = (
    ('received_office', PACKAGE_STATUS_RECEIVED),
    ('issued', PACKAGE_STATUS_ISSUED),
)


class Package(models.Model):
    description = models.CharField(verbose_name=u"Описание", max_length=255)
    invoice = models.ForeignKey(Invoice)
    weight = models.FloatField(verbose_name=u"Вес")
    quantity = models.PositiveIntegerField(verbose_name=u'Количество')
    manager = models.ForeignKey(
        User, verbose_name=u"Менеджер", related_name=u"manager_package")
    delivery_coef = models.FloatField(
        verbose_name=u"Стоимость доставки за кг", blank=True, null=True)
    delivery = models.FloatField(
        verbose_name=u"Стоимость доставки", null=True, blank=True)
    total_cost = models.FloatField(
        verbose_name=u"Окончательная цена за все", null=True, blank=True)
    client = models.ForeignKey(
        User, verbose_name=u"Клиент", related_name=u"client_package",
        null=True, blank=True)
    received_at = models.DateTimeField(
        verbose_name=u"Дата получения", null=True, blank=True)
    status = models.IntegerField(
        verbose_name=u"Состояние", choices=PACKAGE_STATUSES,
        default=PACKAGE_STATUS_RECEIVED)
    issued_at = models.DateTimeField(
        null=True, blank=True, verbose_name=u"Отгружено")
    editable = models.BooleanField(
        verbose_name=u"Редактируемая", default=True)
    shipment = models.ForeignKey(
        Shipment, verbose_name=u"Отгрузка", null=True, blank=True)

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = u"Упаковка"
        verbose_name_plural = u"Упаковка"

    def save(self, *args, **kwargs):

        if not self.received_at:
            self.received_at = self.invoice.received_at

        if not self.status:
            self.status = PACKAGE_STATUS_RECEIVED

        if not self.delivery_coef:
            self.delivery_coef = self.invoice.brandgroup.get_settings()[1]

        if self.status == PACKAGE_STATUS_ISSUED and not self.issued_at:
            self.issued_at = datetime.datetime.now()

        self.delivery = None
        if self.delivery_coef and self.weight and self.client:
            self.delivery = self.delivery_coef * self.weight

        if self.delivery and self.quantity:
            self.total_cost = self.delivery * self.quantity

        super(Package, self).save(*args, **kwargs)


class Basket(models.Model):
    user = models.ForeignKey(User)
    creator = models.ForeignKey(User, related_name='creator')
    part_number = models.CharField(max_length=255)
    description = models.TextField(null=True, blank=True)
    msrp = models.FloatField(null=True, blank=True)
    user_price = models.FloatField(null=True, blank=True)
    area = models.CharField(max_length=255, null=True, blank=True)
    brandgroup = models.CharField(max_length=255, null=True, blank=True)
    brand_name = models.CharField(max_length=255, default='')

    description_ru = models.TextField(null=True, blank=True, default=None)
    comment1 = models.TextField(null=True, blank=True, default=None)

    quantity = models.IntegerField(default=1)
    created_at = models.DateTimeField(auto_now_add=True)
    order_item_id = models.IntegerField(null=True, blank=True, default=None)
    core_price = models.FloatField(null=True, blank=True, default=0.0)

    def get_price_total(self):
        return (self.user_price + (self.core_price or 0)) * self.quantity

    def get_price(self):
        return self.user_price + (self.core_price or 0)


class Part(models.Model):
    area = models.ForeignKey(Area, verbose_name=Area._meta.verbose_name)
    brandgroup = models.ForeignKey(BrandGroup, null=True, blank=True)
    brand = models.ForeignKey(Brand, null=True, blank=True)
    partnumber = models.CharField(u"номер детали", max_length=255, db_index=True)
    MSRP = models.FloatField(u"цена", null=True, blank=True)
    cost = models.FloatField(u"cost", null=True, blank=True)
    core_price = models.FloatField(
        u"стоимость детали для восстановления", null=True, blank=True)
    substitution = models.CharField(
        u"номер замены", max_length=255, null=True, blank=True, db_index=True)
    description = models.TextField(
        u"описание детали на английском языке", null=True, blank=True)
    description_ru = models.TextField(u"Описание RUS", blank=True, null=True)
    party = models.IntegerField(u"Партия", null=True, blank=True)
    available = models.IntegerField(u"Наличие", null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = u"деталь"
        verbose_name_plural = u"детали"

    @classmethod
    def get_data_parts(cls, partnumber, maker=None):
        data = []
        parts = cls.objects.filter(partnumber=partnumber)
        for part in parts:
            data.append(part.get_data(sub_chain=[]))
        if maker:
            return filter(
                lambda part: part['maker'].lower() == maker.lower(), data)
        return data

    def get_data(self, sub_chain=[]):
        PARTY_DEFAULT_COUNT = 1
        sub_chain.append(self.partnumber)

        if self.substitution:
            try:
                sub = Part.objects.get(
                    area=self.area,
                    brandgroup=self.brandgroup,
                    partnumber=self.substitution)
            except Part.DoesNotExist:
                pass
            else:
                return sub.get_data(sub_chain)

        area_title = None
        if self.area:
            area_title = self.area.title

        brandgroup_title = "OEM"
        if self.brandgroup:
            brandgroup_title = self.brandgroup.title

        return {
            'partnumber': self.partnumber,
            'MSRP': self.MSRP,
            'core_price': self.core_price,
            'description': self.description,
            'description_ru': self.description_ru,
            'sub_chain': sub_chain,
            'cost': self.cost,
            'brandname': area_title,
            'brandgroup': brandgroup_title,
            'party': self.party or PARTY_DEFAULT_COUNT,
            'available': self.available,
            'maker': (self.brand and self.brand.title) or self.area.title,
        }


def all_brands():
    return list(
        Brand.objects.all().order_by('title')
        .values_list('title', flat=True))


def search_local(maker_id, partnumber):
    return Part.get_data_parts(partnumber, maker_id) or None


def normalize_sum(value):
    value = str(value)
    value = value.replace(',', '.')
    parts = value.split(".")
    m, d = parts[0:-1], parts[-1]
    value = "".join(m) + "." + d
    return value


def calc_part(part, user, render_for_template=True):
    if not part.get('MSRP'):
        return None

    res = part.copy()

    # try to find area and get multiplier
    try:
        # find an area by title
        area = Area.objects.get(title__iexact=part['brandname'])
        brand_group = BrandGroup.objects.get(title=part['brandgroup'])
        # we need to find a valid multiplier for this area
        # TODO - hardcoded 'OEM', we need do more sofisticated algo
    except (BrandGroup.DoesNotExist, Area.DoesNotExist, Area.MultipleObjectsReturned, ValueError):
        # not price_setings for OEM and this area
        m, d, dp, pu, cm, brand_group, area = (
            AREA_MULTIPLIER_DEFAULT, None, None, None, COST_MARGIN_DEFAULT, None, None)
    else:
        m, d, dp, pu, cm = area.get_brandgroup_settings(brand_group)

    res['delivery_coef'] = d
    res['delivery_period'] = dp
    res['updated_at'] = pu
    res['area_id'] = area and area.id or None
    res['direction_id'] = brand_group and brand_group.direction.id or None
    res['brandgroup_id'] = brand_group and brand_group.id or None

    try:
        discount = user.get_profile().get_discount(
            brand_group=brand_group, area=area)
    except Exception:
        discount = AREA_DISCOUNT_DEFAULT
    discount = float(discount)

    # we need to remove all "," as separators
    # only last dot should be saved
    value = float(normalize_sum(str(part['MSRP'])))

    res['MSRP'] = value * float(m)
    if 'cost' in part and part['cost']:
        _msrp = part['cost'] * cm
        if _msrp > part['MSRP']:
            res['MSRP'] = _msrp

    try:
        res['core_price'] = float(normalize_sum(str(part['core_price'])))
    except:
        res['core_price'] = 0.00

    res['your_price'] = res['MSRP'] * (100 - discount) / 100
    res['your_economy'] = res['MSRP'] - res['your_price']
    res['your_economy_perc'] = 100 - res['your_price'] / res['MSRP'] * 100

    if render_for_template:
        res['core_price'] = "%.2f" % res['core_price']
        res['your_economy_perc'] = "%.2f" % res['your_economy_perc']
        res['MSRP'] = "%.2f" % res['MSRP']
        res['your_price'] = "%.2f" % res['your_price']
        res['your_economy'] = "%.2f" % res['your_economy']

        if len(part.get('sub_chain') or []) > 1:
            last = part['sub_chain'][-1]
            res['sub_chain'] = mark_safe(
                u"Номер заменён: "
                + " -> ".join(part['sub_chain'])
                + " -> <b>%s</b>" % last)
        else:
            res.pop('sub_chain', None)

    return res


def calc_parts(parts, user, client=None, render_for_template=True):
    data = []
    for part in parts:
        if not part.get('MSRP'):
            continue
        _part = calc_part(part, user, render_for_template)
        if client:
            _part.update(dict(
                ('client_%s' % k, v)
                for k, v in calc_part(part, client, render_for_template).items()))
            _part['client'] = client
        data.append(_part)
    return data


BALANCEITEM_TYPE_PAYMENT = 1
BALANCEITEM_TYPE_INVOICE = 2
BALANCEITEM_TYPE_PREINVOICE = 3
BALANCEITEM_TYPE_SHIPMENT = 4

BALANCEITEM_TYPE_CHOICES = (
    (BALANCEITEM_TYPE_PAYMENT, u"Оплата"),
    (BALANCEITEM_TYPE_INVOICE, u"Счёт"),
    (BALANCEITEM_TYPE_PREINVOICE, u"Предварительный счёт"),
    (BALANCEITEM_TYPE_SHIPMENT, u"Отгрузка"),
)


class BalanceItem(models.Model):
    user = models.ForeignKey(User)
    amount = models.FloatField(u"Сумма", null=True)
    item_type = models.PositiveSmallIntegerField(
        u"Тип", choices=BALANCEITEM_TYPE_CHOICES,
        default=BALANCEITEM_TYPE_PAYMENT)
    comment = models.TextField(u"Комментарий", null=True, blank=True)
    shipment = models.ForeignKey(
        Shipment, null=True, blank=True, verbose_name=u"Отгрузка")
    invoice = models.ForeignKey(
        Invoice, null=True, blank=True,  verbose_name=u"Инвойс")
    created_at = models.DateTimeField(u"Создано", auto_now_add=True)
    created_at.editable = True
    modified_at = models.DateTimeField(u"Создано", auto_now=True)

    class Meta:
        verbose_name = u"баланс"
        verbose_name_plural = u"баланс"

    def __unicode__(self):
        return "%s %s" % (self.user.username, self.amount,)

    @classmethod
    def create_or_update_by_invoice(cls, invoice):
        invoice_status = invoice.status
        for client, orders in itertools.groupby(
                invoice.orders.order_by('client'), lambda x: x.client):
            if invoice_status == INVOICE_STATUS_IN_DELIVERY:
                item_type = BALANCEITEM_TYPE_PREINVOICE
                amount = -sum(x.price_sale * x.quantity for x in orders)
            else:
                item_type = BALANCEITEM_TYPE_INVOICE
                amount = -sum(x.total_cost for x in orders) - sum(
                    x.total_cost for x in Package.objects.filter(invoice=invoice, client=client))
            b, _ = BalanceItem.objects.get_or_create(user=client, invoice=invoice)
            b.item_type = item_type
            b.amount = amount
            b.comment = u"Инвойс %s" % invoice.code
            b.item_type = item_type
            b.save()

    @classmethod
    def get_or_create_by_order(cls, order):
        i = Invoice.objects.get(code=order.invoice_code)
        b, created = BalanceItem.objects.get_or_create(user=order.client, invoice=i)
        if created:
            b.amount = 0.0
            b.comment = u"Инвойс %s" % i.code
            if i.status == INVOICE_STATUS_IN_DELIVERY:
                item_type = BALANCEITEM_TYPE_PREINVOICE
            else:
                item_type = BALANCEITEM_TYPE_INVOICE
            b.item_type = item_type
            b.save()
        return b

    @classmethod
    def create_by_shipment(cls, shipment, orders=[], packages=[]):
        if not orders:
            orders = OrderedItem.objects.filter(shipment=shipment)
        if not packages:
            packages = Package.objects.filter(shipment=shipment)

        BalanceItem(
            amount=-shipment.cost,
            user=shipment.client,
            item_type=BALANCEITEM_TYPE_SHIPMENT,
            comment=u"Отгрузка %s" % shipment.full_code(),
            shipment=shipment
        ).save()

        for o in orders:
            try:
                b = BalanceItem.objects.get(
                    user=o.client, invoice__code=o.invoice_code)
            except BalanceItem.DoesNotExist:
                continue
            else:
                b.amount -= -o.total_cost
                if b.amount == 0:
                    b.delete()
                else:
                    b.save()

        for p in packages:
            try:
                b = BalanceItem.objects.get(
                    user=p.client, invoice__code=p.invoice.code)
            except BalanceItem.DoesNotExist:
                continue
            else:
                b.amount -= -p.total_cost
                if b.amount == 0:
                    b.delete()
                else:
                    b.save()

    @classmethod
    def backup_balanceitems_post_shipment_delete(cls, shipment, orders, packages):
        for o in orders:
            b = BalanceItem.get_or_create_by_order(o)
            b.amount += -o.total_cost
            b.save()

        for p in packages:
            b = BalanceItem.get_or_create_by_order(o)
            b.amount += -p.total_cost
            b.save()

        try:
            BalanceItem.objects.get(shipment=shipment).delete()
        except BalanceItem.DoesNotExist:
            pass
        return True


class PartAnalog(models.Model):
    brand = models.ForeignKey(Brand)
    partnumber = models.CharField(max_length=255, db_index=True)
    brand_analog = models.ForeignKey(Brand, related_name='brand_analog')
    partnumber_analog = models.CharField(max_length=255, db_index=True)
    comment1 = models.TextField(null=True, blank=True)
    comment2 = models.TextField(null=True, blank=True)

    class Meta:
        verbose_name = u"аналог"
        verbose_name_plural = u"аналоги"


def search_analogs(parts):
    analogs = list(PartAnalog.objects.filter(
        partnumber__in=set(x['partnumber'] for x in parts)))

    data = []
    for a in analogs:
        founds = Part.get_data_parts(a.partnumber_analog, a.brand_analog.title)
        if founds:
            data.extend(founds)
    return data


class Client(User):
    class Meta:
        proxy = True
        app_label = 'auth'
        verbose_name = u"аккаунт клиента"
        verbose_name_plural = u"аккаунты клиентов"


class Manager(User):
    class Meta:
        proxy = True
        app_label = 'auth'
        verbose_name = u"аккаунт менеджера"
        verbose_name_plural = u"аккаунты менеджеров"


class Staff(User):
    class Meta:
        proxy = True
        app_label = 'auth'
        verbose_name = u"аккаунт администратора"
        verbose_name_plural = u"аккаунты администраторов"


class UserGroupObjects(models.Manager):
    def get_default(self):
        try:
            return self.filter(is_default=True)[0]
        except IndexError:
            return self.all()[0]


class UserGroup(models.Model):
    title = models.CharField(u'название', max_length=255)
    order_item_fields = models.TextField(blank=True, null=True)
    is_default = models.BooleanField(
        u'назначать новому пользователю по-умолчанию',
        default=False, editable=False)

    objects = UserGroupObjects()

    class Meta:
        abstract = True

    def __unicode__(self):
        return self.title


class ClientGroup(UserGroup):
    class Meta:
        verbose_name = u"Группа клиентов"
        verbose_name_plural = u"Группы клиентов"


class ManagerGroup(UserGroup):
    class Meta:
        verbose_name = u"Группа менеджеров"
        verbose_name_plural = u"Группы менеджеров"


class BrandGroupDiscount(models.Model):
    user = models.ForeignKey(User, verbose_name=u"пользователь")
    brand_group = models.ForeignKey(
        BrandGroup, verbose_name=u"группа поставщиков")
    discount = models.FloatField(verbose_name=u"скидка (%)")

    class Meta:
        verbose_name = u"Скидка для группы поставщиков" 
        verbose_name_plural = u"Скидки для групп поставщиков"
        unique_together = ('user', 'brand_group',)


class Discount(models.Model):
    user = models.ForeignKey(User, verbose_name=u"пользователь")
    brand_group = models.ForeignKey(
        BrandGroup, verbose_name=u"группа поставщиков", null=True)
    area = models.ForeignKey(Area, verbose_name=u"поставщик")
    discount = models.FloatField(verbose_name=u"скидка (%)")

    class Meta:
        verbose_name = u"Скидка для поставщика"
        verbose_name_plural = u"Скидки для поставщиков"
        unique_together = ('user', 'brand_group', 'area',)

    def __unicode__(self):
        return u"%s:%s: %s" % (
            self.user.username, self.area.title, self.discount)


class BrandGroupClientGroupDiscount(models.Model):
    client_group = models.ForeignKey(
        ClientGroup, verbose_name=u"Группа клиента")
    brand_group = models.ForeignKey(
        BrandGroup, null=True, blank=True, verbose_name=u"группа поставщиков")
    discount = models.FloatField(verbose_name=u"Скидка (%)")

    class Meta:
        verbose_name = u"Скидка группы клиентов для групп поставщиков"
        verbose_name_plural = u"Скидки групп клиентов для групп поставщиков"
        unique_together = ('client_group', 'brand_group')


class ClientGroupDiscount(models.Model):
    client_group = models.ForeignKey(
        ClientGroup, verbose_name=u"Группа клиента")
    brand_group = models.ForeignKey(
        BrandGroup, null=True, blank=True, verbose_name=u"группа поставщиков")
    area = models.ForeignKey(Area, verbose_name=u"Поставщик")
    discount = models.FloatField(verbose_name=u"Скидка (%)")

    class Meta:
        verbose_name = u"Скидка группы клиентов для поставщиков"
        verbose_name_plural = u"Скидки групп клиентов для поставщиков"
        unique_together = ('client_group', 'area', 'brand_group')


def on_client_group_create(sender, instance, created, **kwargs):
    if not created:
        return

    def discounts():
        for brand_group in BrandGroup.objects.all():
            BrandGroupClientGroupDiscount.objects.create(
                brand_group=brand_group,
                client_group=instance,
                discount=AREA_DISCOUNT_DEFAULT)

            for area in brand_group.area.all():
                ClientGroupDiscount.objects.create(
                    area=area,
                    brand_group=brand_group,
                    client_group=instance,
                    discount=AREA_DISCOUNT_DEFAULT)

    from data.forms import CLIENT_FIELD_LIST
    fields = [x[2] for x in CLIENT_FIELD_LIST]
    instance.order_item_fields = ','.join(fields)
    instance.save()

models.signals.post_save.connect(on_client_group_create, sender=ClientGroup)


class ManagerGroupDiscount(models.Model):
    manager_group = models.ForeignKey(
        ManagerGroup, verbose_name=u"Группа менеджера")
    brand_group = models.ForeignKey(
        BrandGroup, null=True, blank=True, verbose_name=u"Группа поставщиков")
    area = models.ForeignKey(Area, verbose_name=u"Поставщик")
    discount = models.FloatField(verbose_name=u"Скидка (%)")

    class Meta:
        verbose_name = u"Скидка группы менеджера для поставщика"
        verbose_name_plural = u"Скидки групп менеджеров для поставщиков"
        unique_together = ('manager_group', 'area', 'brand_group',)


class BrandGroupManagerGroupDiscount(models.Model):
    manager_group = models.ForeignKey(
        ManagerGroup, verbose_name=u"Группа менеджера")
    brand_group = models.ForeignKey(
        BrandGroup, null=True, blank=True, verbose_name=u"группа поставщиков")
    discount = models.FloatField(verbose_name=u"Скидка (%)")

    class Meta:
        verbose_name = u"Скидка группы менеджера для группы поставщиков"
        verbose_name_plural = u"Скидки групп менеджеров для групп поставщиков"
        unique_together = ('manager_group', 'brand_group',)


def on_manager_group_create(sender, instance, created, **kwargs):
    if not created:
        return

    def discounts():
        for brand_group in BrandGroup.objects.all():
            BrandGroupManagerGroupDiscount.objects.create(
                brand_group=brand_group,
                manager_group=instance,
                discount=AREA_DISCOUNT_DEFAULT)

            for area in brand_group.area.all():
                ManagerGroupDiscount.objects.create(
                    area=area,
                    brand_group=brand_group,
                    manager_group=instance,
                    discount=AREA_DISCOUNT_DEFAULT)

    from data.forms import MANAGER_FIELD_LIST
    fields = [x[2] for x in MANAGER_FIELD_LIST]
    instance.order_item_fields = ','.join(fields)
    instance.save()

models.signals.post_save.connect(on_manager_group_create, sender=ManagerGroup)


class UserProfile(models.Model):

    user = models.ForeignKey(User, unique=True)
    order_item_fields = models.TextField(blank=True, default="")

    is_client = models.BooleanField(blank=True, default=False)
    client_group = models.ForeignKey(
        ClientGroup, verbose_name=u"группа клиента", blank=True, null=True)
    client_manager = models.ForeignKey(
        User, verbose_name='менеджер клиента',
        related_name='client_manager', null=True, blank=True)

    is_manager = models.BooleanField(
        verbose_name=u"статус менеджера", blank=True, default=False)
    manager_group = models.ForeignKey(
        ManagerGroup, verbose_name=u"группа менеджера", blank=True, null=True)

    def get_discount(self, brand_group=None, area=None):
        if self.is_manager:
            return self.get_manager_discount(brand_group, area)
        return self.get_client_discount(brand_group, area)

    def get_manager_discount(self, brand_group=None, area=None):
        user_discount = None
        group_discount = None
        brand_group_user_discount = None
        brand_group_discount = None

        if brand_group and area:
            try:
                user_discount = Discount.objects.get(
                    user=self.user,
                    brand_group=brand_group,
                    area=area).discount
            except (Discount.DoesNotExist, AttributeError):
                pass

            try:
                group_discount = ManagerGroupDiscount.objects.get(
                    manager_group=self.manager_group,
                    brand_group=brand_group,
                    area=area).discount
            except ManagerGroupDiscount.DoesNotExist, AttributeError:
                pass

            try:
                brand_group_user_discount = BrandGroupDiscount.objects.get(
                    user=self.user,
                    brand_group=brand_group).discount
            except (BrandGroupDiscount.DoesNotExist, AttributeError):
                pass

            try:
                brand_group_discount = BrandGroupManagerGroupDiscount.objects.get(
                    manager_group=self.manager_group,
                    brand_group=brand_group).discount
            except (BrandGroupManagerGroupDiscount.DoesNotExist, AttributeError):
                pass

        return [
            x for x in [
                user_discount, group_discount, brand_group_user_discount,
                brand_group_discount, AREA_DISCOUNT_DEFAULT]
            if x is not None][0]

    def get_client_discount(self, brand_group=None, area=None):
        user_discount = None
        group_discount = None
        brand_group_user_discount = None
        brand_group_discount = None

        if brand_group and area:

            try:
                user_discount = Discount.objects.get(
                    user=self.user,
                    brand_group=brand_group,
                    area=area).discount
            except (Discount.DoesNotExist, AttributeError):
                pass

            try:
                group_discount = ClientGroupDiscount.objects.get(
                    client_group=self.client_group,
                    brand_group=brand_group,
                    area=area).discount
            except (ClientGroupDiscount.DoesNotExist, AttributeError):
                pass

            try:
                brand_group_user_discount = BrandGroupDiscount.objects.get(
                    user=self.user,
                    brand_group=brand_group).discount
            except (BrandGroupDiscount.DoesNotExist, AttributeError):
                pass

            try:
                brand_group_discount = BrandGroupClientGroupDiscount.objects.get(
                    client_group=self.client_group,
                    brand_group=brand_group).discount
            except (BrandGroupClientGroupDiscount.DoesNotExist, AttributeError):
                pass

        return [
            x for x in [
                user_discount, group_discount, brand_group_user_discount,
                brand_group_discount, AREA_DISCOUNT_DEFAULT]
            if x is not None][0]

    def get_order_fields(self):
        try:
            fields = self.client_group.order_item_fields.split(",")
        except Exception:
            fields = []
        if not self.order_item_fields:
            return fields
        else:
            fields = self.order_item_fields.split(",")
        if not fields:
            from data.forms import CLIENT_FIELD_LIST
            return [x[2] for x in CLIENT_FIELD_LIST]
        return fields

    class Meta:
        verbose_name = u"профиль пользователя"
        verbose_name_plural = u"Профили пользователей"
