# -*- coding=utf-8 -*-
import re

from rpc4django import rpcmethod
from django.contrib.auth import authenticate

from data.models import search_local, all_brands

from client.views import calc_parts


@rpcmethod(name='getBrandsByPartNumber', signature=['array', 'string', 'string', 'string'])
def getBrandsByPartNumber(username, password, partnumber):
    '''
    Возвращает список брендов.

    <br/><br/>Python XML-RPC:
    <pre class="prettyprint lang-python">
    from xmlrpclib import ServerProxy
    server = ServerProxy('http://newparts-online.com/rpc/')
    response = server.getBrandsByPartNumber('username', 'password', 'YOK93209')
    print response
    </pre>
    <br/>
    '''

    if not isinstance(username, basestring):
        raise ValueError('"username" must be a string')

    if not isinstance(password, basestring):
        raise ValueError('"password" must be a string')

    if not isinstance(partnumber, basestring):
        raise ValueError('"partnumber" must be a string')

    user = authenticate(username=username, password=password)

    if not user:
        raise ValueError('Invalid username or password')

    partnumber = re.sub('[^\w]', '', partnumber).strip().upper()

    founds = search_local(None, partnumber)

    if not founds:
        return all_brands()

    return list(set(p.get('maker') for p in founds))


@rpcmethod(name='getPartsByPartNumber', signature=['array', 'string', 'string', 'string', 'string'])
def getPartsByPartNumber(username, password, brand, partnumber):
    '''
    Возвращает список деталей с подробной информацией.

    <br/><br/>Python XML-RPC:
    <pre class="prettyprint lang-python">
    from xmlrpclib import ServerProxy
    server = ServerProxy('http://newparts-online.com/rpc/')
    response = server.getPartsByPartNumber('username', 'password', 'YOK93209')
    print response
    </pre>
    <br/>
    '''

    if not isinstance(brand, basestring):
        raise ValueError('"brand" must be a string')

    if not isinstance(partnumber, basestring):
        raise ValueError('"partnumber" must be a string')

    if not isinstance(username, basestring):
        raise ValueError('"username" must be a string')

    if not isinstance(password, basestring):
        raise ValueError('"password" must be a string')

    user = authenticate(username=username, password=password)

    if not user:
        raise ValueError('Invalid username or password')

    partnumber = re.sub('[^\w]', '', partnumber).strip().upper()

    founds = search_local(brand, partnumber.upper())

    if not founds:
        return []

    parts = calc_parts(founds, user, render_for_template=False)

    data = []
    fields_map = (
        ('direction_id', 'direction_id'),
        ('brandgroup_id', 'brandgroup_id'),
        ('area_id', 'area_id'),
        ('maker', 'brand'),
        ('partnumber', 'partnumber'),
        ('description_ru', 'description_ru'),
        ('description', 'description'),
        ('delivery_coef', 'delivery_coef'),
        ('MSRP', 'MSRP'),
        ('your_price', 'your_price'),
        ('your_economy', 'your_savings'),
        ('party', 'part'),
        ('available', 'available'),
        ('delivery_period', 'delivery_period'),
        ('updated_at', 'updated_at'),
    )
    for part in parts:
        data.append(dict((v2, part.get(v1)) for v1, v2 in fields_map))

    return data or []