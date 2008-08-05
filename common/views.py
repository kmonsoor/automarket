# -*- coding=UTF-8 -*-

from lib.decorators import render_to
from django.http import HttpResponseRedirect
from django.contrib.auth import login, logout, authenticate
from django.conf import settings

from common.forms import UserAuthForm
from data.models import *

@render_to('common/start.html')
def start(request):
    message = ''
    if request.method == 'POST' :
        form = UserAuthForm(request.POST.copy())
        if form.is_valid() :
            user = authenticate(username=form.clean_data['username'], password=form.clean_data['password'])
            if user is not None:
                if user.is_active:
                    login(request, user)
                    # Staff goes to /cp/
                    if user.is_staff:
                        return HttpResponseRedirect('/cp/')
                    else :
                        return HttpResponseRedirect('/client/')
                else:
                    message = 'Ваша учетная запись временно отключена'
        else:
            message = 'Проверьте правильность ввода логина/пароля'
    form =  UserAuthForm()
    return {'form':form, 'message':message}


def exit(request):
    logout(request)
    return HttpResponseRedirect('/accounts/login/')
       
def show_balance(request, user=None):
    from common.forms import Selectperiod
    if not user:
        user = request.user
    if request.method == 'POST':
        # From / to form
        form = Selectperiod(request.POST.copy())
        if form.is_valid():
            start = form.cleaned_data['from_date']
            finish = form.cleaned_data['to_date']
    else:
        form = Selectperiod()
        start = form.fields['from_date'].initial
        finish = form.fields['to_date'].initial
    pitems = Invoice.objects.get_for_period(user,start,finish)
    bills = Bill.objects.get_for_period(user,start, finish)
    
    from lib.lists import sort_by_attr
    debet = sort_by_attr(pitems+bills, 'date')
    
    credit = Payment.objects.get_for_period(user,start,finish)
    
    
    #period_custom_bills
    return {'select_period_form':form,'user':user, 'debet':debet, 'creadit':credit}                  