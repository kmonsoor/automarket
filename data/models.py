# -*- coding=utf-8 -*-
import inspect
import datetime
import logging
logger = logging.getLogger('data.models')

from django.db import models
from django.conf import settings
from django.contrib.auth.models import User

from data.managers import OrderedItemManager
from data.settings import AREA_MULTIPLIER_DEFAULT, AREA_DISCOUNT_DEFAULT, \
    DELIVERY_DEFAULT, DELIVERY_PERIOD_DEFAULT


class Direction(models.Model):
    title = models.CharField(max_length=255, verbose_name=u"Название")
    po = models.CharField(max_length=255, verbose_name=u"PO")

    delivery = models.FloatField(verbose_name=u"доставка", blank=True, null=True)
    multiplier = models.DecimalField(
        u'множитель', max_digits=7, decimal_places=3, blank=True, null=True
    )
    delivery_period = models.IntegerField(
        u'Срок доставки (в днях)', blank=True, null=True
    )

    class Meta:
        verbose_name = u'Направление'
        verbose_name_plural = u'Направления'

    def __unicode__(self):
        return u"%s" % self.title


class BrandGroup(models.Model):
    direction = models.ForeignKey(Direction, verbose_name=u"Направление")
    title = models.CharField(verbose_name=u"Название", max_length=10)
    description = models.TextField(verbose_name=u"Описание", null=True, blank=True)

    delivery = models.FloatField(verbose_name=u"доставка", blank=True, null=True)
    multiplier = models.DecimalField(u'множитель', max_digits=7, decimal_places=3, \
                                     blank=True, null=True)
    delivery_period = models.IntegerField(u'Срок доставки (в днях)',
        blank=True, null=True)

    area = models.ManyToManyField('Area', verbose_name=u"Поставщики", null=True, blank=True)
    add_brand_to_comment = models.BooleanField(verbose_name=u"В поле 'Comment2' добавляется значение поля 'Brand'",
        default=False)

    class Meta:
        verbose_name = u'Группа поставщиков'
        verbose_name_plural = u'Группы поставщиков'

    def __unicode__(self):
        return u"%s::%s" % (self.direction, self.title)

    def price_settings(self):
        class ps(dict):
            __slots__ = ['area', 'multiplier', 'delivery']

        current_settings = dict(tuple([(x.area.id, x) for x in \
            BrandGroupAreaSettings.objects.select_related().filter(brand_group=self)]))
        for area in self.area.all():
            if area.id in current_settings:
                multiplier, delivery = (getattr(current_settings.get(area.id), x) \
                for x in ['multiplier', 'delivery'])
            else:
                multiplier = delivery = None
            yield ps(area=area, multiplier=multiplier, delivery=delivery)

    def get_settings(self):
        m = [self.multiplier, self.direction.multiplier, AREA_MULTIPLIER_DEFAULT]
        d = [self.delivery, self.direction.delivery, DELIVERY_DEFAULT]
        dp = [self.delivery_period, self.direction.delivery_period, DELIVERY_PERIOD_DEFAULT]
        first = lambda xs: [x for x in xs if x is not None][0]
        return first(m), first(d), first(dp), None


class Area(models.Model):
    title = models.CharField(max_length=255, verbose_name=u"Название")
    brands = models.ManyToManyField('Brand', null=True, blank=True, verbose_name=u'Бренды')

    class Meta:
        verbose_name = u"Поставщик"
        verbose_name_plural = u"Поставщики"
        ordering = ['title']

    def __unicode__(self):
        return u"%s" % self.title

    def get_brandgroup_settings(self, brand_group):
        try:
            s = BrandGroupAreaSettings.objects.get(area=self, brand_group=brand_group)
        except BrandGroupAreaSettings.DoesNotExist:
            return brand_group.get_settings()
        else:
            m = [s.multiplier, brand_group.multiplier,
                  brand_group.direction.multiplier,
                  AREA_MULTIPLIER_DEFAULT]
            d = [s.delivery, brand_group.delivery,
                  brand_group.direction.delivery,
                  DELIVERY_DEFAULT]

            dp = [s.delivery_period, brand_group.delivery_period,
                  brand_group.direction.delivery_period,
                  DELIVERY_PERIOD_DEFAULT]

            pu = s.price_updated_at

            first = lambda xs: [x for x in xs if x is not None][0]
            return first(m), first(d), first(dp), pu


