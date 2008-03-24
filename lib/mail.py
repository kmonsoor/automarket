from django.core.mail import EmailMessage
#from django.core.mail import send_mail as _send_mail

def send_mail(*args, **kwargs):
    if kwargs.has_key('html') and kwargs['html'] == True:
        kwargs.pop('html')
        content_subtype = 'html'
    else:
        content_subtype = 'plain'
    msg = EmailMessage(*args, **kwargs)
    msg.content_subtype = content_subtype
    return msg.send(fail_silently=True)