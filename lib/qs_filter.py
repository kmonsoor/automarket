# -*- coding:utf-8 -*-
from django.template import loader, Context  

class QSFilter(object):
    
    template = 'lib/qsfilter/filter.html'
    modified = False
    is_set = False
    
    def __init__(self, request, form, use_session=True):
        self.use_session = use_session
        self.method = self.use_session and 'post' or 'get'
        self.data = self.process_request(request)         
        if self.data:
            self.form = form(self.data)
        else:
            self.form = form()           
            
    def process_request(self, request):
        if request.REQUEST.has_key('qs_filter_clear'):
            self.clear_session(request)
            self.modified = True
            self.is_set = False
            return None
        if request.REQUEST.has_key('qs_filter'):
            data = dict(getattr(request, request.method).items())
            if self.use_session:
                request.session['qs_filter'] = {'data':data,'path':request.path}
            self.modified = True
            self.is_set = True
            return data          
        elif self.use_session:
            data = request.session.get('qs_filter', None)
            if data:
                if data['path'] != request.path:
                    self.clear_session(request)
                    return None
                self.is_set = True
                return data['data']
            return None
                
    def clear_session(self, request):
        if request.session.get('qs_filter', None):
            del request.session['qs_filter']

    def get_filters(self):
        if self.form.is_valid():
            data = {}
            for k, v in self.form.clean_data.items():
                if v:
                    data.update({k:v})
            return data
        return {}
    
    def render(self):
        template = loader.get_template(self.template)
        return template.render(Context({
                                        'form':self.form,
                                        'method':self.method,
                                        }))
    def get_query_string(self):
        if self.form.is_valid():
            data = []
            for k, v in self.form.cleaned_data.items():
                v = v or ''
                data.append("%s=%s" % (k, v)) 
            str = '&'.join(data)  
            return str
        else:
            return ''
          
    def __unicode__(self):
        return self.render()
    
    def __str__(self):
        return self.render()
    