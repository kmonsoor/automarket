# -*- coding=UTF-8 -*-
import datetime
from lib.decorators import render_to
from django.http import HttpResponseRedirect
from django.contrib.auth import login, logout, authenticate
from django.conf import settings
import re
import urllib
from decimal import Decimal
from common.forms import UserAuthForm
from data.models import *
from BeautifulSoup import BeautifulSoup, NavigableString


@render_to('common/start.html')
def start(request):
    message = ''
    if request.method == 'POST' :
        form = UserAuthForm(request.POST.copy())
        if form.is_valid() :
            user = authenticate(username=form.cleaned_data['username'], password=form.cleaned_data['password'])
            if user is not None:
                if user.is_active:
                    login(request, user)
                    # Staff goes to /cp/
                    if user.is_staff:
                        return HttpResponseRedirect('/cp/')
                    else :
                        return HttpResponseRedirect('/client/search/')
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
    finish += datetime.timedelta(hours=24)
    pitems = Invoice.objects.get_for_period(user,start,finish)
    bills = Bill.objects.get_for_period(user,start, finish)

    from lib.lists import sort_by_attr
    debet = sort_by_attr(pitems+bills, 'date')

    credit = Payment.objects.get_for_period(user,start,finish)


    #period_custom_bills
    return {'select_period_form':form,'user':user, 'debet':debet, 'credit':credit}


class PartSearch(object):

    SEARCH_URL = 'http://www.parts.com/oemcatalog/index.cfm?action=searchCatalogOEM'
    FORM_NAME = 'partnumberSearch'

    def get_make_options(self):
        """
        Returns makers in form [(id, name), ]
        """
        # TODO - grab from site and store in memcache
        return [("1","Acura"),
                ("2","Audi"),
                ("3","BMW"),
                ("4","Buick"),
                ("5","Cadillac"),
                ("6","Chevrolet/Geo"),
                ("7","Chrysler"),
                ("8","Dodge"),
                ("9","Eagle"),
                ("10","Ford"),
                ("11","GMC"),
                ("12","Honda"),
                ("1000","Hummer"),
                ("13","Hyundai"),
                ("14","Infiniti"),
                ("15","Isuzu"),
                ("16","Jaguar"),
                ("17","Jeep"),
                ("18","Kia"),
                ("19","Land Rover"),
                ("20","Lexus"),
                ("21","Lincoln"),
                ("22","Mazda"),
                ("67","Mercedes-Benz"),
                ("23","Mercury"),
                ("1001","MINI"),
                ("24","Mitsubishi"),
                ("25","Nissan"),
                ("26","Oldsmobile"),
                ("27","Plymouth"),
                ("28","Pontiac"),
                ("29","Porsche"),
                ("30","Saab"),
                ("31","Saturn"),
                ("37","Scion"),
                ("32","Subaru"),
                ("33","Suzuki"),
                ("34","Toyota"),
                ("35","Volkswagen"),
                ("36","Volvo"),]

    def get_maker_id(self, maker_string):
        try:
            return [x[0] for x in self.get_make_options() \
                     if x[1].lower() == maker_string.lower()][0]
        except IndexError:
            return None
        
    def get_maker_name(self, maker_id):
        try:
            return [x[1].lower() for x in self.get_make_options() \
                     if x[0] == str(maker_id)][0]
        except IndexError:
            return None

    def get_response(self, maker_id, partnumber):
        """
        Connects to the search page with params:
        @maker string Car maker name, i.e. `mazda` etc.
        @partnumber string Part number of a detail
        """

        params = urllib.urlencode({'Makeid': maker_id, \
                                   'partnumber': partnumber, \
                                   'searchAll': '1', \
                                   'SearchType': '1'})
        f = urllib.urlopen(self.SEARCH_URL, params)
        content = f.read()
        f.close()
        content = content.replace('\r','').replace('\n','')
        content = re.sub(r'>[ \t]*', r'>', content)
        content = re.sub(r'[ \t]*<', r'<', content)
        return content

    def parse_response(self, response):
        """
        Parse page for cost and returns dict
        """
        _s = r'<table width="100%" cellpadding="3" cellspacing="0" border="0">'
        parts = response.split(_s)
        parts = [x for x in parts if (">OEM Catalog<" in x and "Item Number" in x and "MSRP" in x)]
        p = None
        if len(parts):
            try:
                p = parts[0].split("</table>")[0]
            except Exception, mess:
                pass
        if p:
            p = "<table>%s</table>" % p
            bs = BeautifulSoup(p)
            t = bs.find(text=re.compile("OEM Catalog"))
            try:
                # data, description
                trs = t.findParent().findParent().findAllNext('tr')[1:3]
            except Exception, mess:
                trs = None
            if trs:
                _data = []
                for td in trs[0].findAll('td'):
                    _data.append(td.renderContents())
                fields = ['partnumber','MSRP','core_price', 'price']
                data = dict(zip(fields, _data))
                td_descr = trs[1].find('td', {'colspan':3})
                description = " ".join([t for t in td_descr.contents \
                          if type(t) is NavigableString])
                data['description'] = description
                for k, v in data.items():
                    if v.startswith('$'):
                        data[k] = v.strip('$')

                return data
        # If something goes wrong
        return None

    def search(self, maker_id, partnumber):
        if maker_id not in [x[0] for x in self.get_make_options()]:
            raise Exception('Invalid maker')
        response = self.get_response(maker_id, partnumber)
        return self.parse_response(response)
    

from SOAPpy import WSDL
class SoapClient(object):
    login = settings.SOAP_LOGIN
    pwd = settings.SOAP_PASSWORD
    wsdl = settings.WSDL_URL
    
    def __init__(*args,**kwargs):
        self.server = WSDL.Proxy(self.wsdl)
        
    def get_client_id(self):
        return self.server.getClientId(Login=self.login, Passwd=self.pwd)
    
    def get_invoice_list(self):
        return self.server.getCliengetInvoiceListtId({'login':self.login,'passwd':self.pwd})
    
    def insert_in_basket(self):
        pass

    def send_order(self):
        return self.server.sendOrder({'login':self.login,'passwd':self.pwd})
    