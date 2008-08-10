from django.conf import settings

def media_url(request):
    from django.conf import settings
    return {'MEDIA_URL': settings.MEDIA_URL}

def next(request):
    from lib.helpers import next
    next_url = request.GET.get('next',None) or next(request)
    return {'next':next_url}
        