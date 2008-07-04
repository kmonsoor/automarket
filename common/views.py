# -*- coding=UTF-8 -*-

from lib.decorators import render_to
from django.http import HttpResponseRedirect
from django.contrib.auth import login, logout, authenticate
from django.conf import settings

from common.forms import UserAuthForm

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
       
                