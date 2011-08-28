# -*- coding=UTF-8 -*-
import datetime
from lib.decorators import render_to
from django.http import HttpResponseRedirect
from django.contrib.auth import login, logout, authenticate
from django.conf import settings
import re
import urllib
import mechanize
import urllib2
from decimal import Decimal
from common.forms import UserAuthForm
from data.models import *
from BeautifulSoup import BeautifulSoup, NavigableString
from SOAPpy import WSDL

import logging
log = logging.getLogger("common.views")

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


class PartSearchBase(object):
    BRAND_GROUP_TITLE = 'OEM'
    SEARCH_URL = None
    FORM_NAME = None

    def get_make_options(self):
        """
        Returns makers in form [(id, name), ]
        """
        return []

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



    def _sanitize_content(self, content=None):
        if not content:
            return ''
        content = content.replace('\r','').replace('\n','')
        content = re.sub(r'>[ \t]*', r'>', content)
        content = re.sub(r'[ \t]*<', r'<', content)
        return content

    def get_response(self, maker_id, partnumber):
        return self._sanitize_content(self.get_response_mechanize(maker_id, partnumber))

    def parse_response(self):
        raise NotImplementedError


    def search(self, maker_id, partnumber):
        if maker_id not in [x[0] for x in self.get_make_options()]:
            raise Exception('Invalid maker')

        response = self.get_response(maker_id, partnumber)
        data = self.parse_response(response)
        if not data:
            return None
        data.update({'brandname':self.get_maker_name(maker_id)})
        return data

class PartSearchPartsCom(PartSearchBase):
    name = "parts.com"
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

    def get_response_urllib(self, maker_id, partnumber):
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
        return content

    def get_response_mechanize(self, maker_id, partnumber):
        browser = mechanize.Browser()
        params = urllib.urlencode({'Makeid': maker_id, \
                                   'partnumber': partnumber, \

                                   'searchAll': '1', \
                                   'SearchType': '1'})
        headers = {"User-Agent": "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.8) Gecko/20100722 Firefox/3.6.8 GTB7.1 (.NET CLR 3.5.30729)",
        "Referer": "http://www.parts.com"}
        request = urllib2.Request(self.SEARCH_URL, params, headers)
        response = browser.open(request, timeout=120.0)
        content = response.read()
        browser.close()
        return content

    def parse_response(self, response):
        """
        Parse page for cost and returns dict
        """
        _s = r'<table width="100%" cellpadding="3" cellspacing="0" border="0">'
        parts = response.split(_s)
        parts = [x for x in parts \
                   if (">OEM Catalog<" in x \
                                    and "Item Number" in x and "MSRP" in x)]
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

class PartSearchAutopartspeople(PartSearchBase):
    name = "autopartspeople"

    SEARCH_URL = 'http://www.partswebsite.com/autopartspeople/index.php?i=2&type=parts&partnum=accept'
    FORM_NAME = 'searchfrm'

    def get_make_options(self):
        return [
         ('109', 'Acura'),
         ('112', 'Audi'),
         ('114', 'Buick'),
         ('115', 'Cadillac'),
         ('116', 'Chevrolet'),
         ('117', 'Chrysler'),
         ('120', 'Dodge'),
         ('117', "Eagle"), # = Chrysler
         ('123', 'Ford'),
         ('125', 'GMC'),
         ('160', 'Hummer'),
         ('127', 'Hyundai'),
         ('128', 'Infiniti'),
         ('131', 'Jeep'),
         ('132', 'Kia'),
         ('135', 'Lincoln'),
         ('136', 'Mazda'),
         ('138', 'Mercury'),
         ('141', 'Mitsubishi'),
         ('142', 'Nissan'),
         ('143', 'Oldsmobile'),
         ('146', 'Pontiac'),
         ('117', "Plymouth"), # = Chrysler
         ('149', 'Saab'),
         ('150', 'Saturn'),
         ('151', 'Scion'),
         ('153', 'Subaru'),
         ('154', 'Suzuki'),
         ('155', 'Toyota'),
         ('157', 'Volkswagen'),
         ('158', 'Volvo')
        ]



    def get_response_mechanize(self, maker_id, part_number):
        browser = mechanize.Browser()
        params = urllib.urlencode(
            {'model': 'model',
            'searchpart': part_number,
            'searchsub': "Search",
            'section': "section",
            'srch_make_id':	maker_id,
            'year':	"year"})

        headers = {"User-Agent": "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.8) Gecko/20100722 Firefox/3.6.8 GTB7.1 (.NET CLR 3.5.30729)",
        "Referer": "http://www.partswebsite.com"}
        request = urllib2.Request(self.SEARCH_URL, params, headers)
        response = browser.open(request, timeout=120.0)
        content = response.read()
        browser.close()

        return content

    def parse_response(self, response):
        if "No Items Found Please Try Again or Search by Categories." in response:
            return None
        bs = BeautifulSoup(response)
        def find_price_by_label(label):
            s1 = bs.find("span", {'class': "vb10b"}, text=re.compile(label))
            if s1:
                s2 = str(s1.findNext('span', text=re.compile("\$?")))
                try:
                    return float(s2.lstrip("$"))
                except (ValueError, AttributeError), e:
                    return None
        def find_description():
            d,p = "",""
            s1 = bs.find("span", {'class': "vb10b"}, text=re.compile("Part#"))
            if s1:
                dr = re.compile(r'^(.*)\[(?:New\s)?Part\#\s?([\w\d]+)\]$')
                try:
                    d,p = [str(x) for x in dr.findall(s1)[0]]
                except (AttributeError, IndexError, ValueError):
                    pass
            return d,p
        description, partnumber = find_description()
        return {
            'MSRP': find_price_by_label("List Price:"),
            'core': find_price_by_label("Core Price:"),
            'description': description,
            'partnumber': partnumber
        }

        # Find core price


