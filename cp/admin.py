# -*- coding=utf-8 -*-
from datetime import datetime

from django.contrib.auth.decorators import login_required
from django.contrib.admin.views.decorators import staff_member_required
from django.shortcuts import get_object_or_404
from django.http import Http404, HttpResponseRedirect

from lib.decorators import render_to, ajax_request
from lib.paginator import SimplePaginator
from lib.sort import SortHeaders
from lib.qs_filter import QSFilter
from lib.helpers import next

from data.models import *
from data.forms import OrderedItemsFilterForm, OrderedItemForm, InvoiceFilterForm, InvoiceForm, InvoiceItemForm


class PoForm():
    pass

@render_to('cp/admin/po.html')
@staff_member_required
@login_required
def po_tariff(request, po_id):
    po = get_object_or_404(Po, pk=po_id)
    return {'po':po}