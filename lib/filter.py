# -*- coding:utf-8 -*-
from datetime import datetime
from django import template
from django import newforms as forms
from django.newforms import form_for_model

class Filter(object):
    def __init__(self, request, model, fields):
        #print request.POST
        filter = request.session.get('filter', None)
        if request.POST.has_key('filter'):
            if request.POST.get('clear_filter', None) and filter:
                del request.session['filter']
            else:    
                request.session['filter'] = {'contents':request.POST, 'page':request.META['PATH_INFO']}
                request.session.modified = True
             
        else:
            if filter and filter['page'] != request.META['PATH_INFO']:
                del request.session['filter']
                request.session.modified = True
                
        filter = request.session.get('filter', None)
        if filter:    
            self.contents = request.session['filter']['contents']
        else:
            self.contents = {}
            
        self.model = model
        self.fields = fields
        
        #print "con=%s" % self.contents
        
    def render_char(self, item):
        value = self.contents.get(item['name'], '')
        html = '<div>%s</div><input name="%s" value="%s"><br>' % (item['verbose'], item['name'], value)
        return html
    
    def render_year(self, item):
        value = self.contents.get(item['name'], '')
        html = '<div>%s</div><input name="%s" value="%s"><br>' % (item['verbose'], item['name'], value)
        return html
        
    def render_select(self, item):
        value = self.contents.get(item['name'], '')
        html = u'<div>%s</div><select name="%s"><option value=""></option>' % (item['verbose'], item['name'])
        for i in item['choices']:
            html += u'<option value="%s"%s>%s</option>' % (i[0], i[0]==value and u' selected' or u'', i[1])
        html += u"</select>"
        return html
               
    def render(self):
        t = template.loader.get_template('lib/filter.html')
        data = []
        for i in self.fields:
            data.append(getattr(self, "render_%s" % i['type'])(i))

        return t.render(template.Context({'form':data}))
    
    def get_filter_char(self, data, item, value):
        if value:
            data["%s__contains" % item['name']] = value
        return data
    
    def get_filter_select(self, data, item, value):
        if value:
            data[item['name']] = value
        return data
    
    def get_filter_year(self, data, item, value): 
#===============================================================================
#        try:
#            date = datetime(year=value)
#        except:
#            return data      
#===============================================================================
        data["%s__year" % item['name']] = value
        return data
        

    def get_filters(self):
        data = {}
        for i in self.fields:
            if i['name'] in self.contents:
                data = getattr(self, "get_filter_%s" % i['type'])(data, i, self.contents[i['name']])
        return data
                
            
        
        