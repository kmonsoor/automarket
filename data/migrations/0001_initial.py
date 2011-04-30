# encoding: utf-8
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models

class Migration(SchemaMigration):

    def forwards(self, orm):
        
        # Adding model 'Direction'
        db.create_table('data_direction', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('title', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('po', self.gf('django.db.models.fields.CharField')(max_length=255)),
        ))
        db.send_create_signal('data', ['Direction'])

        # Adding model 'BrandGroup'
        db.create_table('data_brandgroup', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('direction', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['data.Direction'])),
            ('title', self.gf('django.db.models.fields.CharField')(max_length=10)),
            ('description', self.gf('django.db.models.fields.TextField')(null=True, blank=True)),
            ('delivery', self.gf('django.db.models.fields.FloatField')(default=0)),
            ('add_brand_to_comment', self.gf('django.db.models.fields.BooleanField')(default=False)),
        ))
        db.send_create_signal('data', ['BrandGroup'])

        # Adding M2M table for field area on 'BrandGroup'
        db.create_table('data_brandgroup_area', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('brandgroup', models.ForeignKey(orm['data.brandgroup'], null=False)),
            ('area', models.ForeignKey(orm['data.area'], null=False))
        ))
        db.create_unique('data_brandgroup_area', ['brandgroup_id', 'area_id'])

        # Adding model 'Area'
        db.create_table('data_area', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('title', self.gf('django.db.models.fields.CharField')(max_length=255)),
        ))
        db.send_create_signal('data', ['Area'])

        # Adding M2M table for field brands on 'Area'
        db.create_table('data_area_brands', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('area', models.ForeignKey(orm['data.area'], null=False)),
            ('brand', models.ForeignKey(orm['data.brand'], null=False))
        ))
        db.create_unique('data_area_brands', ['area_id', 'brand_id'])

        # Adding model 'Brand'
        db.create_table('data_brand', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('title', self.gf('django.db.models.fields.CharField')(max_length=255)),
        ))
        db.send_create_signal('data', ['Brand'])

        # Adding model 'Discount'
        db.create_table('data_discount', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('user', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['auth.User'])),
            ('area', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['data.Area'])),
            ('discount', self.gf('django.db.models.fields.FloatField')()),
        ))
        db.send_create_signal('data', ['Discount'])

        # Adding unique constraint on 'Discount', fields ['user', 'area']
        db.create_unique('data_discount', ['user_id', 'area_id'])

        # Adding model 'OrderedItem'
        db.create_table('data_ordereditem', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('brandgroup', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['data.BrandGroup'])),
            ('area', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['data.Area'])),
            ('brand', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['data.Brand'])),
            ('ponumber', self.gf('django.db.models.fields.IntegerField')(null=True, blank=True)),
            ('part_number', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('part_number_superseded', self.gf('django.db.models.fields.CharField')(max_length=255, null=True, blank=True)),
            ('comment_customer', self.gf('django.db.models.fields.TextField')(null=True, blank=True)),
            ('comment_supplier', self.gf('django.db.models.fields.TextField')(null=True, blank=True)),
            ('quantity', self.gf('django.db.models.fields.PositiveIntegerField')(null=True, blank=True)),
            ('price_invoice', self.gf('django.db.models.fields.FloatField')(null=True, blank=True)),
            ('total_w_ship', self.gf('django.db.models.fields.FloatField')(null=True, blank=True)),
            ('client', self.gf('django.db.models.fields.related.ForeignKey')(related_name=u'client', to=orm['auth.User'])),
            ('client_order_id', self.gf('django.db.models.fields.IntegerField')(null=True, blank=True)),
            ('manager', self.gf('django.db.models.fields.related.ForeignKey')(related_name=u'manager', to=orm['auth.User'])),
            ('description_ru', self.gf('django.db.models.fields.TextField')(null=True, blank=True)),
            ('description_en', self.gf('django.db.models.fields.TextField')(null=True, blank=True)),
            ('price_base', self.gf('django.db.models.fields.FloatField')(null=True, blank=True)),
            ('price_sale', self.gf('django.db.models.fields.FloatField')(null=True, blank=True)),
            ('price_discount', self.gf('django.db.models.fields.FloatField')(null=True, blank=True)),
            ('weight', self.gf('django.db.models.fields.FloatField')(null=True, blank=True)),
            ('delivery', self.gf('django.db.models.fields.FloatField')(null=True, blank=True)),
            ('cost', self.gf('django.db.models.fields.FloatField')(null=True, blank=True)),
            ('total_cost', self.gf('django.db.models.fields.FloatField')(null=True, blank=True)),
            ('status', self.gf('django.db.models.fields.CharField')(default='order', max_length=50)),
            ('status_modified', self.gf('django.db.models.fields.DateTimeField')(null=True, blank=True)),
            ('previous_status', self.gf('django.db.models.fields.CharField')(max_length=50, null=True, blank=True)),
            ('created', self.gf('django.db.models.fields.DateTimeField')(auto_now_add=True, blank=True)),
            ('modified', self.gf('django.db.models.fields.DateTimeField')(auto_now=True, blank=True)),
            ('invoice_code', self.gf('django.db.models.fields.CharField')(default='', max_length=255)),
        ))
        db.send_create_signal('data', ['OrderedItem'])


    def backwards(self, orm):
        
        # Removing unique constraint on 'Discount', fields ['user', 'area']
        db.delete_unique('data_discount', ['user_id', 'area_id'])

        # Deleting model 'Direction'
        db.delete_table('data_direction')

        # Deleting model 'BrandGroup'
        db.delete_table('data_brandgroup')

        # Removing M2M table for field area on 'BrandGroup'
        db.delete_table('data_brandgroup_area')

        # Deleting model 'Area'
        db.delete_table('data_area')

        # Removing M2M table for field brands on 'Area'
        db.delete_table('data_area_brands')

        # Deleting model 'Brand'
        db.delete_table('data_brand')

        # Deleting model 'Discount'
        db.delete_table('data_discount')

        # Deleting model 'OrderedItem'
        db.delete_table('data_ordereditem')


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
        }
    }

    complete_apps = ['data']
