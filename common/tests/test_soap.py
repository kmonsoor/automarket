
import os
import sys
sys.path.insert(0, '/home/wc/projects/automoto/lib/python2.6/site-packages')
sys.path.insert(0, os.path.abspath('.'))
sys.path.insert(0, os.path.abspath('..'))
import logging
import subprocess
LOG_FILENAME = 'suds.log'
logging.basicConfig(filename=LOG_FILENAME,level=logging.DEBUG)
import cjson
os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'

from common.views import SoapClient
from django.conf import settings

from unittest import TestCase

class TestSoap(TestCase):
    def setUp(self):
        self.client = SoapClient()

    def _test_01_invoice_list(self):
        self.client.get_invoice_list()

    def _test_02_suds_invoice_list(self):
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
    
    def test_03_phpclient(self):
        script_path = os.path.join(settings.PROJECT_ROOT, 'soapclient.php')
        arg1 = cjson.encode({'login':settings.SOAP_LOGIN, 'passwd':settings.SOAP_PASSWORD})
        cmd = "php -f %s %s '%s'" % (script_path, 'getInvoiceList', arg1)
        f = os.popen(cmd)
        data = cjson.decode(f.read())
        f.close()
        self.assertEquals(data['ok'], True)
        self.assertEquals(type(data['response']), type(list()))
    
    def test_04_phpclient_error(self):
        script_path = os.path.join(settings.PROJECT_ROOT, 'soapclient.php')
        cmd = "php -f %s abracadabra" % script_path
        f = os.popen(cmd)
        data = cjson.decode(f.read())
        f.close()
        self.assertEquals(data['ok'], False)

