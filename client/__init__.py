# -*- coding=utf-8 -*-
import re

from rpc4django import rpcmethod
from django.contrib.auth import authenticate


@rpcmethod(name='getBrands', signature=['array', 'string', 'string', 'string'])
def getBrands(username, password, partnumber):
    # '''
    # Возвращает список брендов.
    # from xmlrpclib import ServerProxy
    # server = ServerProxy('http://newparts-online.com/rpc/')
    # response = server.getBrands('username', 'password', 'YOK93209')
    # '''

    # if not isinstance(username, basestring):
    #     raise ValueError('"username" must be a string')

    # if not isinstance(password, basestring):
    #     raise ValueError('"password" must be a string')

    # if not isinstance(partnumber, basestring):
    #     raise ValueError('"partnumber" must be a string')

    # user = authenticate(username=username, password=password)

    # if not user:
    #     raise ValueError('Invalid username or password')

    # partnumber = re.sub('[^\w]', '', partnumber).strip().upper()

    # founds = search_local(None, partnumber)

    # if not founds:
    #     return all_brands()

    return list()


@rpcmethod(name='getParts', signature=['struct', 'string', 'string', 'string', 'string'])
def getParts(username, password, brand, partnumber):
    # '''
    # Возвращает найденные детали и их аналоги с подробной информацией.
    # from xmlrpclib import ServerProxy
    # server = ServerProxy('http://newparts-online.com/rpc/')
    # response = server.getParts('username', 'password', 'VOLVO', 'YOK93209')
    # '''

    # if not isinstance(brand, basestring):
    #     raise ValueError('"brand" must be a string')

    # if not isinstance(partnumber, basestring):
    #     raise ValueError('"partnumber" must be a string')

    # if not isinstance(username, basestring):
    #     raise ValueError('"username" must be a string')

    # if not isinstance(password, basestring):
    #     raise ValueError('"password" must be a string')

    # user = authenticate(username=username, password=password)

    # if not user:
    #     raise ValueError('Invalid username or password')

    # partnumber = re.sub('[^\w]', '', partnumber).strip().upper()

    # founds, analogs = search_local(brand, partnumber.upper())

    # if not founds:
    #     return {}

    # analog_founds = search_analogs_local(None, partnumber)

    # parts = calc_parts_client(founds, user, render_for_template=False)
    # analogs = calc_parts_client(analog_founds, user)

    # data = {}
    # fields_map = (
    #     ('direction_id', 'direction_id'),
    #     ('brandgroup_id', 'brandgroup_id'),
    #     ('area_id', 'area_id'),
    #     ('maker', 'brand'),
    #     ('partnumber', 'partnumber'),
    #     ('description_ru', 'description_ru'),
    #     ('description', 'description'),
    #     ('delivery_coef', 'delivery_coef'),
    #     ('MSRP', 'MSRP'),
    #     ('your_price', 'your_price'),
    #     ('your_economy', 'your_savings'),
    #     ('party', 'part'),
    #     ('available', 'available'),
    #     ('delivery_period', 'delivery_period'),
    #     ('updated_at', 'updated_at'),
    # )

    # data['parts'] = []
    # for part in parts:
    #     data['parts'].append(dict((v2, part.get(v1)) for v1, v2 in fields_map))

    # data['analogs'] = []
    # for analog in analogs:
    #     data['analogs'].append(dict((v2, analog.get(v1)) for v1, v2 in fields_map))

    return dict()
