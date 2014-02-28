# -*- coding=utf-8 -*-
import time
import optparse
import sys
import requests
from BeautifulSoup import BeautifulSoup

import logging
logger = logging.getLogger('firstlineautoparts')

from django.conf import settings
from django.core.mail import send_mail
from django.core.management.base import BaseCommand

from common.models import Bot1


url = 'http://firstlineautoparts.com/ru/price-parts-list/pr/{0}/group/200/{1}'
headers = {
    "User-Agent": "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.8) Gecko/20100722 Firefox/3.6.8 GTB7.1 (.NET CLR 3.5.30729)",
    "Referer": "http://firstlineautoparts.com/ru/price-parts",
}


AUTO = [
    'ACURA', 'BMW', 'CHRYSLER', 'FORD', 'GM', 'HONDA', 'HYUNDAI',
    'INFINITI', 'ISUZU', 'JAGUAR', 'KIA', 'LAND ROVER', 'LEXUS',
    'MAZDA', 'MERCEDES', 'MITSUBISHI', 'NISSAN', 'PORSCHE',
    'ROLLS ROYCE', 'SAAB', 'SUBARU', 'SUZUKI', 'TOYOTA', 'VOLVO',
    'VW', '3M', 'A-1 CARDONE', 'ACDELCO', 'AFE', 'ANCHOR', 'APEXI',
    'ARNOTT INDUSTRIES', 'ARP', 'AUTOEXTRA', 'BORG WARNER', 'BREMBO',
    'CENTRIC', 'CHAMPION', 'CLEVITE', 'CLOYES', 'COMPETITION CLUTCH',
    'CORSA', 'CP PISTONS', 'DAYCO', 'DBA', 'DORMAN', 'EDELBROCK',
    'EIBACH', 'FEDERAL MOGUL', 'FEL-PRO', 'FOUR SEASON', 'FRAM',
    'GARRETT', 'GATES', 'GREDDY', 'H&R', 'HAWK', 'INVIDIA','K&N',
    'KONI', 'KYB', 'MAGNAFLOW', 'MCGARD', 'MISHIMOTO', 'MONROE',
    'MOOG', 'MOTORCRAFT', 'NGK', 'NRG', 'PRECISION', 'PUTCO',
    'SEALED POWER', 'SEIBON', 'SKUNK2', 'SPARCO', 'SPECTRA PREMIUM',
    'STANDARD', 'TIMKEN', 'TURBOSMART','WAGNER', 'WALBRO',
    'WEATHERTECH', 'WILWOOD', 'WIX', 'YUKON GEAR & AXLE']


all_fields = (
    'area', 'partnumber', 'description', 'delivery_period',
    'available', 'weight', 'quantity', 'price', 'core', 'price_cost',
    'price_plus_core', 'currency', 'basket')

need_fields = (
    'area', 'partnumber', 'description', 'delivery_period',
    'price', 'core', 'price_cost', 'price_plus_core', 'currency',
    'substitution',
)

MOTO = [
    'ARCTIC-CAT', 'BIG BIKE PARTS', 'CAN-AM', 'HARLEY-DAVIDSON',
    'HONDA MOTO', 'KAWASAKI', 'KTM', 'KURYAKYN', 'MERCURY',
    'PARTS UNLIMETED', 'POLARIS', 'SUZUKI MOTO', 'TUCKER ROCKY',
    'WPS', 'YAMAHA', 'YOSHIMURA']


class Command(BaseCommand):
    option_list = BaseCommand.option_list + (
        optparse.make_option('--brand', dest='brand'),
        optparse.make_option('--page', dest='page'),
        optparse.make_option('--sleep', dest='page'),
    )

    def handle(self, *args, **options):

        sleep = float(options.get('sleep') or 0.5)

        brand = options.get('brand').upper()
        if brand not in AUTO:
            msg = 'brand %s does not exists' % brand
            logger.info(msg)
            print msg
            sys.exit()
        page = int(options.get('page') or 1)

        logger.info('brand %s: started from page %s', brand, page)

        try:
            part_counter = 0
            while True:
                resp = requests.get(url.format(brand, page), headers=headers)
                resp.raise_for_status()
                soup = BeautifulSoup(resp.content.decode('cp1251'))

                max_page = int(
                    soup.find(attrs={'class': 'pagegotoend'}).find('a').text)

                logger.info(
                    'brand %s: started page %s from %s', brand, page, max_page)

                if page >= max_page:
                    break

                trs = soup.find('table', attrs={'class': 'myunit'}).findAll('tr')
                for tr in trs:
                    tds = tr.findAll('td')
                    if not tds:
                        continue

                    sbs = None
                    if len(tds) == 4:  # substitution
                        sbs = tds.pop(3).find('a').text
                    
                    data = dict(zip(all_fields, map(lambda x: x.text, tds)))

                    if sbs:
                        data.update({'substitution': sbs})

                    part = dict((f, data.get(f)) for f in need_fields)

                    Bot1(**part).save()
                    part_counter += 1

                logger.info(
                    'brand %s page %s: SAVED %s parts',
                    brand, page, part_counter)

                page += 1
                time.sleep(sleep)

        except Exception as e:
            logger.error("%r", e)
            send_mail(
                u'Error parse %s' % brand, u"%r" % e,
                settings.EMAIL_FROM, settings.EMAILS, fail_silently=False
            )
            raise
        else:
            logger.info('brand %s: finished. %s page, %s parts processed', brand, page, part_counter)
            send_mail(
                u'BOT: Загрузка %s закончена' % brand, u"Загружено %s страниц, %s деталей" % (page, part_counter),
                settings.EMAIL_FROM, settings.MANAGERS_EMAILS, fail_silently=False
            )
