# -*- coding=utf-8 -*-
from django.db import models


class Bot1(models.Model):
    area = models.CharField(max_length=255, verbose_name=u"Производитель", db_index=True)
    partnumber = models.CharField(max_length=255, verbose_name=u"Код", db_index=True)
    substitution = models.CharField(verbose_name=u"Замена", max_length=255, null=True, blank=True)
    description = models.TextField(max_length=255, verbose_name=u"Описание", null=True, blank=True)
    delivery_period = models.CharField(max_length=255, verbose_name=u"Дней", null=True, blank=True)
    price = models.FloatField(verbose_name=u"Цена", null=True, blank=True)
    core = models.FloatField(verbose_name=u"Core", null=True, blank=True)
    price_cost = models.FloatField(verbose_name=u"PriceCost (была скрытая колонка)", null=True, blank=True)
    price_plus_core = models.FloatField(verbose_name=u"Сумма", null=True, blank=True)
    currency = models.CharField(verbose_name=u"Валюта", max_length=10, null=True, blank=True)

    class Meta:
        verbose_name = u'1'
        verbose_name_plural = u'1'

    def __unicode__(self):
        return u"%s: %s" % (self.area, self.partnumber)


class Bot2(models.Model):
    year = models.IntegerField(verbose_name=u"Year", null=True, blank=True)
    maker = models.CharField(max_length=255, verbose_name=u"Maker")
    model = models.CharField(max_length=255, verbose_name=u"Model")
    refoenumber = models.CharField(max_length=255, verbose_name=u"Ref OE #", db_index=True)
    itemnumber = models.CharField(max_length=255, verbose_name=u"Item #", db_index=True)
    description = models.TextField(max_length=255, verbose_name=u"Description", null=True, blank=True)
    quality = models.CharField(max_length=255, verbose_name=u"Quality", null=True, blank=True)
    listprice = models.FloatField(verbose_name=u"List $", null=True, blank=True)
    yourprice = models.FloatField(verbose_name=u"Your $", null=True, blank=True)
    images = models.TextField(verbose_name=u"Images", null=True, blank=True)
    note = models.TextField(verbose_name=u"Note", null=True, blank=True)
    assembly = models.TextField(verbose_name=u"Assembly", null=True, blank=True)

    class Meta:
        verbose_name = u'2'
        verbose_name_plural = u'2'

    def __unicode__(self):
        return u"%s %s: %s" % (self.maker, self.model, self.refoenumber)