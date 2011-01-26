# -*- coding=utf-8 -*-

from django.db import models

class OrderedItemManager(models.Manager):
    
    def get_next_ponumber(self, direction_id):
        try:
            ponumber = self.filter(brandgroup__direction = direction_id).aggregate(models.Max('ponumber'))['ponumber__max']
            return ponumber + 1
        except:
            return 1
        
        
    def get_next_client_order_id(self, client):
        try:
            client_order_id = self.filter(client = client).aggregate(models.Max('client_order_id'))['client_order_id__max']
            return client_order_id + 1
        except:
            return 1
                     