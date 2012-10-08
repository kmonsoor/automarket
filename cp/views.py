# -*- coding=utf-8 -*-
import os
import mechanize
import cjson
import pyExcelerator as xl
from datetime import datetime

from django.core.mail import send_mail
from django.contrib.auth.models import User
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.shortcuts import get_object_or_404
from django.http import Http404, HttpResponseRedirect, HttpResponse
from django.utils.datastructures import MultiValueDict
from django.conf import settings
from django.template.loader import render_to_string
from django.template import RequestContext

from lib.decorators import render_to, ajax_request
from lib.paginator import SimplePaginator
from lib.sort import SortHeaders
from lib.qs_filter import QSFilter
from lib import xlsreader

from cp.forms import OrderItemForm, ImportXlsForm
from client.forms import SearchForm
from data.models import BrandGroup, Brand, OrderedItem, ORDER_ITEM_STATUSES
from data.forms import OrderedItemsFilterForm, OrderedItemForm
from common.views import PartSearch

import logging
logger = logging.getLogger("cp.views")


@login_required
@render_to('cp/search.html')
def search(request):
    founds = []
    maker_name = None
    msg = ''
    search_class = PartSearch()

    maker_choices = search_class.maker_choices()
    if request.method == 'POST':
        form = SearchForm(request.POST, maker_choices=maker_choices)
        if form.is_valid():
            maker = form.cleaned_data['maker']
            part_number = form.cleaned_data['part_number']
            founds = search_class.search(maker, part_number)
            if not founds:
                msg = u"Not Found"
            maker_name = form.cleaned_data['maker']
    else:
        form = SearchForm(maker_choices=maker_choices)

    return {'form': form, 'data': founds, 'maker_name': maker_name, 'msg': msg}


def get_status_options():
    statuses_dict = ORDER_ITEM_STATUSES
    status_options_str = '{'
    status_options = []
    k = 0
    for i in statuses_dict:
        k += 1
        status_options_str += '"%s":"%s"' % (i[0], i[1])
        status_options.append({'value': i[0], 'option': i[1]})
        if k < len(ORDER_ITEM_STATUSES):
            status_options_str += ','
    status_options_str += '}'
    return (status_options_str, status_options)


