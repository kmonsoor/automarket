

import unittest
from common.views import PartSearch
from decimal import Decimal

class TestSearch(unittest.TestCase):

    def setUp(self):
        self.examples = [
            ('Mazda', 'ZZC0-27-238'),
            ('mazda', 'ZZCA-27-165'),
            ('Subaru', 'T3010YS010'),
            ('chrysler', '4892122AA'),
            ('chrysler', '5017921AA'),
            ('GM', '15285497'),
            ('GM', '15783970'),
            ('lexus', '53101-48271'),
            ('lexus', '87961-48520'),
        ]
        self.url = 'http://www.parts.com/oemcatalog/index.cfm?action=searchCatalogOEM'
        self.pns = PartSearch()

    def test_01_maker(self):
        assert "22" == self.pns.get_maker_id(self.examples[0][0]), \
            'Not equals %s,%s' % ("22",self.examples[0][0])
        assert "22" == self.pns.get_maker_id(self.examples[1][0]), \
            'Not equals %s,%s' % ("22",self.examples[1][0])
        assert None == self.pns.get_maker_id('qwefwefqwef')

    def test_02_response(self):
        ex = self.examples[0]
        maker_id = self.pns.get_maker_id(ex[0])
        response = self.pns.get_response(maker_id,ex[1])

        with open('common/tests/resp.txt','w') as a:
            a.write(response)

        assert "OEM Catalog" in response

    def test_03_parser_01(self):
        f = file('common/tests/resp.txt', 'r')
        response = f.read()
        f.close()
        res = self.pns.parse_response(response)

        assert res['partnumber'] != '', 'No part number'
        assert res['description'] != '', 'No description'
        assert res['MSRP'] == Decimal('17.15'), 'No MSRP'
        assert res['core_price'] == Decimal('0'), 'No core price'

