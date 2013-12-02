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

DATABASE_ENGINE = 'sqlite3'          # 'postgresql_psycopg2', 'postgresql', 'mysql', 'sqlite3' or 'ado_mssql'.
DATABASE_NAME = 'dev.sqlite.db3'             # Or path to database file if using sqlite3.
DATABASE_USER = ''             # Not used with sqlite3.
DATABASE_PASSWORD = ''         # Not used with sqlite3.
DATABASE_HOST = ''             # Set to empty string for localhost. Not used with sqlite3.
DATABASE_PORT = ''             # Set to empty string for default. Not used with sqlite3.


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
ADMIN_TOOLS_INDEX_DASHBOARD = 'admin_tools_dashboard.MyDashboard'
ADMIN_TOOLS_APP_INDEX_DASHBOARD = 'admin_tools_dashboard.CustomAppIndexDashboard'
ADMIN_TOOLS_MENU = 'admin_tools_menu.CustomMenu'

ADMIN_TOOLS_THEMING_CSS = 'css/admin_tools_theming.css'

TEMPLATE_LOADERS = (
    'django.template.loaders.filesystem.load_template_source',
    'django.template.loaders.app_directories.load_template_source',
#     'django.template.loaders.eggs.load_template_source',
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
    'lib.SQLLogMiddleware.SQLLogMiddleware',
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
    'common',
    'lib',
    'south',
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

PRICE_UPLOAD_DIR = 'uploads/prices/' #override in production

COST_DEFAULT_MARGIN = 40 # percent

AUTO_UPDATE_STATUSES_START_PONUMBER = 944 # SP944

try:
    from settings_local import *
except:
    pass


# Logging settings
import logging
from log_handlers import NullHandler, TimedRotatingFileHandlerSafe
# Logging settings
LOG_DIR = os.path.join(SITE_ROOT, '.logs') # for development only! need to be rewritten
# A log rollover occurs
# S - Seconds
# M - Minutes
# H - Hours
# D - Days
# MIDNIGHT - roll over at midnight
# W{0-6} - roll over on a certain day; 0 - Monday
LOG_INTERVAL = 'MIDNIGHT'
# Loading host depending settings
LOG_LEVEL = DEBUG and logging.DEBUG or logging.INFO

#USE_L10N = True
DATETIME_INPUT_FORMATS = ("%d.%m.%Y %H:%M:%S",)
DATETIME_FORMAT = "d.m.Y H:i:s"
DECIMAL_SEPARATOR = '.'
DATE_FORMAT = 'd.m.Y'
DATE_INPUT_FORMATS = ("%d.%m.%Y",)

try:
    from settings_local import *
except ImportError:
    pass

if not os.path.exists(LOG_DIR):
    try:
        os.mkdir(LOG_DIR)
    except:
        pass

LOG_FILE = os.path.join(LOG_DIR, 'debug.log')
ERR_FILE = os.path.join(LOG_DIR, 'error.log')

FORMAT = '[%(asctime)s] [%(levelname)s] [PID: '+str(os.getpid())+'] [%(name)s]:  %(message)s'
FORMATTER = logging.Formatter(FORMAT)


logging.basicConfig(level=LOG_LEVEL,
                    format=FORMAT,
                    filename=LOG_FILE)

#logging.basicConfig(level=logging.NOTSET, stream=NullHandler())

#root = logging.root
#log_handler = TimedRotatingFileHandlerSafe(LOG_FILE, when=LOG_INTERVAL)
#log_handler.setLevel(LOG_LEVEL)
#log_handler.setFormatter(FORMATTER)
#root.addHandler(log_handler)

#err_handler = TimedRotatingFileHandlerSafe(ERR_FILE, when=LOG_INTERVAL)
#err_handler.setLevel(logging.ERROR)
#err_handler.setFormatter(FORMATTER)
#root.addHandler(err_handler)

