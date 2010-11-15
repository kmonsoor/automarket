# -*- coding=utf-8 -*-

from django.db.models import Manager
from lib.lists import sort_by_attr

class OrderedItemManager(Manager):
    
    def get_next_ponumber(self, supplier_id):
        from django.db import connection
        cursor = connection.cursor()
        table = self.model._meta.db_table
        try:
            cursor.execute("""SELECT MAX(ponumber) FROM %s WHERE supplier_id = %d""" % (table, int(supplier_id)))
            ponumber = int(cursor.fetchone()[0])or 1
        except :
            return 1
        else:
            return ponumber + 1
    

class ActiveBrandManager(Manager):
    def get_query_set(self):
        return super(ActiveBrandManager, self).get_query_set().filter(active=True)
                     