# -*- coding=utf-8 -*-
from django.conf.urls.defaults import *
from django.contrib import admin
from django.conf import settings
admin.autodiscover()
urlpatterns = patterns('',)

if settings.DEBUG:
    urlpatterns += patterns('',
        (r'^media/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.MEDIA_ROOT}),
    )

urlpatterns += patterns('',
    url(r'^admin/(.*)', admin.site.root),
)


urlpatterns += patterns('common.views',
    url(r'^$', 'start'),
    url(r'^accounts/login/$', 'start'),
    url(r'^accounts/logout/$','exit'),
)


urlpatterns += patterns('cp.views',
    url(r'^cp/search/$', 'search', name="search"),
    url(r'^cp/order/$', 'order', name="order"),
    url(r'^cp/groups/$', 'groups', name="groups"),
    url(r'^cp/position/edit/(?P<content_type>\w+)/(?P<id>\d+)/$', 'position_edit'),
    url(r'^cp/export/(?P<group_id>\d+)/$', 'export'),
    url(r'^cp/import_order/', 'import_order', name='import_to_csv'),
    url(r'^cp/$', 'index'),
)


urlpatterns += patterns('client.views',
    url(r'^client/help/(?P<supplier_id>[\d]+)/brands/$', 'help_brand_list', name='brand_list'),
    url(r'^client/','index'),
)
