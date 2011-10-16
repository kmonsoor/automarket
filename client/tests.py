from django.utils.unittest import TestCase
from django.test.client import Client
from data.models import *
from django.contrib.auth.models import User

class ClientTest(TestCase):
    fixtures = ['overall.json']

    def setUp(self):
        ''''''
        self.c = Client()
        self.c.login(username='7p', password='123') == True
        self.user = User.objects.get(username='7p')

    def tearDown(self):
        '''drop fixtures'''
        pass

    def test_add_to_basket(self):
        resp = self.c.post("/client/basket/add", \
                           {'part_number': "12154eefe5",
                            'brand_name': "mazda",
                            'msrp': 100.56,
                            'user_price': 98.25})
        assert resp.status_code == 200
        assert Basket.objects.filter(user=self.user).count() == 1

    def test_clear_basket(self):
        resp = self.c.post("/client/basket/add", \
                           {'part_number': "12154eefe5",
                            'brand_name': "mazda",
                            'msrp': 100.56,
                            'user_price': 98.25})
        assert resp.status_code == 200

        resp = self.c.get("/client/basket/clear/")
        assert resp.status_code == 200
        assert Basket.objects.filter(user=self.user).count() == 0


    def test_order_basket(self):
        data = [
            {'part_number': 'test1', 'brand_name': "mazda",}
        ]