class PartSearch(object):

    _search_registry = [PartSearchAutopartspeople, PartSearchPartsCom]
    makers = [
        "Acura",
        "Audi",
        "BMW",
        "Buick",
        "Cadillac"
        "Chevrolet/Geo",
        "Chrysler",
        "Dodge",
        "Eagle",
        "Ford",
        "GMC",
        "Honda",
        "Hummer",
        "Hyundai",
        "Infiniti",
        "Isuzu",
        "Jaguar",
        "Jeep",
        "Kia",
        "LandRover",
        "Lexus",
        "Lincoln",
        "Mazda",
        "Mercedes-Benz",
        "Mercury",
        "MINI",
        "Mitsubishi",
        "Nissan",
        "Oldsmobile",
        "Plymouth",
        "Pontiac",
        "Porsche",
        "Saab",
        "Saturn",
        "Scion",
        "Subaru",
        "Suzuki",
        "Toyota",
        "Volkswagen",
        "Volvo"
        ]

    def maker_choices(self):
        return [('', '----')] + [(x,x) for x in self.makers]

    def get_search_handler(self, maker_name):
        for search_class in self._search_registry:
            s = search_class()
            maker_names = [x[1] for x in s.get_make_options()]
            if maker_name in maker_names:
                return s
        return None

    def search(self, maker_name, part_number):
        handler = self.get_search_handler(maker_name)
        maker_id = handler.get_maker_id(maker_name)
        try:
            return handler.search(maker_id, part_number)
        except Exception, e:
            log.exception("Search in %s returned an error %r" % \
                (handler.__class__.__name__, e))
        return None




import SOAPpy
class SoapClient(object):
    login = settings.SOAP_LOGIN
    pwd = settings.SOAP_PASSWORD
    wsdl = settings.WSDL_URL
    user_param = {'login':login,'passwd':pwd}


    def __init__(self, *args, **kwargs):
        if 'login' in kwargs and kwargs['login']\
           and 'pwd' in  kwargs and kwargs['pwd']:
            self.login = kwargs['login']
            self.pwd = kwargs['pwd']

        self.server = WSDL.Proxy(self.wsdl)
        SOAPpy.Config.debug = 1
        #SOAPpy.Config.dict_encoding = 'cp1251'

    # test function
    def get_invoice_list(self):
        print self.server.getInvoiceList(self.user_param)


    def insert_in_basket(self, orders):
        data = []
        for order in orders:
            if order.brandgroup.add_brand_to_comment\
                   and order.brandgroup.direction.title == 'US':
                comment_supplier = u'%s  %s' % (order.comment_supplier, order.brand.title)
            else:
                comment_supplier = order.comment_supplier

            detail = {
                'Brand': order.area.title,
                'Coment': comment_supplier,
                'Description': order.description_ru,
                'DescriptionEng': order.description_en,
                'Qty': order.quantity,
                'OemCode': order.part_number,
                'CustomerId': '',
                'Weight': order.weight if order.weight else '',
            }
            data.append(detail)

        try:
            code,res = 0, self.server.insertBasket(PartsArray = data, UserParam = self.user_param)
        except:
            code, res = 500, None

        return [code, res]


    def get_client_id(self):
        try:
            code, res = 0, self.server.getClientId(Login=self.login, Passwd=self.pwd)
        except:
            code, res = 500, None

        return [code, res]


    def send_order(self):
        try:
            code, res =  0, self.server.sendOrder(self.user_param)
        except:
            code, res = 500, None

        return [code, res]