class BrandGroupAreaSettings(models.Model):

    brand_group = models.ForeignKey(BrandGroup, verbose_name=BrandGroup._meta.verbose_name)
    area = models.ForeignKey(Area, verbose_name=Area._meta.verbose_name)

    delivery = models.FloatField(verbose_name=u"Стоимость доставки (за кг)", blank=True, null=True)
    multiplier = models.DecimalField(u'множитель', max_digits=7, decimal_places=3, \
        blank=True, null=True)
    delivery_period = models.IntegerField(u'Срок доставки (в днях)',
        blank=True, null=True)

    price = models.FileField(u"Файл с ценами",
        upload_to=settings.PRICE_UPLOAD_DIR, null=True, blank=True)
    price_updated_at = models.DateTimeField(u"Дата обновления цен",
        null=True, blank=True)

    def __unicode__(self):
        return u"%s - %s" % (self.brand_group, self.area)

    class Meta:
        unique_together = ('area', 'brand_group')
        verbose_name = u"запись настроек"
        verbose_name_plural = u"Настройки для поставщиков"

# M2M brand_group - area
'''
def brangroup_area_changed(sender, instance, action, reverse, model, pk_set, **kwargs):
    # Delete removed
    if pk_set:
    BrandGroupAreaSettings.objects.filter(brand_group=instance) \
                              .exclude(area__id__in=list(pk_set)) \
                              .delete()
    # Will be created for new ones
    for area_id in pk_set:
        obj, created = \
        BrandGroupSettings.objects.get_or_create(brand_group=instance, \
                                                 area=model.objects.get(pk=area_id))

models.signals.m2m_changed.connect(brangroup_area_changed, sender=BrandGroup.area.through,
dispatch_uid="38fy3f73")
'''


