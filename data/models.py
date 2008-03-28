# -*- coding=UTF-8 -*-

from django.db import models
from django.contrib.auth.models import User

import datetime, time

# part maker
class Brand(models.Model):
    name = models.CharField(maxlength=255)
    parent = models.ForeignKey('self',null=True,blank=True)
    
    class Admin:
        list_display = ('name','_parents_repr')
    
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
        if self.parent != None:
            return self.parent
        else:
            return self


class Order(models.Model):
    # user and order data
    user = models.ForeignKey(to=User)
    po = models.CharField(maxlength=255)
    created = models.DateTimeField()
    modified = models.DateTimeField(auto_now=True, editable=False)
    
    confirmed = models.BooleanField(default=False)
    
    class Admin:
        pass
    
    def __str__(self):
        return "%s" % self.po

CAR_SIDES = (('R','right'),('L','left'),)

ORDER_ITEM_STATUSES = (('on_order','On order'),
                       ('out_of_stock','Out of stock'),
                       ('back_order','Back order'),
                       ('wrong_number', 'Wrong number'),
                       ('not_produce','Not produce'),
)
    
class OrderedItem(models.Model):
    order = models.ForeignKey(to=Order, edit_inline=models.TABULAR, core=True)
    # car details
    car_maker = models.CharField(maxlength=255)
    car_model = models.CharField(maxlength=255)
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
    #brand = models.ForeignKey(Brand, null=True, blank=True)
    brand = models.CharField(maxlength=50, null=True, blank=True)
    
    confirmed = models.BooleanField(default=False)
    
    class Admin:
        pass
    
    def __str__(self):
        return "%s-%s" % (self.order.po, self.id)


def generatePo(user_obj):
    return "%s-%d" % (user_obj.id, int(time.time()))     