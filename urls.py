from django.conf.urls.defaults import *

urlpatterns = patterns('',
    (r'^media/(?P<path>.*)$', 'django.views.static.serve', {'document_root': 'd:/projects/automarket/media'}),
    (r'^admin/', include('django.contrib.admin.urls')),
)

urlpatterns += patterns('cp.views',
    (r'^cp/', 'index'),
)


urlpatterns += patterns('client.views',
    (r'^client/$','index'),
    (r'^client/order/','order'),
)