# -*- coding=UTF-8 -*-

import mechanize
import re
import requests
import urllib
import urllib2
import xml.etree.ElementTree as et
from BeautifulSoup import BeautifulSoup, NavigableString

from django.http import HttpResponseRedirect
from django.contrib.auth import login, logout, authenticate
from django.core.urlresolvers import reverse

from lib.decorators import render_to


import logging
log = logging.getLogger("common.views")


def is_manager(user):
    from data.models import UserProfile
    try:
        user_profile = UserProfile.objects.get(user=user)
    except UserProfile.DoesNotExist:
        return False
    else:
        return user_profile.is_manager


@render_to('common/start.html')
def start(request):

    from common.forms import UserAuthForm
    message = ''

    if request.user.is_active and request.user.is_authenticated():
        if request.user.is_staff:
            redirect_url = reverse('cp_index')
        elif is_manager(request.user):
            redirect_url = reverse('manager_index')
        else:
            redirect_url = reverse('client_search')
        return HttpResponseRedirect(redirect_url)

    if request.method == 'POST':
        form = UserAuthForm(request.POST.copy())
        if form.is_valid():
            user = authenticate(
                username=form.cleaned_data['username'],
                password=form.cleaned_data['password'])

            if user is not None:
                if user.is_active:
                    login(request, user)
                    if user.is_staff:
                        return HttpResponseRedirect(reverse('cp_index'))
                    elif is_manager(user):
                        return HttpResponseRedirect(reverse('manager_index'))
                    else:
                        return HttpResponseRedirect(reverse('client_search'))
                else:
                    message = 'Ваша учетная запись временно отключена'
        else:
            message = 'Проверьте правильность ввода логина/пароля'
    form = UserAuthForm()
    return {'form': form, 'message': message}


def exit(request):
    logout(request)
    return HttpResponseRedirect('/accounts/login/')


class PartSearchBase(object):
    BRAND_GROUP_TITLE = 'OEM'
    SEARCH_URL = None
    FORM_NAME = None

    def get_make_options(self):
        return []

    def get_maker_id(self, maker_string):
        try:
            return [
                x[0] for x in self.get_make_options()
                if x[1].lower() == maker_string.lower()
            ][0]
        except IndexError:
            return None

    def get_maker_name(self, maker_id):
        try:
            return [
                x[1] for x in self.get_make_options()
                if x[0] == str(maker_id)
            ][0]
        except IndexError:
            return None

    def _sanitize_content(self, content=None):
        if not content:
            return ''
        content = content.replace('\r', '').replace('\n', '')
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

        data.update({
            'brandname': self.get_maker_name(maker_id),
            'maker': self.get_maker_name(maker_id),
            'brandgroup': "OEM",
            'description_ru': None,
            'cost': None,
            'party': None,
            'sub_chain': None,
        })

        return [data]


