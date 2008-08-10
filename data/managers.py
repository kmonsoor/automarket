# -*- coding=utf-8 -*-
from django.db.models import Manager
from lib.lists import sort_by_attr
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
        from data.models import InvoiceItem
        # Get sum for items
        qsi = self.filter(po__user=user).filter(created__gte=start).filter(created__lte=finish)
        # Get sum for additionals
        qsa = self.filter(po__user=user).filter(modified__gte=start).filter(modified__lte=finish)
        def add_data(x,comment,date_field):
            setattr(x,'sum',InvoiceItem.objects.summarize_by_invoice(x))
            setattr(x,'comment', comment + u' %s' % x.id)
            setattr(x,'date',x.__dict__[date_field])
            return x
        data1 = [add_data(x,u'Выставлен инвойс','created') for x in list(qsi)]
        data2 = [add_data(x,u'Стоимость доставки к инвойсу','modified') for x in list(qsa)]
        data3 = sort_by_attr(data1+data2,'date')

        return data3 

        

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
    
    def get_for_period(self, user, start, finish):
        qs = self.filter(user=user).filter(created__gte=start).filter(created__lte=finish).order_by('-created')
        def add_data(x):
            setattr(x, 'date', xrange.created)
            setattr(x, 'sum', x.payment_sum)
            setattr(x,'comment',x.payment_for)
            return x
        return [add_data(x) for x in qs] 
        
class BillManager(Manager):
    def get_for_period(self, user, start, finish):
        #start, finish = map(lambda x: str(x)+' 00:00:00',(start, finish))
        qs = self.filter(user=user).filter(modified__gte=start, modified__lte=finish)
        from django.db import connection
        def add_data(x):
            setattr(x, 'date', x.modified)
            setattr(x, 'sum', x.payment_sum)
            setattr(x,'comment',x.payment_for)
            return x
        return [add_data(x) for x in qs]
    
                 