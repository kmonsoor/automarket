from django.shortcuts import render_to_response

def index(request):
    response = {}
    return render_to_response('client/index.html', response)