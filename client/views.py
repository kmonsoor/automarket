from django.shortcuts import render_to_response

def index(request):
    response = {}
    response['current_action'] = 'index'
    return render_to_response('client/index.html', response)