@login_required
@render_to('cp/index.html')
def index(request):
    context = {}
    current_page = request.GET.get('page', 1)
    items_per_page = request.GET.get('items_per_page', None)
    if not items_per_page:
        items_per_page = request.session.get('cp_index_items_per_page', None)
    else:
        request.session['cp_index_items_per_page'] = items_per_page
        request.session.modified = True
    if not items_per_page:
        items_per_page = 20
    items_per_page = int(items_per_page)

    context['items_per_page'] = items_per_page
    _filter = QSFilter(request, OrderedItemsFilterForm)
    if _filter.modified:
        current_page = 1
    context['filter'] = _filter

    LIST_HEADERS = (
        (u'PO', 'ponumber'),
        (u'Направление', 'brandgroup__title'),
        (u'Поставщик', 'area__title'),
        (u'BRAND', 'brand__title'),
        (u'PART #', 'part_number'),
        (u'COMMENT 1', None),
        (u'COMMENT 2', None),
        (u'Создано', 'created'),
        (u'Получено', 'received_office_at'),
        (u'Q', None),
        (u'PRICE IN', None),
        (u'TOTAL', None),
        (u'ЗАМЕНА', None),
        (u'ID', 'manager'),
        (u'CL', 'client'),
        (u'RUS', None),
        (u'ENG', None),
        (u'LIST', None),
        (u'WEIGHT', None),
        (u'SHIPPING', None),
        (u'PRICE', None),
        (u'NEW PRICE', None),
        (u'COST', None),
        (u'TOTAL COST', None),
        (u'Инвойс', 'invoice_code'),
        (u'Статус', 'status'),
    )
    sort_headers = SortHeaders(request, LIST_HEADERS)
    order_field = request.GET.get('o', None)
    order_direction = request.GET.get('ot', None)

    order_by = '-created'
    if order_field:
        if order_direction == 'desc':
            order_direction = '-'
        else:
            order_direction = ''
        order_by = order_direction + LIST_HEADERS[int(order_field)][1]

    context['headers'] = list(sort_headers.headers())

    qs = OrderedItem.objects.select_related().filter(**_filter.get_filters())

    # calculate totals by filter
    total_row = None
    if _filter.is_set:
        from django.db import connection

        td = "U0"
        q, params = qs._as_sql(connection)
        from_clause = q.split("FROM")[1]

        where = from_clause.split("WHERE")
        if len(where) > 1:
            from_clause = where[0]
            where = [where[1]]
        else:
            where = []
        where.append("%s.status NOT IN ('failure', 'wrong_number', 'out_of_stock', 'cancelled_customer', 'export_part')" % td)
        where = "WHERE %s" % "AND ".join(where)

        sql = \
        """
        SELECT
            SUM(%(p)s.total_cost) as TOTAL_COST,
            SUM(%(p)s.weight*%(p)s.quantity) as TOTAL_WEIGHT,
            SUM(%(p)s.delivery) as TOTAL_DELIVERY,
            SUM(%(p)s.quantity*COALESCE(%(p)s.price_discount, %(p)s.price_sale, 0)) AS TOTAL_PRICE,
            SUM(%(p)s.price_invoice*%(p)s.quantity) as TOTAL_PRICE_IN
            FROM %(from)s %(where)s
        """ % {'p': td, 'from': from_clause, 'where': where}
        cursor = connection.cursor()
        cursor.execute(sql, params)
        res = cursor.fetchall()
        if len(res) > 0:
            total_row = dict(zip( \
                ('COST', 'WEIGHT', 'DELIVERY', 'PRICE', 'PRICE_IN'), \
                res[0]))

    if order_by:
        qs = qs.order_by(order_by)

    paginator = SimplePaginator(request, qs, items_per_page, 'page')

    # grouping parents orders
    items_list = list(paginator.get_page_items())
    items_ids = list(paginator.get_page_items().values_list('id', flat=True))
    for order in items_list:
        if order.parent:
            del items_list[items_list.index(order)]
    has_parent_list = list(OrderedItem.objects.filter(parent__id__in=items_ids))
    for order in has_parent_list:
        index = items_list.index(order.parent)
        items_list.insert(index, order)
    paginator.page.object_list = items_list

    #paginator.set_page(current_page)
    context['status_options_str'], context['status_options'] = get_status_options()
    context['items'] = paginator.get_page_items()
    context['paginator'] = paginator
    context['brands'] = ','.join(['{"id":%s,"name":"%s"}' % (brand.id, brand.title) for brand in Brand.objects.all()])
    context['total_row'] = total_row
    return context


@login_required
@render_to('cp/order.html')
def order(request):
    response = {}
    if request.method == 'POST':
        item_forms = OrderItemForm.get_forms(request)
        item_data = [item_form.render_js('from_template') for item_form in item_forms]
        if item_forms.are_valid():
            clients = {}
            for form in item_forms:
                data = form.cleaned_data
                if data['client'] not in clients:
                    clients[data['client']] = \
                        OrderedItem.objects.get_next_client_order_id(data['client'])
                data['client_order_id'] = clients[data['client']]
                supplier_id = data.pop('supplier')
                data['manager'] = request.user

                data['brandgroup'] = BrandGroup.objects.get(id=supplier_id)
                OrderedItem(**data).save()

            return HttpResponseRedirect('/cp/order/success/')
    else:
        item_data = [
            OrderItemForm().render_js('from_template'),
            OrderItemForm().render_js('from_template'),
            OrderItemForm().render_js('from_template')
        ]

    response['page_template'] = OrderItemForm().render_js('from_template')
    response['page_data'] = item_data

    return response


@render_to('cp/order_success.html')
def order_success(request):
    return {}


@render_to('cp/groups.html')
def groups(request):
    qs = OrderedItem.objects.filter(status__in=('order', 'moderation'))
    orders_by_direction = {}
    for order in qs:
        if order.brandgroup.direction not in orders_by_direction:
            orders_by_direction[order.brandgroup.direction] = {}
        if order.brandgroup not in orders_by_direction[order.brandgroup.direction]:
            orders_by_direction[order.brandgroup.direction][order.brandgroup] = []
        orders_by_direction[order.brandgroup.direction][order.brandgroup].append(order)

    basket_filled, msg = automototrade_basket_filled()
    if basket_filled:
        messages.add_message(request, messages.ERROR, msg)
    else:
        messages.add_message(request, messages.SUCCESS, msg)

    return {'orders_by_direction': orders_by_direction}


