# -*- coding=utf-8 -*-
from django.conf.urls.defaults import *
from django.contrib import admin
from django.conf import settings
admin.autodiscover()
urlpatterns = patterns('',)

from data.admin import manager_admin_site

if settings.DEBUG:
    urlpatterns += patterns('',
        (r'^media/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.MEDIA_ROOT}),
    )

urlpatterns += patterns('',
    url(r'^admin/', include(admin.site.urls)),
)


urlpatterns += patterns('common.views',
    url(r'^$', 'start'),
    url(r'^accounts/login/$', 'start'),
    url(r'^accounts/logout/$','exit'),
)

urlpatterns += patterns('',
    url(r'^admin_tools/', include('admin_tools.urls')),
)

urlpatterns += patterns('cp.views',
    url(r'^cp/search/$', 'search', name="search"),
    url(r'^cp/order/success/$', 'order_success', name="order_success"),
    url(r'^cp/order/$', 'order', name="order"),
    url(r'^cp/groups/$', 'groups', name="groups"),
    url(r'^cp/invoices/$', 'invoices', name="invoices"),
    url(r'^cp/invoices/(?P<invoice_id>\d+)/$', 'invoice', name="invoice"),
    url(r'^cp/package/remove/$', 'remove_package', name="remove_package"),
    url(r'^cp/issues/$', 'issues', name="issues"),
    url(r'^cp/shipments/$', 'shipments', name="shipments"),
    url(r'^cp/shipments/(?P<shipment_id>\d+)/$', 'shipment', name="shipment"),
    url(r'^cp/issues/client/(?P<client_id>\d+)/$', 'issues_client', name="issues_client"),
    url(r'^cp/issues/manager/(?P<manager_id>\d+)/$', 'issues_manager', name="issues_manager"),
    url(r'^cp/balance/$', 'balance', name="balance"),
    url(r'^cp/balance/client/(?P<client_id>\d+)/$', 'balance_client', name="balance_client"),
    url(r'^cp/balance/delete/(?P<item_id>\d+)/$', 'balanceitem_delete', name="balanceitem_delete"),
    url(r'^cp/position/edit/(?P<content_type>\w+)/(?P<item_id>\d+)/$', 'position_edit'),
    url(r'^cp/position/change_status/$', 'change_status', name="change_status"),
    url(r'^cp/ordered_item/(?P<item_id>\d+)/$', 'get_ordered_item', name="get_ordered_item"),
    url(r'^cp/ordered_item_row/(?P<item_id>\d+)/$', 'ordered_item_row', name="ordered_item_row"),
    url(r'^cp/get_brandgroup_settings/(?P<ordered_item_id>[\d]+)/$', 'get_brandgroup_settings', name='get_brandgroup_settings'),
    url(r'^cp/brandgroup/(?P<brandgroup_id>[\d]+)/areas/$', 'get_brandgroup_areas', name='get_brandgroup_areas'),
    url(r'^cp/export/(?P<group_id>\d+)/$', 'export', name="export_group"),
    url(r'^cp/export/$', 'export_selected'),
    url(r'^cp/import_order/', 'import_order', name='import_to_csv'),
    url(r'^cp/export_order/', 'export_order', name='export_to_csv'),
    url(r'^cp/$', 'index', name="cp_index"),
)


urlpatterns += patterns('client.views',
    url(r'^client/search/$', 'search', name='client_search'),
    url(r'^client/basket/add/', 'basket_add', name="client_basket_add"),
    url(r'^client/basket/order/', 'basket_order', name="client_basket_order"),
    url(r'^client/basket/clear/', 'basket_clear', name="client_basket_clear"),
    url(r'^client/basket/update/', 'basket_update', name="client_basket_update"),
    url(r'^client/basket/delete/(?P<item_id>[\d]+)/', 'basket_delete', name="client_basket_delete"),
    url(r'^client/help/(?P<brandgroup_id>[\d]+)/area/$', 'help_area_list', name='area_list'),
    url(r'^client/help/(?P<area_id>[\d]+)/brands/$', 'help_brands_list', name='brands_list'),
    url(r'^client/export_order/$', 'export_order', name="client_export_order"),
    url(r'^client/shipments/$', 'shipments', name="client_shipments"),
    url(r'^client/balance/$', 'balance', name="client_balance"),
    url(r'^client/shipments/(?P<shipment_id>\d+)/$', 'shipment', name="client_shipment"),
    url(r'^client/', 'index', name='client_index'),
)

urlpatterns += patterns('manager.views',
    url(r'^manager/issues/client/(?P<client_id>\d+)/$', 'issues_client', name="manager_issues_client"),
    url(r'^manager/issues/$', 'issues', name="manager_issues"),
    url(r'^manager/invoices/(?P<invoice_id>\d+)/$', 'invoice', name="manager_invoice"),
    url(r'^manager/invoices/$', 'invoices', name="manager_invoices"),
    url(r'^manager/shipments/$', 'shipments', name="manager_shipments"),
    url(r'^manager/shipments/(?P<shipment_id>\d+)/$', 'shipment', name="manager_shipment"),
    url(r'^manager/balance/client/(?P<client_id>\d+)/$', 'balance_client', name="manager_balance_client"),
    url(r'^manager/balance/delete/(?P<item_id>\d+)/$', 'balanceitem_delete', name="manager_balanceitem_delete"),
    url(r'^manager/balance/$', 'balance', name="manager_balance"),
    url(r'^manager/export_order/', 'export_order', name='manager_export_orders'),
    url(r'^manager/', 'index', name='manager_index'),
    url(r'^manager_admin/', include(manager_admin_site.urls)),
)


urlpatterns += patterns('',
    (r'^rpc/$', 'rpc4django.views.serve_rpc_request'),
)
