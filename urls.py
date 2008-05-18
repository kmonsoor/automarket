from django.conf.urls.defaults import *

urlpatterns = patterns('',
    (r'^media/(?P<path>.*)$', 'django.views.static.serve', {'document_root': 'd:/projects/automarket/media'}),
    (r'^admin/', include('django.contrib.admin.urls')),
)

urlpatterns += patterns('common.views',
    (r'^$', 'start'),
    (r'^accounts/login/$', 'start'),
)


urlpatterns += patterns('cp.views',
    (r'^cp/$', 'index'),
    (r'^client/cp/$', 'index'),
    (r'^cp/groups/$', 'groups'),
    (r'^cp/position/edit/(?P<id>\d+)/$', 'position_edit'),
    (r'^cp/export/(?P<group_id>\d+)/$', 'export'),
)


urlpatterns += patterns('client.views',
    (r'^client/order/(?P<po>[-_0-9\w]{0,})/delete/(?P<item_id>[\d]+)/$','delete_item'),
    (r'^client/order/superseded/(?P<action>accept|decline)/(?P<item_id>[\d]+)','superseded'),
    (r'^client/order/$','order',),
    (r'^client/help/brands.html', 'help_brand_list'),
    (r'^client/import_order/','import_order'),
    (r'^client/','index'),
)