def automototrade_basket_filled():
    try:
        br = mechanize.Browser()
        br.open("http://automototrade.com/", timeout=5.0)
        br.select_form(nr=0)
        br["login"] = settings.SOAP_LOGIN
        br["password"] = settings.SOAP_PASSWORD
        br.submit()
        link = list(br.links(url="./?key=personal&basket2"))[0]
        count = int(link.text.decode('cp1251').lower().split(" ")[2].strip())
    except:
        return True, u'Произошла ошибка при проверке корзины. Проверьте, пожалуйста, вручную.'
    else:
        res = False
        if count > 0:
            res = True
        return res, u'В корзине <b>%s</b> позиций.' % count


class OrderedItemSaver(object):
    error = None

    def save_part_number(self, obj, value):
        try:
            obj.part_number = value
            obj.save()
        except Exception, e:
            logger.exception("save_part_number: %r" % e)
            pass
        return obj.part_number

    def save_comment_customer(self, obj, value):
        try:
            obj.comment_customer = value
            obj.save()
        except Exception, e:
            logger.exception("save_comment_customer: %r" % e)
            pass
        return obj.comment_customer

    def save_comment_supplier(self, obj, value):
        try:
            obj.comment_supplier = value
            obj.save()
        except Exception, e:
            logger.exception("save_comment_supplier: %r" % e)
            pass
        return obj.comment_supplier

    def save_price_invoice(self, obj, value):
        # change status for first time setting
        # of price invoice for US direction
        if not obj.price_invoice and value:
            if str(obj.brandgroup.direction.title.lower()) == 'us':
                obj.switch_status('in_delivery')
            if str(obj.brandgroup.direction.title.lower()) == 'msk':
                obj.switch_status('sent_representative')
        else:
            obj.switch_status()
        try:
            obj.price_invoice = value
            obj.save()

        except Exception, e:
            logger.exception("save_price_invoice: %r" % e)
        return obj.price_invoice

    def save_part_number_superseded(self, obj, value):
        try:
            obj.part_number_superseded = value
            obj.save()
        except Exception, e:
            logger.exception("save_part_number_superseded: %r" % e)
            pass
        return obj.part_number_superseded

    def save_description_ru(self, obj, value):
        try:
            obj.description_ru = value
            obj.save()
        except Exception, e:
            logger.exception("save_description_ru: %r" % e)
            pass
        return obj.description_ru

    def save_description_en(self, obj, value):
        try:
            obj.description_en = value
            obj.save()
        except Exception, e:
            logger.exception("save_description_en: %r" % e)
            pass
        return obj.description_en

    def save_price_base(self, obj, value):
        try:
            obj.price_base = value
            obj.save()
        except Exception, e:
            logger.exception("save_price_base: %r" % e)
            pass
        return obj.price_base

    def save_weight(self, obj, value):
        try:
            if not obj.weight:
                obj.status = 'received_office'
                obj.received_office_at = datetime.now()
            obj.weight = value
            obj.save()
        except Exception, e:
            logger.exception("save_weight: %r" % e)
            pass
        return obj.weight

    def save_price_discount(self, obj, value):
        try:
            obj.price_discount = value
            obj.save()
        except Exception, e:
            logger.exception("save_price_discount: %r" % e)
            pass
        return obj.price_discount

    def save_quantity_ship(self, obj, value):
        try:
            if obj.quantity < value:
                self.error = 'quantity_ship value can not be more than quantity (quantity: %s, entered: %s)' % (obj.quantity, value)
                return obj.quantity_ship
            obj.quantity_ship = value
            obj.save()
        except Exception, e:
            logger.exception("save_quantity_ship: %r" % e)
            self.error = e
        return obj.quantity_ship

    def save_status(self, obj, value):
        try:
            previous_status = obj.previous_status
            obj.previous_status = obj.status
            if value == '_return_':
                if previous_status:
                    obj.status = previous_status
            else:
                obj.status = value
            obj.status_modified = datetime.now()
            if value == 'received_office':
                obj.received_office_at = datetime.now()
            obj.save()
        except Exception, e:
            logger.exception("save_status: %r" % e)
            pass
        return obj.status

    def save_invoice_code(self, obj, value):
        try:
            obj.invoice_code = value
            obj.save()
        except Exception, e:
            logger.exception("save_invoice_code: %r" % e)
            pass
        return obj.invoice_code


