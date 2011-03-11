
import os
import sys
sys.path.insert(0, '/home/wc/projects/automoto/lib/python2.6/site-packages')
sys.path.insert(0, os.path.abspath('.'))
sys.path.insert(0, os.path.abspath('..'))
import logging

LOG_FILENAME = 'suds.log'
logging.basicConfig(filename=LOG_FILENAME,level=logging.DEBUG)

os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'

from common.views import SoapClient


from unittest import TestCase

class TestSoap(TestCase):
    def setUp(self):
        self.client = SoapClient()

    def _test_01_invoice_list(self):
        self.client.get_invoice_list()

    def test_02_suds_invoice_list(self):
        from django.conf import settings
        url = settings.WSDL_URL
        from suds.xsd.doctor import ImportDoctor, Import
        import suds
        imp = Import('http://schemas.xmlsoap.org/soap/encoding/')
        imp.filter.add('http://automototrade.com/wsdl/server.php')
        d = ImportDoctor(imp)
        client = suds.client.Client(url,
                                    headers = {'Content-Type': 'text/xml; charset=cp1251'},
                                    location=url,
                                    doctor=d)
        print dir(client)
        UserParam = client.factory.create('Array')
        UserParam['login'] = "SM"
        UserParam['password'] = "newparts"
        res = client.service.getInvoiceList()

