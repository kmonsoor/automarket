from django.core.urlresolvers import reverse as _reverse
from django.http import Http404

def reverse(view_name, *args, **kwargs):
    return _reverse(view_name, args=args, kwargs=kwargs)

def redirect(request):
    """Get appropriate url for redirect"""
    reverse_url = request.META.get('HTTP_REFERER', '/')
    next = request.REQUEST.get('next','')
    if len(next) != 0:
        try:
            #::TODO:: - get a checking is this URL from our site
            reverse_url = next
        except:
            #Possibly hacker's attack
            raise Http404
    return reverse_url

def next(request):
    next = "%s%s%s" % (request.path, request.GET and "?" or "", "&".join(["%s=%s" % (i,j) for i,j in request.GET.items()]))
    return next