class Brand(models.Model):
    title = models.CharField(max_length=255, verbose_name=u"Название")

    class Meta:
        verbose_name = u"Бренд"
        verbose_name_plural = u"Бренды"
        ordering = ['title']

    def __unicode__(self):
        return u"%s" % self.title


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
    brandgroup = models.ForeignKey(BrandGroup, verbose_name=u"Группа поставщиков")
    area = models.ForeignKey(Area, verbose_name=u"Поставщик")
    brand = models.ForeignKey(Brand, verbose_name=u"Бренд")
    ponumber = models.IntegerField(verbose_name=u"Номер заказа", blank=True, null=True)
    part_number = models.CharField(verbose_name=u"Номер детали", max_length=255, db_index=True)
    part_number_superseded = models.CharField(max_length=255, null=True, blank=True, verbose_name=u"Новый номер(замена)")
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
    delivery_coef = models.FloatField(verbose_name=u"Цена доставки за кг", blank=True, null=True)
    delivery = models.FloatField(verbose_name=u"Доставка", null=True, blank=True)

    # price_discount + delievery OR price_sale + delivery
    cost = models.FloatField(verbose_name=u"Окончательная цена за деталь", null=True, blank=True)
    # cost*quantity
    total_cost = models.FloatField(verbose_name=u"Окончательная цена за все", null=True, blank=True)

    status = models.CharField(max_length=50, choices=ORDER_ITEM_STATUSES, default='order', verbose_name=u"Статус")
    status_modified = models.DateTimeField(verbose_name=u"Дата изменения статуса", editable=False, null=True, blank=True)

    previous_status = models.CharField(max_length=50, verbose_name=u"Прежний статус", null=True, blank=True,)
    created = models.DateTimeField(auto_now_add=True, verbose_name=u"Дата создания")
    received_office_at = models.DateTimeField(null=True, blank=True, verbose_name=u"Получено офисом")
    issued_at = models.DateTimeField(null=True, blank=True, verbose_name=u"Отгружено")
    modified = models.DateTimeField(auto_now=True, verbose_name=u"Дата изменения", editable=False)
    invoice_code = models.CharField(max_length=255, verbose_name=u'Инвойс', null=True, blank=True, db_index=True)
    parent = models.ForeignKey('self', null=True, blank=True)

    big_price_invoice_order_mail_sent = models.BooleanField(verbose_name=u'Цена в инвойсе больше цены продажи. Отправлено письмо.', default=False)

    objects = OrderedItemManager()

    def __unicode__(self):
        return u"%s-%d" % (self.created, self.id)

    class Meta:
        verbose_name = u"Заказанная позиция"
        verbose_name_plural = u"Заказанные позиции"

    @property
    def do_calc_totals_by_status(self):
        _statuses = {
            'US': ['received_office', 'issued'],
            'MSK': ['receiced_office', 'sent_representative']
        }
        return self.status in _statuses.get(self.brandgroup.direction.title, [])

    def save(self, *args, **kwargs):

        logger.debug("OrderedItem save: called from %r" % \
                     inspect.getframeinfo(inspect.currentframe().f_back)[2])

        if self.delivery_coef is None:
            multiplier, delivery, delivery_period, price_updated_at = \
                self.area.get_brandgroup_settings(self.brandgroup)
            self.delivery_coef = delivery

        if self.weight is not None and self.delivery_coef:
            self.delivery = self.delivery_coef * self.weight
        if not self.weight:
            self.delivery = None

        logger.debug("OrderedItem save: delivery is: %r" % self.delivery)
        if self.quantity and self.price_invoice:
            logger.debug("OrderedItem save: quantity and price_invoice defined")
            self.total_w_ship = self.price_invoice * self.quantity

        # TODO - making dinamic discount. Now price_discount is set manually
        #if self.price_sale and self.client and self.area and not self.price_discount:
        #    try:
        #        discount = Discount.objects.get(user=self.client, area=self.area)
        #        self.price_discount = self.price_sale - self.price_sale*discount.discount/100
        #    except Discount.DoesNotExist:
        #        pass

        try:
            calc_price = [x for x in [self.price_discount, self.price_sale] if x][0]
        except IndexError:
            calc_price = 0
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
        # clear totals for unappropriate statuses
        #if self.status != 'moderation' and not self.do_calc_totals_by_status:
            #self.cost = None
            #self.total_cost = None

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
        return u"%s%s" % (self.brandgroup.direction.po, self.ponumber,) \
                           if self.ponumber else ''

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
        parts = Part.objects.filter(brand=self.brand,
                                    brandgroup__direction__title='STK',
                                    partnumber=self.part_number)
        if len(parts) > 0:
            return True
        return False


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
    code = models.CharField(verbose_name=u"Код", max_length=255, db_index=True)
    brandgroup = models.ForeignKey(BrandGroup, verbose_name=u"Группа поставщиков", null=True, blank=True)
    status = models.IntegerField(verbose_name=u"Состояние", choices=INVOICE_STATUSES, default=INVOICE_STATUS_IN_DELIVERY)
    received_at = models.DateTimeField(verbose_name=u"Дата получения", null=True, blank=True)
    closed_at = models.DateTimeField(verbose_name=u"Дата закрытия", null=True, blank=True)

    created_at = models.DateTimeField(auto_now_add=True)

    def __unicode__(self):
        return self.code

    class Meta:
        verbose_name = u"Инвойс"
        verbose_name_plural = u"Инвойсы"
        unique_together = ('code',)

    def calculate_status(self):
        if self.status not in (INVOICE_STATUS_CLOSED,):
            order_statuses = list(
                OrderedItem.objects
                .filter(invoice_code=self.code)
                .values_list('status', flat=True)
            )
            if any(map(lambda x: x == 'in_delivery', order_statuses)):
                self.status = INVOICE_STATUS_IN_DELIVERY
            elif any(map(lambda x: x == 'received_office', order_statuses)):
                self.status = INVOICE_STATUS_RECEIVED
            self.save()


PACKAGE_STATUS_RECEIVED = 2
PACKAGE_STATUS_ISSUED = 3
PACKAGE_STATUSES = (
    (PACKAGE_STATUS_RECEIVED, u'получено офисом'),
    (PACKAGE_STATUS_ISSUED, u'выдано'),
)


