# -*- coding=utf-8 -*-

from settings import PATHES

# Set pathes
import os, sys
for P in PATHES:
    sys.path.append(P)
os.environ['DJANGO_SETTINGS_MODULE'] = 'automarket.settings'

# Code

from data.models import Po, createTarifClasses

for po in Po.objects.all():
    createTarifClasses(po)
