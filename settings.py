# -*- coding=utf-8 -*-
import os
DEBUG = True
DEBUG_SQL = False
TEMPLATE_DEBUG = DEBUG

SECRET_GARDEN = True
SECRET_GARDEN_KEY = 'admin'

ADMINS = (
    # ('Your Name', 'your_email@domain.com'),
)

ROLES = []

MANAGERS = ADMINS

DATABASE_ENGINE = 'sqlite3'          # 'postgresql_psycopg2', 'postgresql', 'mysql', 'sqlite3' or 'ado_mssql'.
DATABASE_NAME = 'dev.sqlite.db3'             # Or path to database file if using sqlite3.
DATABASE_USER = ''             # Not used with sqlite3.
DATABASE_PASSWORD = ''         # Not used with sqlite3.
DATABASE_HOST = ''             # Set to empty string for localhost. Not used with sqlite3.
DATABASE_PORT = ''             # Set to empty string for default. Not used with sqlite3.


TIME_ZONE = 'America/Chicago'

LANGUAGE_CODE = 'ru-Ru'

SITE_ID = 1

USE_I18N = True

# Absolute path to the directory that holds media.
# Example: "/home/media/media.lawrence.com/"

MEDIA_ROOT = os.path.abspath('./media/')

MEDIA_URL = '/media/'

ADMIN_MEDIA_PREFIX = '/admin_media/'

SECRET_KEY = '%^i)f6-(3d$&n2l0-=wnnj0=vldr@xtakth%50htl9s3a1510!'

TEMPLATE_LOADERS = (
    'django.template.loaders.filesystem.load_template_source',
    'django.template.loaders.app_directories.load_template_source',
#     'django.template.loaders.eggs.load_template_source',
)

TEMPLATE_CONTEXT_PROCESSORS = (
    'django.core.context_processors.auth',
    'django.core.context_processors.request',
    'lib.context_processors.media_url',
    'lib.context_processors.next',
)

MIDDLEWARE_CLASSES = (
    'django.middleware.common.CommonMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.middleware.doc.XViewMiddleware',
    'lib.SQLLogMiddleware.SQLLogMiddleware',
)

ROOT_URLCONF = 'urls'

TEMPLATE_DIRS = (
    os.path.abspath("./templates"),
)

INSTALLED_APPS = (
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.sites',
    'django.contrib.admin',
    'data',
    'client',
    'cp',
    'common',
    'lib'
)

SESSION_EXPIRE_AT_BROWSER_CLOSE = True
SESSION_COOKIE_AGE = 3600


# SOAP settings
SOAP_LOGIN = 'garage242'
SOAP_PASSWORD = 'e0glsx'
WSDL_URL = 'http://automototrade.com/wsdl/server.php?wsdl'

try:
    from settings_local import *
except:
    pass