class Package(models.Model):
    description = models.CharField(verbose_name=u"Описание", max_length=255)
    invoice = models.ForeignKey(Invoice)
    weight = models.FloatField(verbose_name=u"Вес")
    quantity = models.PositiveIntegerField(verbose_name=u'Количество')
    manager = models.ForeignKey(User, verbose_name=u"Менеджер", related_name=u"manager_package")

    delivery_coef = models.FloatField(verbose_name=u"Стоимость доставки за кг", blank=True, null=True)
    delivery = models.FloatField(verbose_name=u"Стоимость доставки", null=True, blank=True)
    total_cost = models.FloatField(verbose_name=u"Окончательная цена за все", null=True, blank=True)
    client = models.ForeignKey(User, verbose_name=u"Клиент", related_name=u"client_package", null=True, blank=True)
    received_at = models.DateTimeField(verbose_name=u"Дата получения", null=True, blank=True)
    status = models.IntegerField(verbose_name=u"Состояние", choices=PACKAGE_STATUSES, default=PACKAGE_STATUS_RECEIVED)
    issued_at = models.DateTimeField(null=True, blank=True, verbose_name=u"Отгружено")

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

# ----------------------------------------------------------


class ClientGroupManager(models.Manager):
    def get_default(self):
        try:
            return self.filter(is_default=True)[0]
        except IndexError:
            return self.all()[0]


class ClientGroup(models.Model):
    title = models.CharField(u'название', max_length=255)
    order_item_fields = models.TextField(blank=True, null=True)
    is_default = models.BooleanField(u'назначать новому пользователю по-умолчанию', default=False, editable=False)

    objects = ClientGroupManager()

    def __unicode__(self):
        return self.title

    class Meta:
        verbose_name = u"запись группы клиентов"
        verbose_name_plural = u"Группы клиентов"

    #def save(self, *args, **kwargs):
    #    if self.default:
    #        for x in ClientGroup.objects.exclude(pk=self.id):
    #            x.default = False
    #            x.save()
    #    super(ClientGroup, self).save(*args, **kwargs)


class BrandGroupDiscount(models.Model):
    user = models.ForeignKey(User, verbose_name=u"пользователь")
    brand_group = models.ForeignKey(BrandGroup, verbose_name=u"группа поставщиков")
    discount = models.FloatField(verbose_name=u"скидка (%)")

    class Meta:
        verbose_name = u"скидки для группы поставщиков"
        verbose_name_plural = u"Скидки пользователя для групп поставщиков"
        unique_together = ('user', 'brand_group',)


class Discount(models.Model):
    user = models.ForeignKey(User, verbose_name=u"пользователь")
    brand_group = models.ForeignKey(BrandGroup, verbose_name=u"группа поставщиков", null=True)
    area = models.ForeignKey(Area, verbose_name=u"поставщик")
    discount = models.FloatField(verbose_name=u"скидка (%)")

    class Meta:
        verbose_name = u"скидки для поставшика"
        verbose_name_plural = u"Скидки пользователяы для поставщиков в группах поставщиков"
        unique_together = ('user', 'brand_group', 'area',)

    def __unicode__(self):
        return u"%s:%s: %s" % (self.user.username, self.area.title, self.discount)


class BrandGroupClientGroupDiscount(models.Model):
    client_group = models.ForeignKey(ClientGroup, verbose_name=u"Группа клиента")
    brand_group = models.ForeignKey(BrandGroup, null=True, blank=True, verbose_name=u"группа поставщиков")
    discount = models.FloatField(verbose_name=u"Скидка (%)")

    class Meta:
        verbose_name = u"Скидка группы клиента"
        verbose_name_plural = u"Скидки группы для групп поставщиков"
        unique_together = ('client_group', 'brand_group')


class ClientGroupDiscount(models.Model):
    client_group = models.ForeignKey(ClientGroup, verbose_name=u"Группа клиента")
    brand_group = models.ForeignKey(BrandGroup, null=True, blank=True, verbose_name=u"группа поставщиков")
    area = models.ForeignKey(Area, verbose_name=u"Поставщик")
    discount = models.FloatField(verbose_name=u"Скидка (%)")

    class Meta:
        verbose_name = u"Скидка группы"
        verbose_name_plural = u"Скидки группы для поставщиков в группах поставщиков"
        unique_together = ('client_group', 'area', 'brand_group')


