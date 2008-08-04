# -*- coding=utf-8 -*-
from django.db.models import Manager

class OrderedItemManager(Manager):
    
    def get_by_po(self):
        pass
    
    def get_next_ponumber(self, po_id):
        from django.db import connection
        cursor = connection.cursor()
        table = self.model._meta.db_table
        try:
            cursor.execute("""SELECT MAX(`ponumber`) FROM `%s` WHERE `po_id`='%d'""" % (table,po_id))
            ponumber = cursor.fetchone()[0] or 1
        except :
            ponumber = 1
        else:
            return ponumber + 1

class InvoiceItemManager(Manager):
    def for_user(self, user):
        return self.select_related().filter(invoice__po__in=[x.id for x in user.po_set.all()])
    
    def summarize_by_invoice(self, invoice):
        sql = """SELECT SUM(`price`)  
                 FROM `%s`  
                 WHERE `invoice_id`=%d 
                 GROUP BY `invoice_id`""" % (self.model._meta.db_table,invoice.id)
        from django.db import connection
        cursor = connection.cursor()
        cursor.execute(sql)
        res = cursor.fetchone()
        
        if res is not None:
            return res[0]
        else:
            return float(0)

class InvoiceManager(Manager):
    def total_for(self, user):
        from data.models import InvoiceItem
        qs = self.select_related().filter(po__user=user)
        return reduce(lambda x,y: x+y, [InvoiceItem.objects.summarize_by_invoice(invoice) for invoice in qs],0)
    
    def get_for_period(self, user, start, finish):
        # TODO - проверить запрос!
        qs = self.filter(created__gte=start).filter(modified__lte=finish).filter(po__user=user)
        print list(qs.copy())
        data = map(lambda x: setattr(x,'sum',InvoiceItem.objects.summarize_by_invoice(x)), list(qs))
        print data
        return []

        

class PaymentManager(Manager):
    def total_for(self,user):
        sql = """SELECT SUM(`payment_sum`)  
                 FROM `%s`  
                 WHERE `user_id`=%d 
                 GROUP BY `user_id`""" % (self.model._meta.db_table,user.id)
        from django.db import connection
        cursor = connection.cursor()
        cursor.execute(sql)
        res = cursor.fetchone()
        
        if res is not None:
            return res[0]
        else:
            return float(0)
          