# -*- coding=utf-8 -*-

from settings import PATHES

# Set pathes
import os, sys
for P in PATHES:
    sys.path.append(P)
os.environ['DJANGO_SETTINGS_MODULE'] = 'automarket.settings'


from data.models import Brand



brands = Brand.objects.all()
for b in brands:
    newname = b.name.lower()
    b.name = newname
    b.save()