def on_client_group_create(sender, instance, created, **kwargs):
    if not created:
        return

    def discounts():
        for brand_group in BrandGroup.objects.all():
            BrandGroupClientGroupDiscount.objects.create(brand_group=brand_group,
                       client_group=instance, discount=AREA_DISCOUNT_DEFAULT)
            for area in brand_group.area.all():
                ClientGroupDiscount.objects.create(
                    area=area,
                    brand_group=brand_group,
                    client_group=instance,
                    discount=AREA_DISCOUNT_DEFAULT)

    #discounts()
    from data.forms import CLIENT_FIELD_LIST
    fields = [x[2] for x in CLIENT_FIELD_LIST]
    instance.order_item_fields = ','.join(fields)
    instance.save()

models.signals.post_save.connect(on_client_group_create, sender=ClientGroup)


class UserProfile(models.Model):

    client_group = models.ForeignKey(ClientGroup, verbose_name=u"группа", blank=True, null=True)
    order_item_fields = models.TextField(blank=True, default="")
    user = models.ForeignKey(User, unique=True)

    def get_discount(self, brand_group=None, area=None):
        user_discount = None
        group_discount = None
        brand_group_user_discount = None
        brand_group_discount = None

        # first try to find self discount for selected brand_group and area
        if brand_group and area:
            try:
                user_discount = Discount.objects.get(user=self.user, \
                                                     brand_group=brand_group, \
                                                     area=area).discount
            except (Discount.DoesNotExist, AttributeError):
                pass
            # try to find group discount got selected barand group and area
            try:
                cgd = ClientGroupDiscount.objects.get(client_group=self.client_group, \
                                        brand_group=brand_group, area=area)
                group_discount = cgd.discount
            except (ClientGroupDiscount.DoesNotExist, AttributeError):
                pass

            # try to find self discount only for brand_group
            try:
                brand_group_user_discount = \
                BrandGroupDiscount.objects.get(user=self.user, brand_group=brand_group) \
                                          .discount
            except (BrandGroupDiscount.DoesNotExist, AttributeError):
                pass

            # try to find group discount only for brand_group
            try:
                brand_group_discount = \
                BrandGroupClientGroupDiscount.objects \
                   .get(client_group=self.client_group, brand_group=brand_group) \
                   .discount
            except (BrandGroupClientGroupDiscount.DoesNotExist, AttributeError):
                pass

        # Return first not null value
        return [x for x in \
                [user_discount, group_discount,
                 brand_group_user_discount, brand_group_discount,
                 AREA_DISCOUNT_DEFAULT] if x is not None][0]

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
            return [x[2] for x in CLIENT_FIELD_LIST]
        return fields

    class Meta:
        verbose_name = u"профиль пользователя"
        verbose_name_plural = u"Профили пользователей"


class Basket(models.Model):
    user = models.ForeignKey(User)
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
    core_price = models.FloatField(u"стоимость детали для восстановления",
        null=True, blank=True)
    substitution = models.CharField(u"номер замены", max_length=255,
        null=True, blank=True, db_index=True)
    description = models.TextField(u"описание детали на английском языке",
        null=True, blank=True)
    description_ru = models.TextField(verbose_name=u"Описание RUS",
        blank=True, null=True)
    party = models.IntegerField(u"Партия", null=True, blank=True)
    available = models.IntegerField(u"Наличие", null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = u"деталь"
        verbose_name_plural = u"детали"

    @classmethod
    def get_data_parts(cls, partnumber):
        data = []
        parts = cls.objects.filter(partnumber__iexact=partnumber)
        for part in parts:
            data.append(part.get_data(sub_chain=[]))
        return data

    def get_data(self, sub_chain=[]):
        PARTY_DEFAULT_COUNT = 1
        sub_chain.append(self.partnumber)

        if self.substitution:
            try:
                sub = Part.objects.get(area=self.area, brandgroup=self.brandgroup, partnumber__iexact=self.substitution)
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
            'maker': self.brand or "",
        }
