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
    url(r'^cp/order/success/$', 'order_success', name="order_success"),
    url(r'^cp/order/$', 'order', name="order"),
    url(r'^cp/groups/$', 'groups', name="groups"),
    url(r'^cp/position/edit/(?P<content_type>\w+)/(?P<id>\d+)/$', 'position_edit'),
    url(r'^cp/position/change_status/$', 'change_status'),
    
    url(r'^cp/export/(?P<group_id>\d+)/$', 'export'),
    url(r'^cp/export/$', 'export_selected'),
    url(r'^cp/import_order/', 'import_order', name='import_to_csv'),
    url(r'^cp/export_order/', 'export_order', name='export_to_csv'),
    url(r'^cp/$', 'index'),
)


urlpatterns += patterns('client.views',
    url(r'^client/search/$', 'search', name='client_search'),
    url(r'^client/help/(?P<brandgroup_id>[\d]+)/area/$', 'help_area_list', name='area_list'),
    url(r'^client/help/(?P<area_id>[\d]+)/brands/$', 'help_brands_list', name='brands_list'),
    url(r'^client/','index'),
)
