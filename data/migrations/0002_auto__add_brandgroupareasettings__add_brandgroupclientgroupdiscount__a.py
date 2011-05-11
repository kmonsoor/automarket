# encoding: utf-8
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models

class Migration(SchemaMigration):

    def forwards(self, orm):
        
        # Adding model 'BrandGroupAreaSettings'
        db.create_table('data_brandgroupareasettings', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('delivery', self.gf('django.db.models.fields.FloatField')(null=True, blank=True)),
            ('multiplier', self.gf('django.db.models.fields.DecimalField')(null=True, max_digits=7, decimal_places=3, blank=True)),
            ('area', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['data.Area'])),
            ('brand_group', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['data.BrandGroup'])),
        ))
        db.send_create_signal('data', ['BrandGroupAreaSettings'])

        # Adding model 'BrandGroupClientGroupDiscount'
        db.create_table('data_brandgroupclientgroupdiscount', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('client_group', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['data.ClientGroup'])),
            ('brand_group', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['data.BrandGroup'], null=True, blank=True)),
            ('discount', self.gf('django.db.models.fields.FloatField')()),
        ))
        db.send_create_signal('data', ['BrandGroupClientGroupDiscount'])

        # Adding unique constraint on 'BrandGroupClientGroupDiscount', fields ['client_group', 'brand_group']
        db.create_unique('data_brandgroupclientgroupdiscount', ['client_group_id', 'brand_group_id'])

        # Adding model 'ClientGroupDiscount'
        db.create_table('data_clientgroupdiscount', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('client_group', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['data.ClientGroup'])),
            ('brand_group', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['data.BrandGroup'], null=True, blank=True)),
            ('area', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['data.Area'])),
            ('discount', self.gf('django.db.models.fields.FloatField')()),
        ))
        db.send_create_signal('data', ['ClientGroupDiscount'])

        # Adding unique constraint on 'ClientGroupDiscount', fields ['client_group', 'area', 'brand_group']
        db.create_unique('data_clientgroupdiscount', ['client_group_id', 'area_id', 'brand_group_id'])

        # Adding model 'UserProfile'
        db.create_table('data_userprofile', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('client_group', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['data.ClientGroup'])),
            ('order_item_fields', self.gf('django.db.models.fields.TextField')(default='', blank=True)),
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

        # Adding model 'BrandGroupDiscount'
        db.create_table('data_brandgroupdiscount', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('user', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['auth.User'])),
            ('brand_group', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['data.BrandGroup'])),
            ('discount', self.gf('django.db.models.fields.FloatField')()),
        ))
        db.send_create_signal('data', ['BrandGroupDiscount'])

        # Adding field 'Direction.delivery'
        db.add_column('data_direction', 'delivery', self.gf('django.db.models.fields.FloatField')(null=True, blank=True), keep_default=False)

        # Adding field 'Direction.multiplier'
        db.add_column('data_direction', 'multiplier', self.gf('django.db.models.fields.DecimalField')(null=True, max_digits=7, decimal_places=3, blank=True), keep_default=False)

        # Adding field 'Discount.brand_group'
        db.add_column('data_discount', 'brand_group', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['data.BrandGroup'], null=True), keep_default=False)

        # Adding field 'BrandGroup.multiplier'
        db.add_column('data_brandgroup', 'multiplier', self.gf('django.db.models.fields.DecimalField')(null=True, max_digits=7, decimal_places=3, blank=True), keep_default=False)

        # Changing field 'BrandGroup.delivery'
        db.alter_column('data_brandgroup', 'delivery', self.gf('django.db.models.fields.FloatField')(null=True))


    def backwards(self, orm):
        
        # Removing unique constraint on 'ClientGroupDiscount', fields ['client_group', 'area', 'brand_group']
        db.delete_unique('data_clientgroupdiscount', ['client_group_id', 'area_id', 'brand_group_id'])

        # Removing unique constraint on 'BrandGroupClientGroupDiscount', fields ['client_group', 'brand_group']
        db.delete_unique('data_brandgroupclientgroupdiscount', ['client_group_id', 'brand_group_id'])

        # Deleting model 'BrandGroupAreaSettings'
        db.delete_table('data_brandgroupareasettings')

        # Deleting model 'BrandGroupClientGroupDiscount'
        db.delete_table('data_brandgroupclientgroupdiscount')

        # Deleting model 'ClientGroupDiscount'
        db.delete_table('data_clientgroupdiscount')

        # Deleting model 'UserProfile'
        db.delete_table('data_userprofile')

        # Deleting model 'ClientGroup'
        db.delete_table('data_clientgroup')

        # Deleting model 'BrandGroupDiscount'
        db.delete_table('data_brandgroupdiscount')

        # Deleting field 'Direction.delivery'
        db.delete_column('data_direction', 'delivery')

        # Deleting field 'Direction.multiplier'
        db.delete_column('data_direction', 'multiplier')

        # Deleting field 'Discount.brand_group'
        db.delete_column('data_discount', 'brand_group_id')

        # Deleting field 'BrandGroup.multiplier'
        db.delete_column('data_brandgroup', 'multiplier')

        # Changing field 'BrandGroup.delivery'
        db.alter_column('data_brandgroup', 'delivery', self.gf('django.db.models.fields.FloatField')())


    models = {
        'auth.group': {
            'Meta': {'object_name': 'Group'},
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
            'delivery': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'description': ('django.db.models.fields.TextField', [], {'null': 'True', 'blank': 'True'}),
            'direction': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['data.Direction']"}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'multiplier': ('django.db.models.fields.DecimalField', [], {'null': 'True', 'max_digits': '7', 'decimal_places': '3', 'blank': 'True'}),
            'title': ('django.db.models.fields.CharField', [], {'max_length': '10'})
        },
        'data.brandgroupareasettings': {
            'Meta': {'object_name': 'BrandGroupAreaSettings'},
            'area': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['data.Area']"}),
            'brand_group': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['data.BrandGroup']"}),
            'delivery': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'multiplier': ('django.db.models.fields.DecimalField', [], {'null': 'True', 'max_digits': '7', 'decimal_places': '3', 'blank': 'True'})
        },
        'data.brandgroupclientgroupdiscount': {
            'Meta': {'unique_together': "(('client_group', 'brand_group'),)", 'object_name': 'BrandGroupClientGroupDiscount'},
            'brand_group': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['data.BrandGroup']", 'null': 'True', 'blank': 'True'}),
            'client_group': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['data.ClientGroup']"}),
            'discount': ('django.db.models.fields.FloatField', [], {}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'})
        },
        'data.brandgroupdiscount': {
            'Meta': {'object_name': 'BrandGroupDiscount'},
            'brand_group': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['data.BrandGroup']"}),
            'discount': ('django.db.models.fields.FloatField', [], {}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'user': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['auth.User']"})
        },
        'data.clientgroup': {
            'Meta': {'object_name': 'ClientGroup'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'order_item_fields': ('django.db.models.fields.TextField', [], {'null': 'True', 'blank': 'True'}),
            'title': ('django.db.models.fields.CharField', [], {'max_length': '255'})
        },
        'data.clientgroupdiscount': {
            'Meta': {'unique_together': "(('client_group', 'area', 'brand_group'),)", 'object_name': 'ClientGroupDiscount'},
            'area': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['data.Area']"}),
            'brand_group': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['data.BrandGroup']", 'null': 'True', 'blank': 'True'}),
            'client_group': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['data.ClientGroup']"}),
            'discount': ('django.db.models.fields.FloatField', [], {}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'})
        },
        'data.direction': {
            'Meta': {'object_name': 'Direction'},
            'delivery': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'multiplier': ('django.db.models.fields.DecimalField', [], {'null': 'True', 'max_digits': '7', 'decimal_places': '3', 'blank': 'True'}),
            'po': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'title': ('django.db.models.fields.CharField', [], {'max_length': '255'})
        },
        'data.discount': {
            'Meta': {'unique_together': "(('user', 'area'),)", 'object_name': 'Discount'},
            'area': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['data.Area']"}),
            'brand_group': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['data.BrandGroup']", 'null': 'True'}),
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
            'order_item_fields': ('django.db.models.fields.TextField', [], {'default': "''", 'blank': 'True'}),
            'user': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['auth.User']", 'unique': 'True'})
        }
    }

    complete_apps = ['data']
