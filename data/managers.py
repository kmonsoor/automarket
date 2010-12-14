# -*- coding=utf-8 -*-

from django.db.models import Manager
from lib.lists import sort_by_attr

class OrderedItemManager(Manager):
    
    def get_next_ponumber(self, brandgroup_id):
        from django.db import connection
        cursor = connection.cursor()
        table = self.model._meta.db_table
        try:
            cursor.execute("""SELECT MAX(ponumber) FROM %s WHERE brandgroup_id = %d""" % (table, int(brandgroup_id)))
            ponumber = int(cursor.fetchone()[0]) or 1
        except TypeError:
            return 1
        else:
            return ponumber + 1
                     