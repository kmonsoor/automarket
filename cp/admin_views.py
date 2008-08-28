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


@render_to('cp/admin/po.html')
@staff_member_required
@login_required
def po_tarif(request, po_id):
    po = get_object_or_404(Po, pk=po_id)
    tarif = Tarif.objects.get(po=po)
    if request.method == 'POST':
        post = request.POST.copy()
        del(post['submit'])
        # Update Tarif default
        default_value = post.pop('default_value')[0]
        tarif.default_value = default_value or 1
        tarif.save()
        # Update TarifClass
        for id, value in post.items():
            tc = TarifClass.objects.get(pk=id)
            tc.value = value or 1
            tc.save()
    tcs = TarifClass.objects.filter(tarif=tarif)
    return {'po':po, 'tcs':tcs, 'tarif':tarif}