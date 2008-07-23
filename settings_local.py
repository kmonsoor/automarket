# -*- coding=utf-8 -*-

DATABASE_ENGINE = 'mysql'           # 'postgresql_psycopg2', 'postgresql', 'mysql', 'sqlite3' or 'ado_mssql'.
DATABASE_NAME = 'automarket'             # Or path to database file if using sqlite3.
DATABASE_USER = 'root'             # Not used with sqlite3.
DATABASE_PASSWORD = '12345678'         # Not used with sqlite3.
DATABASE_HOST = ''             # Set to empty string for localhost. Not used with sqlite3.
DATABASE_PORT = ''             # Set to empty string for default. Not used with sqlite3.


TEMPLATE_DIRS = (
    # Put strings here, like "/home/html/django_templates" or "C:/www/django/templates".
    # Always use forward slashes, even on Windows.
    # Don't forget to use absolute paths, not relative paths.
    "/home/webchemist/Projects/automarket/templates",
)

# Absolute path to the directory that holds media.
# Example: "/home/media/media.lawrence.com/"
#MEDIA_ROOT = 'd:/projects/automarket/media/'

MEDIA_ROOT = '/home/webchemist/Projects/automarket/media/'

# URL that handles the media served from MEDIA_ROOT.
# Example: "http://media.lawrence.com"
MEDIA_URL = '/media/'

# URL prefix for admin media -- CSS, JavaScript and images. Make sure to use a
# trailing slash.
# Examples: "http://foo.com/media/", "/media/".
ADMIN_MEDIA_PREFIX = '/admin_media/'