class PartSearchPartsCom(PartSearchBase):
    name = "parts.com"
    SEARCH_URL = 'http://www.parts.com/oemcatalog/index.cfm?action=searchCatalogOEM'
    FORM_NAME = 'partnumberSearch'

    def get_make_options(self):
        """
        Returns makers in form [(id, name), ]
        """
        # TODO - grab from site and store in memcache
        return [
            ("1", "Acura"),
            ("2", "Audi"),
            ("3", "BMW"),
            ("4", "Buick"),
            ("5", "Cadillac"),
            ("6", "Chevrolet"),
            ("6", "Geo"),  # = Chevrolet
            ("7", "Chrysler"),
            ("8", "Dodge"),
            ("9", "Eagle"),
            ("10", "Ford"),
            ("11", "GMC"),
            ("12", "Honda"),
            ("1000", "Hummer"),
            ("13", "Hyundai"),
            ("14", "Infiniti"),
            ("15", "Isuzu"),
            ("16", "Jaguar"),
            ("17", "Jeep"),
            ("18", "Kia"),
            ("19", "Land Rover"),
            ("20", "Lexus"),
            ("21", "Lincoln"),
            ("22", "Mazda"),
            ("67", "Mercedes-Benz"),
            ("23", "Mercury"),
            ("1001", "MINI"),
            ("24", "Mitsubishi"),
            ("25", "Nissan"),
            ("26", "Oldsmobile"),
            ("27", "Plymouth"),
            ("28", "Pontiac"),
            ("29", "Porsche"),
            ("30", "Saab"),
            ("31", "Saturn"),
            ("37", "Scion"),
            ("32", "Subaru"),
            ("33", "Suzuki"),
            ("34", "Toyota"),
            ("35", "Volkswagen"),
            ("36", "Volvo"),
        ]

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
            except Exception:
                pass
        if p:
            p = "<table>%s</table>" % p
            bs = BeautifulSoup(p)
            t = bs.find(text=re.compile("OEM Catalog"))
            try:
                # data, description
                trs = t.findParent().findParent().findAllNext('tr')[1:3]
            except Exception:
                trs = None
            if trs:
                _data = []
                for td in trs[0].findAll('td'):
                    _data.append(td.renderContents())

                fields = ['partnumber', 'MSRP', 'core_price', 'price']
                data = dict(zip(fields, _data))
                td_descr = trs[1].find('td', {'colspan': 3})
                description = " ".join(
                    t for t in td_descr.contents
                    if type(t) is NavigableString)
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
         ('117', "Eagle"),  # = Chrysler
         ('123', 'Ford'),
         ('116', 'Geo'),  # = Chevrolet
         ('125', 'GMC'),
         ('126', 'Honda'),
         ('160', 'Hummer'),
         ('127', 'Hyundai'),
         ('131', 'Jeep'),
         ('132', 'Kia'),
         ('135', 'Lincoln'),
         ('136', 'Mazda'),
         ('137', 'Mercedes Benz'),
         ('138', 'Mercury'),
         ('141', 'Mitsubishi'),
         ('142', 'Nissan'),
         ('143', 'Oldsmobile'),
         ('146', 'Pontiac'),
         ('117', "Plymouth"),  # = Chrysler
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
                except (ValueError, AttributeError):
                    return None

        def find_description():
            d, p = "", ""
            s1 = bs.find("span", {'class': "vb10b"}, text=re.compile("\\[Part#"))
            if not s1:
                s1 = bs.find("span", {'class': "vb10b"}, text=re.compile("\\[New Part#"))
            if s1:
                dr = re.compile(r'^(.*)\[(?:New\s)?Part\#\s?([\w\d]+)\]$')
                try:
                    d, p = [str(x) for x in dr.findall(s1)[0]]
                except (AttributeError, IndexError, ValueError):
                    pass
            return d, p
        description, partnumber = find_description()
        return {
            'MSRP': find_price_by_label("List Price:"),
            'core_price': find_price_by_label("Core Price:"),
            'description': description,
            'partnumber': partnumber
        }


class PartSearchTradeMotionCom(PartSearchBase):
    name = "trademotion.com"
    SEARCH_URL = 'http://www.trademotion.com/parts/index.cfm'
    FORM_NAME = 'partSearch'
    SITE_ID = 214281

    def get_make_options(self):
        """
        Returns makers in form [(id, name), ]
        """
        # TODO - grab from site and store in memcache
        return [("Lexus", "Lexus")]

    def get_response_urllib(self, maker_id, partnumber):
        """
        Connects to the search page with params:

        @maker string Car maker name, i.e. `mazda` etc.
        @partnumber string Part number of a detail
        """
        params = urllib.urlencode({'make': maker_id, \
                                   'searchText': partnumber, \
                                   'siteid': self.SITE_ID, \
                                   'action': 'oePartSearch'})
        f = urllib.urlopen(self.SEARCH_URL, params)
        content = f.read()
        f.close()
        return content

    def get_response_mechanize(self, maker_id, partnumber):
        browser = mechanize.Browser()
        params = urllib.urlencode({'make': maker_id, \
                                   'searchText': partnumber, \
                                   'siteid': self.SITE_ID, \
                                   'action': 'oePartSearch'})
        headers = {"User-Agent": "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.8) Gecko/20100722 Firefox/3.6.8 GTB7.1 (.NET CLR 3.5.30729)",
        "Referer": "http://www.trademotion.com"}
        request = urllib2.Request(self.SEARCH_URL, params, headers)
        response = browser.open(request, timeout=120.0)
        content = response.read()
        browser.close()
        return content

    def parse_response(self, response):
        """
        Parse page for cost and returns dict
        """
        _s = r'<table cellpadding="5" cellspacing="0" border="0" width="100%" align="center">'
        parts = response.split(_s)
        parts = [x for x in parts \
                   if ("Quick Order" in x \
                       and ">Core<" in x \
                       and ">Online Price<" in x)]
        p = None
        if len(parts):
            try:
                p = parts[0].split("</table>")[0]
                p = p.split('<form name="basepart"')[0]
            except Exception:
                pass
        if p:
            p = "<table>%s</table>" % p
            bs = BeautifulSoup(p)

            def get_price_by_label(label):
                s1 = bs.find("tr", text=re.compile(label))
                if s1:
                    s2 = s1.findParent().findNext('td')\
                        .find('b').renderContents()
                    try:
                        return float(s2.lstrip("$"))
                    except (ValueError, AttributeError):
                        return None

            def get_content_by_label(label):
                s1 = bs.find("tr", text=re.compile(label))
                if s1:
                    s2 = s1.findParent().findNext('td').renderContents()
                    return s2

            return {
                'MSRP': get_price_by_label("Online Price"),
                'core_price': get_price_by_label("Core"),
                'description': get_content_by_label("Part Name"),
                'partnumber': get_content_by_label("Part Number")
            }
        # If something goes wrong
        return None


