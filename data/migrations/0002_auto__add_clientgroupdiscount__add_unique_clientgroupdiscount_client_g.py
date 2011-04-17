# encoding: utf-8
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models

class Migration(SchemaMigration):

    def forwards(self, orm):
        
        # Adding model 'ClientGroupDiscount'
        db.create_table('data_clientgroupdiscount', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('client_group', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['data.ClientGroup'])),
            ('area', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['data.Area'])),
            ('discount', self.gf('django.db.models.fields.FloatField')()),
        ))
        db.send_create_signal('data', ['ClientGroupDiscount'])

        # Adding unique constraint on 'ClientGroupDiscount', fields ['client_group', 'area']
        db.create_unique('data_clientgroupdiscount', ['client_group_id', 'area_id'])

        # Adding model 'UserProfile'
        db.create_table('data_userprofile', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('client_group', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['data.ClientGroup'])),
            ('order_item_fields', self.gf('django.db.models.fields.TextField')()),
            ('user', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['auth.User'], unique=True)),
        ))
        db.send_create_signal('data', ['UserProfile'])

        # Adding model 'ClientGroup'
        db.create_table('data_clientgroup', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('title', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('order_item_fields', self.gf('django.db.models.fields.TextField')(null=True, blank=True)),
        ))
        db.send_create_signal('data', ['ClientGroup'])

        # Adding field 'Area.multiplier'
        db.add_column('data_area', 'multiplier', self.gf('django.db.models.fields.DecimalField')(default=1.7, max_digits=7, decimal_places=3), keep_default=False)


    def backwards(self, orm):
        
        # Removing unique constraint on 'ClientGroupDiscount', fields ['client_group', 'area']
        db.delete_unique('data_clientgroupdiscount', ['client_group_id', 'area_id'])

        # Deleting model 'ClientGroupDiscount'
        db.delete_table('data_clientgroupdiscount')

        # Deleting model 'UserProfile'
        db.delete_table('data_userprofile')

        # Deleting model 'ClientGroup'
        db.delete_table('data_clientgroup')

        # Deleting field 'Area.multiplier'
        db.delete_column('data_area', 'multiplier')


    models = {
        'auth.group': {
            'Meta': {'object_name': 'Group'},
            'discount': ('django.db.models.fields.PositiveIntegerField', [], {'default': '0', 'null': 'True', 'blank': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'unique': 'True', 'max_length': '80'}),
            'permissions': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['auth.Permission']", 'symmetrical': 'False', 'blank': 'True'})
        },
        'auth.permission': {
            'Meta': {'ordering': "('content_type__app_label', 'content_type__model', 'codename')", 'unique_together': "(('content_type', 'codename'),)", 'object_name': 'Permission'},
            'codename': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            'content_type': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['contenttypes.ContentType']"}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '50'})
        },
        'auth.user': {
            'Meta': {'object_name': 'User'},
            'date_joined': ('django.db.models.fields.DateTimeField', [], {'default': 'datetime.datetime.now'}),
            'email': ('django.db.models.fields.EmailField', [], {'max_length': '75', 'blank': 'True'}),
            'first_name': ('django.db.models.fields.CharField', [], {'max_length': '30', 'blank': 'True'}),
            'groups': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['auth.Group']", 'symmetrical': 'False', 'blank': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'is_active': ('django.db.models.fields.BooleanField', [], {'default': 'True'}),
            'is_staff': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'is_superuser': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'last_login': ('django.db.models.fields.DateTimeField', [], {'default': 'datetime.datetime.now'}),
            'last_name': ('django.db.models.fields.CharField', [], {'max_length': '30', 'blank': 'True'}),
            'password': ('django.db.models.fields.CharField', [], {'max_length': '128'}),
            'user_permissions': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['auth.Permission']", 'symmetrical': 'False', 'blank': 'True'}),
            'username': ('django.db.models.fields.CharField', [], {'unique': 'True', 'max_length': '30'})
        },
        'contenttypes.contenttype': {
            'Meta': {'ordering': "('name',)", 'unique_together': "(('app_label', 'model'),)", 'object_name': 'ContentType', 'db_table': "'django_content_type'"},
            'app_label': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'model': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '100'})
        },
        'data.area': {
            'Meta': {'ordering': "['title']", 'object_name': 'Area'},
            'brands': ('django.db.models.fields.related.ManyToManyField', [], {'symmetrical': 'False', 'to': "orm['data.Brand']", 'null': 'True', 'blank': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'multiplier': ('django.db.models.fields.DecimalField', [], {'default': '1.7', 'max_digits': '7', 'decimal_places': '3'}),
            'title': ('django.db.models.fields.CharField', [], {'max_length': '255'})
        },
        'data.brand': {
            'Meta': {'ordering': "['title']", 'object_name': 'Brand'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'title': ('django.db.models.fields.CharField', [], {'max_length': '255'})
        },
        'data.brandgroup': {
            'Meta': {'object_name': 'BrandGroup'},
            'add_brand_to_comment': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'area': ('django.db.models.fields.related.ManyToManyField', [], {'symmetrical': 'False', 'to': "orm['data.Area']", 'null': 'True', 'blank': 'True'}),
            'delivery': ('django.db.models.fields.FloatField', [], {'default': '0'}),
            'description': ('django.db.models.fields.TextField', [], {'null': 'True', 'blank': 'True'}),
            'direction': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['data.Direction']"}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'title': ('django.db.models.fields.CharField', [], {'max_length': '10'})
        },
        'data.clientgroup': {
            'Meta': {'object_name': 'ClientGroup'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'order_item_fields': ('django.db.models.fields.TextField', [], {'null': 'True', 'blank': 'True'}),
            'title': ('django.db.models.fields.CharField', [], {'max_length': '255'})
        },
        'data.clientgroupdiscount': {
            'Meta': {'unique_together': "(('client_group', 'area'),)", 'object_name': 'ClientGroupDiscount'},
            'area': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['data.Area']"}),
            'client_group': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['data.ClientGroup']"}),
            'discount': ('django.db.models.fields.FloatField', [], {}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'})
        },
        'data.direction': {
            'Meta': {'object_name': 'Direction'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'po': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'title': ('django.db.models.fields.CharField', [], {'max_length': '255'})
        },
        'data.discount': {
            'Meta': {'unique_together': "(('user', 'area'),)", 'object_name': 'Discount'},
            'area': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['data.Area']"}),
            'discount': ('django.db.models.fields.FloatField', [], {}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'user': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['auth.User']"})
        },
        'data.ordereditem': {
            'Meta': {'object_name': 'OrderedItem'},
            'area': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['data.Area']"}),
            'brand': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['data.Brand']"}),
            'brandgroup': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['data.BrandGroup']"}),
            'client': ('django.db.models.fields.related.ForeignKey', [], {'related_name': "u'client'", 'to': "orm['auth.User']"}),
            'client_order_id': ('django.db.models.fields.IntegerField', [], {'null': 'True', 'blank': 'True'}),
            'comment_customer': ('django.db.models.fields.TextField', [], {'null': 'True', 'blank': 'True'}),
            'comment_supplier': ('django.db.models.fields.TextField', [], {'null': 'True', 'blank': 'True'}),
            'cost': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'created': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            'delivery': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'description_en': ('django.db.models.fields.TextField', [], {'null': 'True', 'blank': 'True'}),
            'description_ru': ('django.db.models.fields.TextField', [], {'null': 'True', 'blank': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'invoice_code': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '255'}),
            'manager': ('django.db.models.fields.related.ForeignKey', [], {'related_name': "u'manager'", 'to': "orm['auth.User']"}),
            'modified': ('django.db.models.fields.DateTimeField', [], {'auto_now': 'True', 'blank': 'True'}),
            'part_number': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'part_number_superseded': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True', 'blank': 'True'}),
            'ponumber': ('django.db.models.fields.IntegerField', [], {'null': 'True', 'blank': 'True'}),
            'previous_status': ('django.db.models.fields.CharField', [], {'max_length': '50', 'null': 'True', 'blank': 'True'}),
            'price_base': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'price_discount': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'price_invoice': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'price_sale': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'quantity': ('django.db.models.fields.PositiveIntegerField', [], {'null': 'True', 'blank': 'True'}),
            'status': ('django.db.models.fields.CharField', [], {'default': "'order'", 'max_length': '50'}),
            'status_modified': ('django.db.models.fields.DateTimeField', [], {'null': 'True', 'blank': 'True'}),
            'total_cost': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'total_w_ship': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'weight': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'})
        },
        'data.userprofile': {
            'Meta': {'object_name': 'UserProfile'},
            'client_group': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['data.ClientGroup']"}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'order_item_fields': ('django.db.models.fields.TextField', [], {}),
            'user': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['auth.User']", 'unique': 'True'})
        }
    }

    complete_apps = ['data']
