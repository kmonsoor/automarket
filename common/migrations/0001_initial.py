# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'Bot1'
        db.create_table('common_bot1', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('area', self.gf('django.db.models.fields.CharField')(max_length=255, db_index=True)),
            ('partnumber', self.gf('django.db.models.fields.CharField')(max_length=255, db_index=True)),
            ('substitution', self.gf('django.db.models.fields.CharField')(max_length=255, null=True, blank=True)),
            ('description', self.gf('django.db.models.fields.TextField')(max_length=255, null=True, blank=True)),
            ('delivery_period', self.gf('django.db.models.fields.CharField')(max_length=255, null=True, blank=True)),
            ('price', self.gf('django.db.models.fields.FloatField')(null=True, blank=True)),
            ('core', self.gf('django.db.models.fields.FloatField')(null=True, blank=True)),
            ('price_cost', self.gf('django.db.models.fields.FloatField')(null=True, blank=True)),
            ('price_plus_core', self.gf('django.db.models.fields.FloatField')(null=True, blank=True)),
            ('currency', self.gf('django.db.models.fields.CharField')(max_length=10, null=True, blank=True)),
        ))
        db.send_create_signal('common', ['Bot1'])


    def backwards(self, orm):
        # Deleting model 'Bot1'
        db.delete_table('common_bot1')


    models = {
        'common.bot1': {
            'Meta': {'object_name': 'Bot1'},
            'area': ('django.db.models.fields.CharField', [], {'max_length': '255', 'db_index': 'True'}),
            'core': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'currency': ('django.db.models.fields.CharField', [], {'max_length': '10', 'null': 'True', 'blank': 'True'}),
            'delivery_period': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True', 'blank': 'True'}),
            'description': ('django.db.models.fields.TextField', [], {'max_length': '255', 'null': 'True', 'blank': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'partnumber': ('django.db.models.fields.CharField', [], {'max_length': '255', 'db_index': 'True'}),
            'price': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'price_cost': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'price_plus_core': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'substitution': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True', 'blank': 'True'})
        }
    }

    complete_apps = ['common']