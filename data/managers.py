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
        except :
            return 1
        else:
            return cursor.fetchone()[0] + 1