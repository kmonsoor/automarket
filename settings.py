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

# Emails
ROOT_URL = 'newparts-online.com'
EMAILS = []
MANAGERS_EMAILS = []
EMAIL_FROM = 'no-reply@%s' % ROOT_URL
EMAIL_SUBJECT = u'Новые заказы на %s' % ROOT_URL

ROLES = []

MANAGERS = ADMINS

DATABASE_ENGINE = 'sqlite3'
DATABASE_NAME = 'dev.sqlite.db3'
DATABASE_USER = ''
DATABASE_PASSWORD = ''
DATABASE_HOST = ''
DATABASE_PORT = ''

TIME_ZONE = 'Europe/Minsk'

LANGUAGE_CODE = 'ru-Ru'

SITE_ID = 1

USE_I18N = True

# Absolute path to the directory that holds media.
# Example: "/home/media/media.lawrence.com/"
SITE_ROOT = os.path.abspath(os.path.dirname(__file__))
MEDIA_ROOT = os.path.abspath('./media/')
MEDIA_URL = '/media/'
ADMIN_MEDIA_PREFIX = "/media/admin/"
SECRET_KEY = '%^i)f6-(3d$&n2l0-=wnnj0=vldr@xtakth%50htl9s3a1510!'

# Admin tools settings
ADMIN_TOOLS_INDEX_DASHBOARD = {
    'django.contrib.admin.site': 'admin_tools_dashboard.MyDashboard',
    'data.admin.manager_admin_site': 'admin_tools_dashboard.ManagerDashboard',
}
ADMIN_TOOLS_APP_INDEX_DASHBOARD = {
    'django.contrib.admin.site': 'admin_tools_dashboard.CustomAppIndexDashboard',
    'data.admin.manager_admin_site': 'admin_tools_dashboard.ManagerAppIndexDashboard',
}
ADMIN_TOOLS_MENU = 'admin_tools_menu.CustomMenu'

ADMIN_TOOLS_THEMING_CSS = 'css/admin_tools_theming.css'

TEMPLATE_LOADERS = (
    'django.template.loaders.filesystem.load_template_source',
    'django.template.loaders.app_directories.load_template_source',
)

TEMPLATE_CONTEXT_PROCESSORS = (
    'django.core.context_processors.auth',
    'django.core.context_processors.request',
    'django.contrib.messages.context_processors.messages',
    'lib.context_processors.media_url',
    'lib.context_processors.next',
)

MIDDLEWARE_CLASSES = (
    'django.middleware.common.CommonMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.doc.XViewMiddleware',
)

ROOT_URLCONF = 'urls'

TEMPLATE_DIRS = (
    os.path.abspath("./templates"),
)

INSTALLED_APPS = (
    'admin_tools',
    'admin_tools.theming',
    'admin_tools.menu',
    'admin_tools.dashboard',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.sites',
    'django.contrib.admin',
    'data',
    'client',
    'cp',
    'manager',
    'common',
    'lib',
    'south',
    'rpc4django',
)

INSTALLED_APPS += (
    'djcelery', 
    'kombu.transport.django',
)

import djcelery
djcelery.setup_loader()

BROKER_URL = "django://"
CELERYBEAT_SCHEDULER = "djcelery.schedulers.DatabaseScheduler"
CELERY_SEND_TASK_ERROR_EMAILS = True

SESSION_EXPIRE_AT_BROWSER_CLOSE = True
SESSION_COOKIE_AGE = 7200

PROJECT_ROOT = os.path.abspath('.')
# SOAP settings
SOAP_ENABLE = True
SOAP_LOGIN = ''
SOAP_PASSWORD = ''
WSDL_URL = 'http://automototrade.com/wsdl/server.php?wsdl'

DELIVERY_TYPE = 1 # Avia

# SMTP
EMAIL_HOST = 'localhost'
EMAIL_PORT = 25
EMAIL_HOST_USER = ''
EMAIL_HOST_PASSWORD = ''
EMAIL_USE_TLS = False

AUTH_PROFILE_MODULE = 'data.UserProfile'

PRICE_UPLOAD_DIR = 'uploads/prices/'
PART_ANALOG_UPLOAD_DIR = 'uploads/prices_analog/'

AUTO_UPDATE_STATUSES_START_PONUMBER = 944 # SP944

try:
    from settings_local import *
except:
    pass

DATETIME_INPUT_FORMATS = ("%d.%m.%Y %H:%M:%S",)
DATETIME_FORMAT = "d.m.Y H:i:s"
DECIMAL_SEPARATOR = '.'
DATE_FORMAT = 'd.m.Y'
DATE_INPUT_FORMATS = ("%d.%m.%Y",)


# Logging settings
import logging
LOG_DIR = os.path.join(SITE_ROOT, '.logs')
LOG_INTERVAL = 'MIDNIGHT'
LOG_LEVEL = DEBUG and logging.DEBUG or logging.INFO

if not os.path.exists(LOG_DIR):
    try:
        os.mkdir(LOG_DIR)
    except:
        pass

LOG_FILE = os.path.join(LOG_DIR, 'debug.log')
ERR_FILE = os.path.join(LOG_DIR, 'error.log')
FORMAT = '[%(asctime)s] [%(levelname)s] [PID: '+str(os.getpid())+'] [%(name)s]:  %(message)s'
FORMATTER = logging.Formatter(FORMAT)
logging.basicConfig(level=LOG_LEVEL, format=FORMAT, filename=LOG_FILE)