@ajax_request
def position_edit(request, content_type, item_id):
    logger.debug("position_edit called with args: %s, %s" % (content_type, item_id))
    models = {'ordered_item': OrderedItem}
    forms = {'ordered_item': OrderedItemForm}
    savers = {'ordered_item': OrderedItemSaver}
    item = get_object_or_404(models[content_type], pk=item_id)
    logger.debug("Item found: %r" % item)
    response = {}
    try:
        old_value = getattr(item, request.POST['type'])
    except:
        logger.exception('Attribute %s does not exist' % request.POST['type'])
        response['error'] = 'Attribute does not exist'
        return response
    form = forms[content_type]({request.POST['type']: request.POST['value']})
    if form.is_valid():
        logger.debug("Form is valid")
        try:
            value = form.cleaned_data[request.POST['type']]
            logger.debug("Got value: %r" % value)
        except Exception, e:
            logger.error("Value error: %r" % e)
            response['error'] = e
            return response

        saver = savers[content_type]()
        logger.debug("Calling saver: %r" % saver)
        response['value'] = getattr(saver, 'save_' + request.POST['type'])(item, value)
        response['error'] = saver.error
    else:
        logger.error("Form validation failed")
        response['value'] = old_value and str(old_value) or ''
        response['error'] = u'Wrong value!'
    return response


@ajax_request
def get_ordered_item(request, item_id):
    item = get_object_or_404(OrderedItem, pk=item_id)
    fields = request.GET.get('fields').split(",")
    if not fields:
        return {}
    response = {}
    for f in fields:
        try:
            if f in ('created', 'modified', 'received_office_at'):
                try:
                    attr = getattr(item, f)
                    response[f] = attr.strftime("%Y-%m-%d %H:%M:%S")
                except (AttributeError, ValueError):
                    response[f] = ''
            else:
                response[f] = str(getattr(item, f))
        except AttributeError:
            response[f] = None
    return response


def insert_in_basket(items, ponumber, send_order=False):
    details = []
    not_us_details = []
    data = {'ok': False, 'response': None}
    for x in items:
        d = {
            'Brand': x.area.title,
            'Coment': x.comment_supplier if x.comment_supplier else '',
            'Description': x.description_ru,
            'DescriptionEng': x.description_en,
            'Qty': x.quantity,
            'OemCode': x.part_number,
            'CustomerId': "%s/%s" % (int(x.id), x.client.username),
            'Weight': x.weight if x.weight else '',
        }

        if x.brandgroup.add_brand_to_comment and x.brandgroup.direction.title.lower() in ('us',):
            d['Coment'] = u'%s %s' % (d['Coment'], x.brand.title) if d['Coment'] else x.brand.title

        if x.brandgroup.direction.title.lower() in ('us',):
            details.append(d)
        else:
            not_us_details.append(d)

    if not_us_details:
        context = {
            'details': not_us_details,
            'root_url': settings.ROOT_URL
        }
        text = render_to_string('cp/mails/new_orders.txt', context)
        if text:
            send_mail(settings.EMAIL_SUBJECT, text, settings.EMAIL_FROM, settings.EMAILS, fail_silently=False)
            data = {'ok': True, 'response': 'mail_sent'}

    if details:
        response = ''
        err = 0
        fails = (
                u'Произошла ошибка. Детали не были добавлены в корзину. Проверьте, пожалуйста, правильность введенных данных и попробуйте еще раз.',
                u'Произошла ошибка. Детали были добавлены в корзину, но способ доставки и PO не были заданы.',
                u'Произошла ошибка. Детали были добавлены в корзину, способ доставки и PO были заданы, но детали не были отправлены в заказ.'
        )
        succ = (
                u'Детали были успешно добавлены в корзину, способ доставки(авиа) и PO были успешно заданы.',
        )

        if getattr(settings, 'SOAP_ENABLE', False):
            script_path = os.path.join(settings.PROJECT_ROOT, 'soapclient.php')
            arg1 = cjson.encode(details)
            arg2 = cjson.encode({'login': settings.SOAP_LOGIN, 'passwd': settings.SOAP_PASSWORD})
            cmd = "php -f %s %s '%s' '%s'" % (script_path, 'insertBasket', arg1, arg2)
            f = os.popen(cmd)
            data = f.read()
            f.close()
            response = ''
            if data:
                data = cjson.decode(data)
                if data and data['ok'] and data['response']:
                    arg3 = cjson.encode({'ClientOrderNum': ponumber, 'DostavkaType': getattr(settings, 'DELIVERY_TYPE', 1)})
                    cmd = "php -f %s %s '%s' '%s'" % (script_path, 'setOrderParam', arg3, arg2)
                    f = os.popen(cmd)
                    data = f.read()
                    f.close()
                    if data:
                        data = cjson.decode(data)
                        if data and data['ok'] and data['response']:
                            response += succ[0]
                            if send_order:
                                cmd = "php -f %s %s '%s'" % (script_path, 'sendOrder', arg2)
                                f = os.popen(cmd)
                                data = f.read()
                                f.close()
                                if data:
                                    data = cjson.decode(data)
                                    if data['ok'] and data['response']:
                                        pass
                                    else:
                                        err += 1
                                        response += fails[2]
                                else:
                                    err += 1
                                    response += fails[2]
                        else:
                            err += 1
                            response += fails[1]
                    else:
                        err += 1
                        response += fails[1]
                else:
                    err += 1
                    response += fails[0]
            else:
                err += 1
                response += fails[0]

            if err > 0:
                ok = False
            else:
                ok = True

            return {'ok': ok, 'response': response}


