# -*- coding=utf-8 -*-

import json
import openpyxl
import re

from django.db import connection
from django.core.management.base import BaseCommand

from lib import xlsreader


MAP = {
    'CHRYSLER': 'Mopar',
    'DODGE':'Mopar',
    'JEEP': 'Mopar',
    'PONTIAC': 'Gm',
    'ALFA ROMEO': 'Alfa romeo',
    'AUDI': 'Audi',
    'BMW': 'Bmw',
    'CHEVROLET': 'Gm',
    'CITROEN': 'Citroen',
    'FIAT': 'Fiat',
    'FORD': 'Ford',
    'LAND ROVER': 'Land rover',
    'MERCEDES BENZ': 'Mercedes-benz',
    'OPEL': 'Opel',
    'PEUGEOT': 'Peugeot',
    'RENAULT': 'Renault',
    'SAAB': 'Gm',
    'SEAT': 'Volkswagen',
    'SKODA': 'Skoda',
    'VOLKSWAGEN': 'Volkswagen',
    'VOLVO': 'Volvo',
    'CHERY': 'Chery',
    'DAEWOO': 'Daewoo',
    'HYUNDAI': 'Hyundai',
    'KIA': 'Kia',
    'Honda': 'Honda',
    'Infiniti': 'Infiniti',
    'Isuzu': 'Isuzu',
    'Mazda': 'Mazda',
    'MMC': 'Mitsubishi',
    'Nissan': 'Nissan',
    'Subaru': 'Subaru',
    'Suzuki': 'Suzuki',
    'Toyota': 'Toyota',
}


class Command(BaseCommand):
    option_list = BaseCommand.option_list + (
        
    )

    def handle(self, *args, **options):

        wb = openpyxl.Workbook(optimized_write=True)
        ws = wb.create_sheet()

        ws.append((u'Брэнд1', u'Артикул1', u'Брэнд2', u'Артикул2',))

        f = open('/home/ermol/Downloads/price.xls', 'rb')
        xls = xlsreader.readexcel(file_contents=f.read())
        maker = None
        for sheet in xls.book.sheet_names():

            i = 0
            for line in xls.iter_list(sheet):

                i += 1
                if i < 23:
                    continue

                if i == 7467:
                    break

                if not all(line):

                    try:
                        maker = MAP[line[3]]
                    except KeyError:
                        continue
                else:

                    obrand = maker
                    fbrand = 'Taiwan'

                    for onumber in re.findall(r"[\w\d\-']+", str(line[0])):
                        for fnumber in re.findall(r"[\w\d\-']+", str(line[2])):
                            row1 = (obrand.strip(), onumber.strip(), fbrand.strip(), fnumber.strip(),)
                            if all(row1):
                                ws.append(row1)
                            row2 = (fbrand.strip(), fnumber.strip(), obrand.strip(), onumber.strip(),)
                            if all(row2):
                                ws.append(row2)

                print i

        wb.save('rbr.xlsx')
