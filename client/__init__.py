# -*- coding=utf-8 -*-

from rpc4django import rpcmethod
from django.contrib.auth import authenticate

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
    return []


@rpcmethod(name='getPartsByPartNumber', signature=['array', 'string', 'string', 'string'])
def getPartsByPartNumber(username, password, partnumber, **kwargs):
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
    user = authenticate(username=username, password=password)

    if not user:
        raise ValueError('Invalid username or password')

    if not isinstance(partnumber, basestring):
        raise ValueError('"partnumber" must be a string')

    from common.views import PartSearchLocal

    founds = PartSearchLocal().search(None, partnumber)

    if not founds:
        return []

    parts = calc_parts(founds, user, render_for_template=False)

    data = []
    fields_map = (
        ('direction', 'direction'),
        ('brandgroup', 'brandgroup'),
        ('area', 'area'),
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