class PartSearchInfinitiPartsOnlineCom(PartSearchTradeMotionCom):
    name = "infinitipartsonline.com"
    SEARCH_URL = 'http://www.infinitipartsonline.com/parts/index.cfm'
    FORM_NAME = 'partSearch'
    SITE_ID = 214952

    def get_make_options(self):
        return [("Infiniti", "Infiniti")]


class PartSearchPorscheOEMPartsCom(PartSearchTradeMotionCom):
    name = "porscheoemparts.com"
    SEARCH_URL = 'http://www.porscheoemparts.com/parts/index.cfm'
    FORM_NAME = 'partSearch'
    SITE_ID = 215405

    def get_make_options(self):
        return [("Porsche", "Porsche")]

    def parse_response(self, response):
        """
        Parse page for cost and returns dict
        """
        _s = r'<table cellpadding="5" cellspacing="0" border="0" width="100%" align="center">'
        parts = response.split(_s)
        parts = [x for x in parts \
                   if ("Quick Order" in x \
                       and ">Core<" in x \
                       and ">Online Price<" in x)]
        p = None
        if len(parts):
            try:
                p = parts[0].split("</table>")[0]
                p = p.split('<form name="basepart"')[0]
            except Exception:
                pass
        if p:
            p = "<table>%s</table>" % p
            bs = BeautifulSoup(p)

            def get_price_by_label(label):
                s1 = bs.find("tr", text=re.compile(label))
                if s1:
                    s2 = s1.findParent().findNext('td')\
                        .find('b').renderContents()
                    try:
                        return float(s2.lstrip("$"))
                    except (ValueError, AttributeError):
                        return None

            def get_content_by_label(label):
                s1 = bs.find("tr", text=re.compile(label))
                if s1:
                    s2 = s1.findParent().findNext('td').renderContents()
                    return s2

            return {
                'MSRP': get_price_by_label("MSRP"),
                'core_price': get_price_by_label("Core"),
                'description': get_content_by_label("Part Name"),
                'partnumber': get_content_by_label("Part Number")
            }
        # If something goes wrong
        return None