def change_status(request):
    if not request.method == 'POST':
        raise Http404

    ids = request.POST.getlist('items')
    try:
        orders = OrderedItem.objects.filter(id__in=ids, status='order')
    except:
        orders = []

    if not orders:
        return HttpResponseRedirect('/cp/groups/')

    ponumber = OrderedItem.objects\
        .get_next_ponumber(orders[0].brandgroup.direction.id)
    poprefix = orders[0].brandgroup.direction.po
    full_po = '%s%s' % (poprefix, ponumber)

    data = insert_in_basket(orders, full_po)
    if data:
        if data['ok']:
            if 'response' in data and data['response']:
                messages.add_message(request, messages.SUCCESS, data['response'])
            for x in orders:
                if not x.ponumber:
                    x.ponumber = ponumber
                x.status = 'in_processing'
                x.status_modified = datetime.now()
                x.save()
        else:
            if 'response' in data and data['response']:
                messages.add_message(request, messages.ERROR, data['response'])
    return HttpResponseRedirect('/cp/groups/')


def export_selected(request):

    ids = request.POST.getlist('items')
    try:
        items = OrderedItem.objects.filter(id__in=ids, status='order')
    except:
        items = []

    if items:
        ponumber = OrderedItem.objects.get_next_ponumber(items[0].brandgroup.direction.id)
        for x in items:
            if not x.ponumber:
                x.ponumber = ponumber
            x.status = 'in_processing'
            x.status_modified = datetime.now()
            x.save()

        filename = os.path.join(settings.MEDIA_ROOT, 'temp.xls')

        # Open new workbook
        book = xl.Workbook()

        # styles
        sub_header_style = xl.XFStyle()
        sub_header_style.font = xl.Font()
        sub_header_style.bold = True
        sub_header_style.font.height = 0x0190-150

        sheet = book.add_sheet('Export')

        header = (u'Brand', u'Part Number', u'Описание (русское)', u'Q-ty', u'Customer_id', u'Comment', u'Описание (англ.)')
        col = 0
        row = 0
        for x in header:
            sheet.write(row, col, x, sub_header_style)
            col += 1

        sub_header_style.bold = False
        row += 1

        for i in items:
            sheet.write(row, 0, i.brand.title, sub_header_style)
            sheet.write(row, 1, i.part_number, sub_header_style)
            sheet.write(row, 2, i.description_ru or '', sub_header_style)
            sheet.write(row, 3, i.quantity, sub_header_style)
            sheet.write(row, 4, u'%s %s' % (i.client, i.client_order_id), sub_header_style)
            sheet.write(row, 5, i.comment_supplier or '', sub_header_style)
            sheet.write(row, 6, i.description_en or '', sub_header_style)
            row += 1

        # Save book
        book.save(filename)
        os.chmod(filename, 0777)
        content = open(filename, 'rb').read()
        response = HttpResponse(content, mimetype='application/vnd.ms-excel')
        name = '%s-%s.xls' % ('export', datetime.now().strftime('%m-%d-%Y-%H-%M'))
        response['Content-Disposition'] = 'inline; filename=%s' % name
        os.remove(filename)

        return response
    else:
        return HttpResponseRedirect('/cp/groups/')


