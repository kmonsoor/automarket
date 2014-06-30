# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'Bot2'
        db.create_table('common_bot2', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('year', self.gf('django.db.models.fields.IntegerField')(null=True, blank=True)),
            ('maker', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('model', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('refoenumber', self.gf('django.db.models.fields.CharField')(max_length=255, db_index=True)),
            ('itemnumber', self.gf('django.db.models.fields.CharField')(max_length=255, db_index=True)),
            ('description', self.gf('django.db.models.fields.TextField')(max_length=255, null=True, blank=True)),
            ('quality', self.gf('django.db.models.fields.CharField')(max_length=255, null=True, blank=True)),
            ('listprice', self.gf('django.db.models.fields.FloatField')(null=True, blank=True)),
            ('yourprice', self.gf('django.db.models.fields.FloatField')(null=True, blank=True)),
            ('images', self.gf('django.db.models.fields.TextField')(null=True, blank=True)),
            ('note', self.gf('django.db.models.fields.TextField')(null=True, blank=True)),
            ('assembly', self.gf('django.db.models.fields.TextField')(null=True, blank=True)),
        ))
        db.send_create_signal('common', ['Bot2'])


    def backwards(self, orm):
        # Deleting model 'Bot2'
        db.delete_table('common_bot2')


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
        },
        'common.bot2': {
            'Meta': {'object_name': 'Bot2'},
            'assembly': ('django.db.models.fields.TextField', [], {'null': 'True', 'blank': 'True'}),
            'description': ('django.db.models.fields.TextField', [], {'max_length': '255', 'null': 'True', 'blank': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'images': ('django.db.models.fields.TextField', [], {'null': 'True', 'blank': 'True'}),
            'itemnumber': ('django.db.models.fields.CharField', [], {'max_length': '255', 'db_index': 'True'}),
            'listprice': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'maker': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'model': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'note': ('django.db.models.fields.TextField', [], {'null': 'True', 'blank': 'True'}),
            'quality': ('django.db.models.fields.CharField', [], {'max_length': '255', 'null': 'True', 'blank': 'True'}),
            'refoenumber': ('django.db.models.fields.CharField', [], {'max_length': '255', 'db_index': 'True'}),
            'year': ('django.db.models.fields.IntegerField', [], {'null': 'True', 'blank': 'True'}),
            'yourprice': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'})
        }
    }

    complete_apps = ['common']