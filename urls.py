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
    (r'^cp/position/edit/(?P<id>\d+)/$', 'position_edit'),
)


urlpatterns += patterns('client.views',
    (r'^client/order/(?P<po>[-_0-9\w]{0,})','order'),
    (r'^client/help/brands.html', 'help_brand_list'),
    (r'^client/','index'),
)