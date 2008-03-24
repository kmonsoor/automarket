# -*- coding=UTF-8 -*-

from django.db import models
from django.contrib.auth.models import User

import datetime, time

# car maker
class Vendor(models.Model):
    name = models.CharField(maxlength=255)
    
    def __str__(self):
        return self.name
    
    class Admin:
        pass

# car model name
class CarModel(models.Model):
    vendor = models.ForeignKey(to=Vendor)
    name = models.CharField(maxlength=255)

    def __str__(self):
        return "%s (%s)" % (self.name, self.vendor)
    
    class Admin:
        list_filter = ('vendor',)
        list_display = ('name','vendor')

# part maker
class Brand(models.Model):
    name = models.CharField(maxlength=255)
    
    class Admin:
        pass


class Order(models.Model):
    # user and order data
    user = models.ForeignKey(to=User)
    po = models.CharField(maxlength=255)
    created = models.DateTimeField()
    modified = models.DateTimeField(auto_now=True, editable=False)

    class Admin:
        pass

CAR_SIDES = (('R','right'),('L','left'))

ORDER_ITEM_STATUSES = (('on_order','On order'),
                       ('out_of_stock','Out of stock'),
                       ('back_order','Back order'),
                       ('wrong_number', 'Wrong number'),
                       ('not_produce','Not produce'),
)
    
class OrderedItem(models.Model):
    order = models.ForeignKey(to=Order, edit_inline=models.TABULAR, core=True)
    # car details
    car_model = models.ForeignKey(to=CarModel)
    year = models.IntegerField(maxlength=4)
    engine_volume = models.FloatField(max_digits=2, decimal_places=1)
    side = models.CharField(maxlength=1, choices=CAR_SIDES, blank=True, null=True)
    # item details
    part_number = models.CharField(maxlength=255)
    part_number_superseded = models.CharField(maxlength=255, null=True, blank=True)
    price = models.FloatField(max_digits=15, decimal_places=2,  null=True, blank=True)
    quantity = models.IntegerField()
    
    status = models.CharField(maxlength=50, choices=ORDER_ITEM_STATUSES, default='on_order')
    description = models.TextField()
    
    class Admin:
        pass


def generatePo(user_obj):
    return "%s-%d" % (user_obj.id, int(time.time()))     