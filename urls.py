from django.conf.urls.defaults import *

urlpatterns = patterns('',
    # Example:
    # (r'^automarket/', include('automarket.foo.urls')),

    # Uncomment this for admin:
     (r'^admin/', include('django.contrib.admin.urls')),
)

urlpatterns += patterns('cp.views',
    (r'^cp/', 'index'),
)


urlpatterns += patterns('client.views',
    (r'^client/$','index'),
    (r'^client/order/','order'),
)