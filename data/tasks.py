# coding=utf-8
import tempfile
import datetime
import logging
logger = logging.getLogger('data.tasks')

from django.db import connection
from django.core.mail import send_mail
from django.conf import settings

from celery.task import Task
from celery.registry import tasks

from lib import xlsreader
from data.models import Brand

NULL_COPY = '\N'


class SavePriceFileBase(Task):
    accept_magic_kwargs = False

    def run(self, price):

        cur = connection.cursor()
        cur.execute("""
            DELETE FROM data_part
            WHERE area_id=%s AND brandgroup_id=%s
        """ % (price.area.id, price.brand_group.id)
        )
        cur.close()

        f = price.price
        if not f:
            return 'ok!'

        self.area_id = price.area.id
        self.brandgroup_id = price.brand_group.id

        try:
            success = self.save_parts(price)
        except Exception, e:
            logger.exception("%r" % e)
            send_mail(
                u"Загрузка деталей для `%s` прошла с ошибкой." % price.area.title,
                u"Детали загружены не были.",
                settings.EMAIL_FROM,
                settings.MANAGERS_EMAILS,
                fail_silently=True
            )
            response = 'error!'
            raise
        else:
            send_mail(
                u"Загрузка деталей для `%s` прошла успешно." % price.area.title,
                u"Всего загружено %s деталей." % success,
                settings.EMAIL_FROM,
                settings.MANAGERS_EMAILS,
                fail_silently=True
            )
            response = 'ok!'
        finally:
            f.close()

        return response

    def save_parts(self, price):
        raise NotImplementedError

    def row_for_copy(self, data):
        row = [
            self.area_id,
            data.get('partnumber'),
            data.get('MSRP'),
            data.get('cost'),
            data.get('core_price'),
            data.get('substitution'),
            data.get('description'),
            datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            data.get('brand'),
            data.get('party'),
            data.get('available'),
            self.brandgroup_id,
            data.get('description_ru'),
        ]
        row = map(lambda x: x or NULL_COPY, row)
        row = map(lambda x: str(("%s" % x).encode("UTF-8")), row)
        return "%s\n" % "\t".join(row)

    def _copy(self, f):
        f.seek(0)
        cur = connection.cursor()
        cur.copy_from(
            f, 'data_part',
            columns=(
                'area_id', 'partnumber', '"MSRP"', 'cost', 'core_price',
                'substitution', 'description', 'created_at', 'brand_id',
                'party', 'available', 'brandgroup_id', 'description_ru',
            )
        )
        cur.close()
        return True


class SavePriceFileXlsTask(SavePriceFileBase):

    def save_parts(self, price):
        mapping = (
            (u'БРЭНД', 'brand', lambda x: Brand.objects.get(title__iexact=x).id),
            (u'АРТИКУЛ', 'partnumber', unicode),
            (u'НАИМЕНОВАНИЕ', 'description_ru', unicode),
            (u'АББРЕВИАТУРА', 'description', unicode),
            (u'LIST', 'MSRP', float),
            (u'ВХОД', 'cost', float),
            (u'ПАРТИЯ', 'party', str),
            (u'НАЛИЧИЕ', 'available', int),
        )

        def clean_fieldname(cell_title):
            return dict([(x[0], x[1]) for x in mapping])[cell_title.upper()]

        def clean_fieldvalue(cell_title, cell_value):
            cell_type = dict([(x[0], x[2]) for x in mapping])[cell_title.upper()]
            return cell_type(cell_value)

        success = 0
        with tempfile.TemporaryFile() as f:
            xls = xlsreader.readexcel(file_contents=price.price.read())
            for sheet in xls.book.sheet_names():
                for row in xls.iter_dict(sheet):
                    data = {}
                    for cell_title, cell_value in row.iteritems():
                        cleaned_fieldname = clean_fieldname(cell_title)
                        cleaned_fieldvalue = clean_fieldvalue(cell_title, cell_value)
                        data[cleaned_fieldname] = cleaned_fieldvalue

                    if data.get('partnumber'):
                        f.write(self.row_for_copy(data))
                        success += 1

            self._copy(f)

        return success


