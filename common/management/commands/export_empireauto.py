# -*- coding=utf-8 -*-

import json

from django.db import connection
from django.core.management.base import BaseCommand


MAP = {
    'ACURA': 'Acura',
    'AUDI': 'Audi',
    'BMW': 'BMW',
    'BUICK':'Gm',
    'CADILLAC':'Gm',
    'CHEVROLET-GMC':'Gm',
    'CHRYSLER-DODGE-PLYM':'Mopar',
    'DAEWOO': 'Daewoo',
    'EAGLE': 'Eagle',
    'FIAT': 'Fiat',
    'FORD-MERCURY':'Ford',
    'GEO':'Gm',
    'HUMMER': 'Hummer',
    'HONDA':'Honda',
    'HYUNDAI':'Hyundai',
    'INFINITI': 'Infiniti',
    'ISUZU':'Isuzu',
    'JAGUAR': 'Jaguar',
    'JEEP':'Mopar',
    'KIA': 'Kia',
    'LAND ROVER': 'Land Rover',
    'LEXUS': 'Lexus',
    'LINCOLN':'Ford',
    'MAZDA':'Mazda',
    'MINI': 'Mini',
    'MERCEDES BENZ':'Mercedes-benz',
    'MITSUBISHI':'Mitsubishi',
    'NISSAN':'Nissan',
    'OLDSMOBILE':'Gm',
    'PONTIAC':'Gm',
    'PORSCHE': 'Porsche',
    'SAAB':'Gm',
    'SATURN': 'Saturn',
    'SCION': 'Scion',
    'SUBARU':'Subaru',
    'SUZUKI':'Suzuki',
    'TOYOTA':'Toyota',
    'VOLKSWAGEN':'Volkswagen',
    'VOLVO':'Volvo',
}


class Command(BaseCommand):
    option_list = BaseCommand.option_list + (
        
    )

    def handle(self, *args, **options):

        import openpyxl

        wb = openpyxl.Workbook(optimized_write=True)
        ws = wb.create_sheet()

        ws.append((u'Брэнд1', u'Артикул1', u'Брэнд2', u'Артикул2',))

        cur = connection.cursor()

        sql = """
        SELECT DISTINCT ON (maker, refoenumber, itemnumber) maker, refoenumber, itemnumber, assembly
        FROM common_bot2
        ORDER BY maker
        """

        cur.execute(sql)

        i = 0
        for item in cur:
            maker, refoenumber, itemnumber, assemblies = item

            obrand = MAP[maker.upper()]
            onumber = refoenumber
            fbrand = 'Taiwan'
            fnumber = itemnumber

            if onumber == 'Assembly':
                try:
                    assemblies = json.loads(assemblies)
                except:
                    continue
                for assembly in assemblies:
                    if assembly[0] == 'OEM #':
                        ws.append((obrand, assembly[1], fnumber, fbrand,))
            else:
                ws.append((obrand, onumber, fbrand, fnumber,))
                ws.append((fbrand, fnumber, obrand, onumber,))

            i += 1
            print i

        wb.save('export1.xlsx')
