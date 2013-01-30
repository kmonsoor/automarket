# -*- coding=utf-8 -*-

import logging
logger = logging.getLogger('update_orders__automototrade')

import os
import cjson
import sys
import optparse

from django.core.mail import send_mail
from django.core.management.base import BaseCommand
from django.conf import settings
from django.contrib.auth.models import User
from django.template.loader import render_to_string

from data.models import OrderedItem


NO_REFUSED = 'no'
STATUS_MAP = dict((
    ('b\\/o', 'back_order'),
    ('ng', 'wrong_number'),
    ('notav', 'out_of_stock'),
    ('cncl', 'cancelled_customer'),
    ('exp', 'export_part'),
))
CHECK_STATUSES = ('in_processing', 'received_supplier')


class Command(BaseCommand):
    """
    Update orders from automototrade.com
    """
    option_list = BaseCommand.option_list + (
        optparse.make_option('--po', dest='po', help="Po's. Separator `,`"),
    )

    def handle(self, *args, **options):
        """
        Update orders from automototrade.com
        """
        logger.info('Start update orders from automototrade.com')

        if options.get('po'):
            try:
                ponumbers = options.get('po').split(',')
            except:
                print "Please use separator `,`"
                sys.exit()
        else:
            orders = OrderedItem.objects\
                .filter(brandgroup__direction__title__iexact='US',
                        status__in=CHECK_STATUSES,
                        ponumber__gte=settings.AUTO_UPDATE_STATUSES_START_PONUMBER)

            ponumbers = sorted(set([x.get_po_verbose() for x in orders]))

        logger.info("Found %s po's for update. %r." % (len(ponumbers), ponumbers))

        big_price_invoice_orders = []

        for po in ponumbers:
            orders = self.get_orders(po)
            if isinstance(orders, list) and len(orders) > 0:
                for _order in self.get_orders(po):
                    try:
                        order_id = int(_order['customer_id'].split('\\/')[0])
                    except (ValueError, TypeError, IndexError):
                        logger.error("Invalid `customer_id` for po `%r` from automototrade.com: %r" % \
                            (po, _order['customer_id']))
                        continue

                    part_number = _order['oem']
                    received_count = int(_order['polucheno'] or 0)
                    sended_count = int(_order['otpravleno'] or 0)
                    ordered_count = int(_order['tovar_num'] or 0)
                    invoice_list = _order['invoice_list']
                    part_number_superseded = _order['substitution']
                    refused = _order['refused']
                    client_price = float(_order['client_price'] or 0)

                    try:
                        order = OrderedItem.objects\
                            .get(id=order_id, part_number=part_number)

                        if order.status not in CHECK_STATUSES:
                            order = self.get_child(order)

                    except (OrderedItem.DoesNotExist, IndexError):
                        continue

                    if order.parent:
                        sent_earlier_count = self.sent_earlier_count(order)
                        received_count = received_count - sent_earlier_count
                        sended_count = sended_count - sent_earlier_count
                        received_count = received_count - sent_earlier_count

                    if refused == NO_REFUSED:

                        if received_count > 0 and received_count == ordered_count:
                            order.status = 'received_supplier'

                        if client_price:
                            order.price_invoice = client_price
                            if order.price_invoice > order.price_sale:
                                big_price_invoice_orders.append(order)

                        if sended_count > 0:
                            order.status = 'in_delivery'

                        if order.status in ('in_delivery',) and client_price:
                            if invoice_list:
                                invoice = self.get_invoice(order, invoice_list)
                                order.invoice_code = invoice

                        if part_number_superseded:
                            order.part_number_superseded = part_number_superseded

                        if sended_count > 0:
                            if sended_count != order.quantity \
                                and sended_count != ordered_count:

                                o = OrderedItem()

                                if ordered_count > sended_count:
                                    o.quantity = ordered_count - sended_count
                                    o.client = order.client
                                    o.client_order_id = order.client_order_id
                                    order.quantity = sended_count
                                    o.status = 'in_processing'
                                    if received_count > 0 \
                                        and received_count == ordered_count:
                                        o.status = 'received_supplier'
                                else:
                                    o.quantity = sended_count - ordered_count
                                    try:
                                        client = User.objects.get(username="retail")
                                    except User.DoesNotExist:
                                        client = User.objects.get(id=1)
                                    o.client = client
                                    o.client_order_id = OrderedItem.objects.get_next_client_order_id(client)
                                    order.quantity = sended_count - ordered_count
                                    o.status = order.status
                                    o.price_invoice = order.price_invoice
                                    o.invoice_code = order.invoice_code

                                o.parent = order
                                o.brandgroup = order.brandgroup
                                o.area = order.area
                                o.brand = order.brand
                                o.ponumber = order.ponumber
                                o.part_number = order.part_number
                                o.comment_customer = order.comment_customer
                                o.comment_supplier = order.comment_supplier
                                o.manager = order.manager
                                o.description_ru = order.description_ru
                                o.description_en = order.description_en
                                o.price_base = order.price_base
                                o.price_sale = order.price_sale
                                o.price_discount = order.price_discount
                                o.delivery_coef = order.delivery_coef
                                o.delivery = order.delivery
                                o.cost = order.cost
                                o.save()
                        order.save()
                    else:
                        try:
                            status = STATUS_MAP[refused]
                        except KeyError:
                            pass
                        else:
                            order.status = status
                            order.save()
            else:
                logger.error("Error while update orders statuses from automototrade.com: %r" % \
                    orders)

        if len(big_price_invoice_orders) > 0:
            orders = []
            for x in big_price_invoice_orders:
                if not x.big_price_invoice_order_mail_sent:
                    orders.append(x)
            text = render_to_string('cp/mails/big_price_invoice_orders.txt', {'orders': orders})
            send_mail(u'Цена в инвойсе больше, чем цена продажи', text, settings.EMAIL_FROM, settings.EMAILS, fail_silently=False)
            for x in orders:
                x.big_price_invoice_order_mail_sent = True
                x.save()

        logger.info('Finish update orders from automototrade.com')
        sys.exit()

    def get_orders(self, po):
        """
        Calls remote soap-method "getOrderStatus"
        from automototrade.com and returns dict with data of order.
        @po string. ponumber
        """
        script_path = os.path.join(settings.PROJECT_ROOT, 'soapclient.php')
        arg1 = cjson.encode(po)
        arg2 = cjson.encode({
            'login': settings.SOAP_LOGIN,
            'passwd': settings.SOAP_PASSWORD
        })
        cmd = "php -f %s %s '%s' '%s'" % \
            (script_path, 'getOrderStatus', arg1, arg2)

        f = os.popen(cmd)
        data = f.read()
        f.close()

        data = cjson.decode(data)

        return data['response']

    def sent_earlier_count(self, order, quantity=0):
        """
        Return quantity sent parts
        @order data.models.OrderedItem instance
        """
        if order.parent:
            quantity += order.parent.quantity
            return self.sent_earlier_count(order.parent, quantity)
        return quantity

    def get_child(self, order):
        """
        Return last child order
        @order data.models.OrderedItem instance
        """
        child = OrderedItem.objects.get(parent=order)
        if child.status not in CHECK_STATUSES:
            return self.get_child(child)
        return child

    def get_invoice(self, order, invoice_list):
        """
        @order data.models.OrderedItem instance
        @invoice_list string. List of invoices separator `,`
        """
        invoice_list = invoice_list.split(',')
        level = 0
        while True:
            parent = getattr(order, 'parent')
            if not parent:
                break
            level += 1
            order = parent

        for index in reversed(xrange(level + 1)):
            try:
                invoice = invoice_list[index]
            except IndexError:
                continue
            else:
                return "#%s" % invoice