class PartSearchRockAuto(object):

    @classmethod
    def search(cls, maker, partnumber, only_coincedences=True):

        uri = 'http://www.rockauto.com/catalog/catalogxml.php'
        headers = {
            'X-Requested-With': 'XMLHttpRequest',
            'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/31.0.1650.63 Chrome/31.0.1650.63 Safari/537.36',
            'Referer': 'http://www.rockauto.com/catalog/searchresults.php',
            'Origin': 'http://www.rockauto.com',
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Connection': 'keep-alive',
            'Accept-Language': 'en-US,en;q=0.8,ru;q=0.6,pl;q=0.4,de;q=0.2',
            'Accept': '*/*',
            'Accept-Encoding': 'gzip,deflate,sdch',
            'Host': 'www.rockauto.com',
        }
        data = {
            'func': 'partsearch',
            'searchtext': partnumber,
            '': '',
        }
        resp = requests.post(uri, data=data, headers=headers)
        resp.raise_for_status()

        analogs = list()
        root = et.fromstring(resp.content)
        parts = list(root.getiterator('part'))

        makers = set()
        for part in parts:
            if only_coincedences and part.attrib['pn'] != partnumber:
                continue
            makers.add(part.attrib['cat'].capitalize())

        if not maker and only_coincedences and len(makers) > 1:
            for m in sorted(makers):
                analogs.append({
                    'brandname': 'Rockauto',
                    'brandgroup': 'AFTMARK',
                    'maker': m,
                })
            return analogs

        session = requests.Session()

        for part in parts:

            if only_coincedences and part.attrib['pn'] != partnumber:
                continue

            if maker and part.attrib['cat'].lower() != maker.lower():
                continue

            if int(list(part.getiterator('partoptions'))[0].attrib['type']) == 1:
                # need choose color, size etc.
                continue

            for option in part.getiterator('option'):
                if option.attrib.get('warehouse'):
                    break

            if float(option.attrib['total']) == 0:
                # out of stock
                # need choose size, color etc.
                continue

            data = {
                'func': 'add',
                'parttype': part.attrib['parttype'],
                'partkey[0]': part.attrib['partkey'],
                'carcode': '0',
                'warehouse[0]': option.attrib['warehouse'],
                'whpartnum[0]': option.attrib['whpartnum'],
                'notekey[0]': option.attrib['notekey'],
                'multiple[0]': option.attrib['multiple'],
                'optionlist[0]': option.attrib['type'],
                'optionchoice[0]': option.attrib['value'],
                '': '',
            }
            resp = session.post(uri, data=data, headers=headers)
            resp.raise_for_status()

            data = {
                'func': 'setdest',
                'country': 'US',
                'zipcode': '11220',
                '': '',
            }
            resp = session.post(uri, data=data, headers=headers)
            resp.raise_for_status()

            basket = et.fromstring(resp.content)
            bpart = list(basket.getiterator('part'))[0]

            total = list(basket.getiterator('total'))[0]
            parttype = list(basket.getiterator('parttype'))[0]

            core_price = float(bpart.attrib['core'])
            msrp = float(total.attrib['cost']) - core_price

            analogs.append({
                'partnumber': str(bpart.attrib['pn']),
                'MSRP': msrp,
                'core_price': core_price,
                'description': str(parttype.attrib['description'].split(':')[-1].strip()),
                'description_ru': '',
                'sub_chain': '',
                'cost': float(total.attrib['cost']),
                'brandname': 'Rockauto',
                'brandgroup': 'AFTMARK',
                'party': 1,
                'available': None,
                'maker': str(bpart.attrib['cat'].capitalize()),
            })

            for el in basket.getiterator('othercart'):
                data = {
                    'func': 'delcart',
                    'cartid': el.attrib['id'],
                    '': '',
                }
                resp = session.post(uri, data=data, headers=headers)
                resp.raise_for_status()

        return analogs
                

class PartSearch(object):

    _search_registry = [
        PartSearchAutopartspeople,
        # PartSearchRockAuto,
        # PartSearchTradeMotionCom,
        # PartSearchInfinitiPartsOnlineCom,
        # PartSearchPorscheOEMPartsCom,
        # PartSearchPartsCom,
    ]

    makers = [
        "Acura",
        "Audi",
        "BMW",
        "Buick",
        "Cadillac",
        "Chevrolet",
        "Chrysler",
        "Dodge",
        "Eagle",
        "Ford",
        "Geo",
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
        return [('', '----')] + [(x, x) for x in self.makers]

    def search(self, maker_name, part_number):

        def iterate_registry():
            for search_class in self._search_registry:
                yield search_class

        reg_iterator = iterate_registry()

        def _make_search():
            try:
                s = reg_iterator.next()
            except StopIteration:
                return None
            handler = s()
            maker_names = [x[1] for x in handler.get_make_options()]
            if not maker_name in maker_names:
                return _make_search()
            maker_id = handler.get_maker_id(maker_name)
            try:
                data = handler.search(maker_id, part_number)
            except Exception, e:
                log.exception("Search in %s returned an error %r" % \
                    (handler.__class__.__name__, e))
                data = None
            else:
                if data:
                    return data
            return _make_search()

        found = _make_search()
        return found
