# -*- coding=utf-8 -*-

from django.conf.urls.defaults import *

try:
    from settings_local import MEDIA_ROOT
    DEVELOPMENT_MODE = True
except:
    from django.conf.settings import MEDIA_ROOT
    DEVELOPMENT_MODE = False

urlpatterns = patterns('',)

if DEVELOPMENT_MODE:
    urlpatterns += patterns('',
        (r'^media/(?P<path>.*)$', 'django.views.static.serve', {'document_root': MEDIA_ROOT}),
    )    

urlpatterns += patterns('',
    (r'^admin/po/tariff/(?P<po_id>\d+)/', 'cp.admin.po_tariff'),
    (r'^admin/', include('django.contrib.admin.urls')),
)


urlpatterns += patterns('common.views',
    (r'^$', 'start'),
    (r'^accounts/login/$', 'start'),
    (r'^accounts/logout/$','exit'),
)


urlpatterns += patterns('cp.views',
    (r'^cp/$', 'index'),
    (r'^client/cp/$', 'index'),
    (r'^cp/groups/$', 'groups'),
    (r'^cp/position/edit/(?P<content_type>\w+)/(?P<id>\d+)/$', 'position_edit'),
    (r'^cp/export/(?P<group_id>\d+)/$', 'export'),
    (r'^cp/make_invoices/$', 'make_invoices'),
    (r'^cp/invoices/$', 'invoices'),
    (r'^cp/invoice/(?P<id>\d+)/$', 'invoice'),
)


urlpatterns += patterns('client.views',
    (r'^client/order/(?P<po>[-_0-9\w]{0,})/delete/(?P<item_id>[\d]+)/$','delete_item'),
    (r'^client/order/superseded/(?P<action>accept|decline)/(?P<item_id>[\d]+)','superseded'),
    (r'^client/order/$','order',),
    (r'^client/help/brands.html', 'help_brand_list'),
    (r'^client/import_order/','import_order'),
    (r'^client/invoices/','invoices'),
    (r'^client/balance/','balance'),
    (r'^client/','index'),
)