def export(request, group_id):
    brandgroup = BrandGroup.objects.get(id=group_id)
    items = OrderedItem.objects.filter(brandgroup__id=group_id, status='order').order_by("brandgroup__direction__po")
    ponumber = OrderedItem.objects.get_next_ponumber(brandgroup.direction.id)

    for x in items:
        if not x.ponumber:
            x.ponumber = ponumber
        x.status = 'in_processing'
        x.status_modified = datetime.now()
        x.save()

    filename = os.path.join(settings.MEDIA_ROOT, 'temp.xls')

    # Open new workbook
    book = xl.Workbook()

    # styles
    sub_header_style = xl.XFStyle()
    sub_header_style.font = xl.Font()
    sub_header_style.bold = True
    sub_header_style.font.height = 0x0190-150

    sheet = book.add_sheet(brandgroup.title)

    header = (u'Brand', u'Part Number', u'Описание (русское)', u'Q-ty', u'Customer_id', u'Comment', u'Описание (англ.)')
    col = 0
    row = 0
    for x in header:
        sheet.write(row, col, x, sub_header_style)
        col += 1

    sub_header_style.bold = False
    row += 1

    for i in items:
        sheet.write(row, 0, i.brand.title, sub_header_style)
        sheet.write(row, 1, i.part_number, sub_header_style)
        sheet.write(row, 2, i.description_ru or '', sub_header_style)
        sheet.write(row, 3, i.quantity, sub_header_style)
        sheet.write(row, 4, u'%s %s' % (i.client, i.client_order_id), sub_header_style)
        sheet.write(row, 5, i.comment_supplier or '', sub_header_style)
        sheet.write(row, 6, i.description_en or '', sub_header_style)
        row += 1

    # Save book
    book.save(filename)
    os.chmod(filename, 0777)
    content = open(filename, 'rb').read()
    response = HttpResponse(content, mimetype='application/vnd.ms-excel')
    name = '%s-%s.xls' % (brandgroup.title, datetime.now().strftime('%m-%d-%Y-%H-%M'))
    response['Content-Disposition'] = 'inline; filename=%s' % name
    os.remove(filename)

    return response


@render_to('cp/import_order.html')
@login_required
def import_order(request):
    CELLS = (
       (0, 'supplier', 'DIR'),
       (1, 'brand', 'BRAND'),
       (2, 'area', 'AREA'),
       (3, 'part_number', 'PART#'),
       (4, 'comment_customer', 'COMENT 1'),
       (5, 'comment_supplier', 'COMENT 2'),
       (6, 'quantity', 'Q'),
       (7, 'client', 'CL'),
       (8, 'description_ru', 'RUS'),
       (9, 'description_en', 'ENG'),
       (10, 'price_base', 'LIST'),
       (11, 'price_sale', 'PRICE'),
    )

    def get_field_name(cell_title):
        for i in CELLS:
            if i[2] == cell_title:
                return i[1]

    def swap_keys(kwargs, num):
        _data = {}
        for k, v in kwargs.items():
            if k.upper() == 'DIR':
                try:
                    _data[get_field_name(k) + '.%d' % num] = [BrandGroup.objects.get(title__iexact=v[0]).id]
                except BrandGroup.DoesNotExist:
                    _data[get_field_name(k) + '.%d' % num] = ''
            elif k.upper() == 'BRAND' or k.upper() == 'AREA':
                _data[get_field_name(k) + '.%d' % num] = [v[0].capitalize()]
            elif k.upper() == 'CL':
                try:
                    _data[get_field_name(k) + '.%d' % num] = [User.objects.get(username__iexact=v[0].lower()).id]
                except User.DoesNotExist:
                    _data[get_field_name(k) + '.%d' % num] = ''
            else:
                _data[get_field_name(k) + '.%d' % num] = v
            _data['id' + '.%d' % num] = ''
        return _data

    response = {}
    data = {}
    if request.method == 'POST':
        form = ImportXlsForm()
        f = request.FILES.get('xls_file', None)
        if f:
            i = 1
            try:
                xls = xlsreader.readexcel(file_contents=f.read())
                for row in xls.iter_dict(xls.book.sheet_names()[0]):
                    row = dict([(x, [y]) for x, y in list(row.iteritems())])
                    data.update(swap_keys(row, i))
                    i = i + 1
            except Exception, mess:
                logger.error("%r" % mess)
                messages.add_message(request, messages.ERROR, u"При импорте произошла критическая ошибка %s-ой(-ей) строке." % i)
            else:
                if data:
                    request.POST = MultiValueDict(data)
                    item_forms = OrderItemForm.get_forms(request)
                    form_list = [item_form.render_js('from_template') for item_form in item_forms]
                    response['page_data'] = form_list
            finally:
                f.close()
    else:
        form = ImportXlsForm()
    response['form'] = form
    response['page_template'] = OrderItemForm().render_js('from_template')
    return response


