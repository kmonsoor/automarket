# -*- coding=UTF-8 -*-
import base64
try:
    from functools import wraps
except ImportError:
    from django.utils.functional import wraps  # Python 2.4 fallback.

from django import http, template
from django.core.urlresolvers import reverse
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login
from django.shortcuts import render_to_response
from django.utils.translation import ugettext_lazy, ugettext as _

from data.models import *

ERROR_MESSAGE = ugettext_lazy("Please enter a correct username and password. Note that both fields are case-sensitive.")
LOGIN_FORM_KEY = 'this_is_the_login_form'


def _display_login_form(request, error_message=''):
    request.session.set_test_cookie()
    return render_to_response('admin/login.html', {
        'title': _('Log in'),
        'app_path': request.get_full_path(),
        'error_message': error_message
    }, context_instance=template.RequestContext(request))


def _is_manager(user):
    try:
        user_profile = UserProfile.objects.get(user=user)
    except:
        return False
    else:
        return user_profile.is_manager


def manager_required(view_func):

    def _checklogin(request, *args, **kwargs):
        if request.user.is_active and not request.user.is_staff and _is_manager(request.user):
            return view_func(request, *args, **kwargs)

        if request.user.is_active and request.user.is_staff:
            return http.HttpResponseRedirect(reverse('admin:index'))

        assert hasattr(request, 'session'), "The Django admin requires session middleware to be installed. Edit your MIDDLEWARE_CLASSES setting to insert 'django.contrib.sessions.middleware.SessionMiddleware'."

        # If this isn't already the login page, display it.
        if LOGIN_FORM_KEY not in request.POST:
            if request.POST:
                message = _("Please log in again, because your session has expired.")
            else:
                message = ""
            return _display_login_form(request, message)

        # Check that the user accepts cookies.
        if not request.session.test_cookie_worked():
            message = _("Looks like your browser isn't configured to accept cookies. Please enable cookies, reload this page, and try again.")
            return _display_login_form(request, message)
        else:
            request.session.delete_test_cookie()

        # Check the password.
        username = request.POST.get('username', None)
        password = request.POST.get('password', None)
        user = authenticate(username=username, password=password)
        if user is None:
            message = ERROR_MESSAGE
            if '@' in username:
                # Mistakenly entered e-mail address instead of username? Look it up.
                users = list(User.objects.filter(email=username))
                if len(users) == 1 and users[0].check_password(password):
                    message = _("Your e-mail address is not your username. Try '%s' instead.") % users[0].username
            return _display_login_form(request, message)

        # The user data is correct; log in the user in and continue.
        else:
            if user.is_active and not user.is_staff:
                login(request, user)
                if _is_manager(request.user):
                    return http.HttpResponseRedirect(request.get_full_path())
                else:
                    _display_login_form(request, ERROR_MESSAGE)
            else:
                return _display_login_form(request, ERROR_MESSAGE)

    return wraps(view_func)(_checklogin)