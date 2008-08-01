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
    
    def get_item_sum(self, invoice):
        sql = """SELECT SUM(`price`)  
                 FROM %s 
                 WHERE `invoice_id`=%d 
                 GROUP BY `invoice_id`""" % (self.meta.__table,invoice.id)
        from django.db import connection
        cursor = connection.cursor()
        cursor.execute(sql)
        res = cursor.fetchone()
        if res is not None:
            return int(res[0])
        else:
            return 0

       