LIST_HEADERS = (
    (u'PO', 'ponumber'),
    (u'Поставщик', 'brandgroup'),
    (u'BRAND', 'brand'),
    (u'AREA', 'area'),
    (u'PART #', 'part_number'),
    (u'COMMENT 2', 'comment_supplier'),
    (u'Q', 'quantity'),
    (u'PRICE IN', 'price_invoice'),
    (u'TOTAL', 'total_w_ship'),
    (u'ЗАМЕНА', 'part_number_superseded'),
    (u'ID', 'manager'),
    (u'CL', 'client'),
    (u'RUS', 'description_ru'),
    (u'ENG', 'description_en'),
    (u'LIST', 'price_base'),
    (u'WEIGHT', 'weight'),
    (u'SHIPPING', 'delivery'),
    (u'PRICE', 'price_sale'),
    (u'NEW PRICE', 'price_discount'),
    (u'COST', 'cost'),
    (u'TOTAL COST', 'total_cost'),
    (u'Инвойс', 'invoice_code'),
    (u'Статус', 'status'),
)


def field_value(order_obj, field_name):
    price_fields = [
        'price_invoice', 'total', 'total_w_ship', 'price_base', 'price_sale', 'delivery',
        'price_discount', 'cost', 'total_cost'
    ]
    if field_name in price_fields and order_obj.failed:
        return ''
    return getattr(order_obj, field_name) or ''


@login_required
def export_order(request):
    _filter = QSFilter(request, OrderedItemsFilterForm, clear_old=False)

    orders = OrderedItem.objects.select_related() \
                        .filter(**_filter.get_filters()) \
                        .order_by('brandgroup__direction__po', 'ponumber')
    filename = os.path.join(settings.MEDIA_ROOT, 'temp.xls')

    book = xl.Workbook()
    sheet = book.add_sheet('ORDERS')

    i = 0
    curr_line = 0
    for key, value in LIST_HEADERS:
        sheet.write(curr_line, i, key)
        i += 1
    for order in orders:
        i = 0
        curr_line += 1
        for key, field_name in LIST_HEADERS:

            if field_name == 'ponumber':
                value = u'%s%s' % (order.brandgroup.direction.po, order.ponumber \
                                   or '--')
            elif field_name == 'status':
                value = order.get_status_verbose()
            else:
                value = field_value(order, field_name)
            try:
                sheet.write(curr_line, i, value)
                i += 1
            except AssertionError:
                value = unicode(value)
                sheet.write(curr_line, i, value)
                i += 1

    book.save(filename)
    os.chmod(filename, 0777)
    content = open(filename, 'rb').read()
    response = HttpResponse(content, mimetype='application/vnd.ms-excel')
    name = '%s-%s.xls' % ('orders', datetime.now().strftime('%m-%d-%Y-%H-%M'))
    response['Content-Disposition'] = 'inline; filename=%s' % name
    os.remove(filename)
    return response


@ajax_request
@login_required
def get_brandgroup_settings(request, ordered_item_id):
    try:
        ordered_item = OrderedItem.objects.get(pk=ordered_item_id)
    except OrderedItem.DoesNotExist:
        pass
    else:
        m, d, dp, pu = ordered_item.area.get_brandgroup_settings(ordered_item.brandgroup)
        return map(float, [m, d])
    return []


@login_required
def ordered_item_row(request, item_id):
    try:
        item = OrderedItem.objects.get(pk=item_id)
    except OrderedItem.DoesNotExist:
        return HttpResponse(content='')
    c = {
        'i': item,
    }
    c['status_options_str'], c['status_options'] = get_status_options()
    context = RequestContext(request, c)
    html = render_to_string("cp/tags/table/row.html", context_instance=context)
    return HttpResponse(content=html)
