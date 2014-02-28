# -*- coding=utf-8 -*-
from django.db import models


class Bot1(models.Model):
    area = models.CharField(max_length=255, verbose_name=u"Производитель", db_index=True)
    partnumber = models.CharField(max_length=255, verbose_name=u"Код", db_index=True)
    substitution = models.CharField(verbose_name=u"Замена", max_length=255, null=True, blank=True)
    description = models.CharField(max_length=255, verbose_name=u"Описание", null=True, blank=True)
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