class SavePriceFileCsvTask(SavePriceFileBase):

    def save_parts(self, price):
        sep = '\t'
        mapping = (
            ('Part#', 'partnumber', unicode),
            ('ListPrice', 'MSRP', float),
            ('Cost', 'cost', float),
            ('Description', 'description', unicode),
            ('Core', 'core_price', float),
            ('Substitution', 'substitution', unicode),
        )
        fields_map = dict([x[0:2] for x in mapping])
        fields_types_map = dict([x[1:3] for x in mapping])
        fields = [fields_map[x.strip()] for x in price.price.readline().split(sep)]

        success = 0
        with tempfile.TemporaryFile() as f:
            for counter, line in enumerate(price.price):
                if counter == 0:
                    continue

                data = {}
                for field, value in zip(fields, [x.strip() for x in line.split(sep)]):
                    if value:
                        data[field] = fields_types_map[field](value)

                if data.get('partnumber'):
                    f.write(self.row_for_copy(data))
                    success += 1

            self._copy(f)

        return success


class SavePartAnalog(Task):
    accept_magic_kwargs = False

    def run(self, filepath):
        try:
            mapping = (
                (u'БРЭНД1', 'brand_id', lambda x: Brand.objects.get(title__iexact=x).id),
                (u'АРТИКУЛ1', 'partnumber', unicode),
                (u'БРЭНД2', 'brand_analog_id', lambda x: Brand.objects.get(title__iexact=x).id),
                (u'АРТИКУЛ2', 'partnumber_analog', unicode),
                (u'КОММЕНТАРИЙ1', 'comment1', unicode),
                (u'КОММЕНТАРИЙ2', 'comment2', unicode),
            )
            fields = map(lambda x: x[1], mapping)

            def clean_fieldname(cell_title):
                return dict([(x[0], x[1]) for x in mapping])[cell_title.upper()]

            def clean_fieldvalue(cell_title, cell_value):
                cell_type = dict([(x[0], x[2]) for x in mapping])[cell_title.upper()]
                return cell_type(cell_value)

            def row_for_copy(data):
                row = ((data.get(field) or NULL_COPY) for field in fields)
                row = map(lambda x: str(("%s" % x).encode("UTF-8")), row)
                return "%s\n" % "\t".join(row)

            success = 1
            with tempfile.TemporaryFile() as f:
                with open(filepath, 'r') as file_contents:
                    xls = xlsreader.readexcel(file_contents=file_contents.read())
                    for sheet in xls.book.sheet_names():
                        for row in xls.iter_dict(sheet):
                            data = {}
                            for cell_title, cell_value in row.iteritems():
                                cleaned_fieldname = clean_fieldname(cell_title)
                                cleaned_fieldvalue = clean_fieldvalue(cell_title, cell_value)
                                data[cleaned_fieldname] = cleaned_fieldvalue
                            f.write(row_for_copy(data))
                            success += 1
                f.seek(0)
                cur = connection.cursor()
                cur.execute("""TRUNCATE TABLE data_partanalog""")
                cur.copy_from(f, 'data_partanalog', columns=fields)

        except Exception, e:
            logger.exception("%r" % e)
            send_mail(
                u"Загрузка аналогов прошла с ошибкой.",
                u"Аналоги загружены не были. Ошибка в строке %s" % (success + 1),
                settings.EMAIL_FROM,
                settings.MANAGERS_EMAILS,
                fail_silently=True
            )
            result = 'error!'
            raise
        else:
            send_mail(
                u"Загрузка аналогов прошла успешно.",
                u"Всего загружено %s аналогов." % (success - 1),
                settings.EMAIL_FROM,
                settings.MANAGERS_EMAILS,
                fail_silently=True
            )
            result = 'success: %s' % (success - 1)

        return result

tasks.register(SavePriceFileCsvTask)
tasks.register(SavePriceFileXlsTask)
tasks.register(SavePartAnalog)
