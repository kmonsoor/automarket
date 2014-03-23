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
    mapping = ()

    def run(self, price):
        self.price = price
        if not self.price.price:
            return 'empty!'
        self._clear()
        success = self._save()
        return 'ok! saved %s parts!' % success

    def _clear(self):
        cur = connection.cursor()
        cur.execute("""
            DELETE FROM data_part
            WHERE area_id=%s AND brandgroup_id=%s
        """ % (self.price.area.id, self.price.brand_group.id)
        )
        cur.close()
        return True

    def _row_for_copy(self, data):
        row = [
            self.price.area.id,
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
            self.price.brand_group.id,
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

    def _save(self):
        fields_map = dict([x[0:2] for x in self.mapping])
        fields_types_map = dict([x[1:3] for x in self.mapping])

        with tempfile.TemporaryFile() as f:
            try:
                success = 0
                for counter, line in enumerate(self.iter_lines(self.price), 1):
                    if counter == 1:  # header
                        fields = [fields_map[x.upper()] for x in line]
                        continue
                    data = dict(
                        (f, fields_types_map[f](v))
                        for f, v in zip(fields, line)
                        if v)
                    if data.get('partnumber'):
                        f.write(self._row_for_copy(data))
                        success += 1
                self._copy(f)
            except Exception, e:
                logger.exception("%r", e)
                msg = u"Загрузка %s прошла с ошибкой. Ошибка в строке %s." % (
                    self.price.area.title, counter)
                send_mail(
                    msg, msg, settings.EMAIL_FROM,
                    settings.MANAGERS_EMAILS, fail_silently=True)
                raise
            else:
                logger.info(
                    "price saved for %s, %s items",
                    self.price.area.title, success)
                msg = u"Загрузка %s прошла успешно. Загружено %s позиций." % (
                    self.price.area.title, success)
                send_mail(
                    msg, msg, settings.EMAIL_FROM,
                    settings.MANAGERS_EMAILS, fail_silently=True)
                return success


class SavePriceFileXlsTask(SavePriceFileBase):
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

    def iter_lines(self, price):
        xls = xlsreader.readexcel(file_contents=price.price.read())
        for sheet in xls.book.sheet_names():
            for line in xls.iter_list(sheet):
                yield line


class SavePriceFileCsvTask(SavePriceFileBase):
    mapping = (
        ('PART#', 'partnumber', unicode),
        ('LISTPRICE', 'MSRP', float),
        ('COST', 'cost', float),
        ('DESCRIPTION', 'description', unicode),
        ('CORE', 'core_price', float),
        ('SUBSTITUTION', 'substitution', unicode),
    )

    def iter_lines(self, price):
        for line in price.price:
            yield (x.strip() for x in line.split('\t'))


class SavePartAnalog(Task):
    accept_magic_kwargs = False

    def run(self, filepath):
        mapping = (
            (u'БРЭНД1', 'brand_id', lambda x: Brand.objects.get(title__iexact=x).id),
            (u'АРТИКУЛ1', 'partnumber', unicode),
            (u'БРЭНД2', 'brand_analog_id', lambda x: Brand.objects.get(title__iexact=x).id),
            (u'АРТИКУЛ2', 'partnumber_analog', unicode),
            (u'КОММЕНТАРИЙ1', 'comment1', unicode),
            (u'КОММЕНТАРИЙ2', 'comment2', unicode),
        )
        all_fields = map(lambda x: x[1], mapping)
        fields_map = dict([x[0:2] for x in mapping])
        fields_types_map = dict([x[1:3] for x in mapping])

        def _row_for_copy(data):
            row = ((data.get(f) or NULL_COPY) for f in all_fields)
            row = map(lambda x: str(("%s" % x).encode("UTF-8")), row)
            return "%s\n" % "\t".join(row)

        success = 0
        try:
            with tempfile.TemporaryFile() as f:
                with open(filepath, 'r') as file_contents:
                    xls = xlsreader.readexcel(file_contents=file_contents.read())
                    for sheet in xls.book.sheet_names():
                        for counter, line in enumerate(xls.iter_list(sheet), 1):
                            if counter == 1:  # header
                                fields = [fields_map[x.upper()] for x in line]
                                continue
                            data = dict(
                                (f, fields_types_map[f](v))
                                for f, v in zip(fields, line)
                                if v)
                            if data.get('partnumber'):
                                f.write(_row_for_copy(data))
                                success += 1
                f.seek(0)
                cur = connection.cursor()
                cur.execute("""TRUNCATE TABLE data_partanalog""")
                cur.copy_from(f, 'data_partanalog', columns=all_fields)
                cur.close()
        except Exception, e:
            logger.exception("%r", e)
            msg = u"Загрузка аналогов прошла с ошибкой. Ошибка в строке %s." % counter
            send_mail(
                msg, msg, settings.EMAIL_FROM,
                settings.MANAGERS_EMAILS, fail_silently=True)
            raise
        else:
            logger.info("analogs saved, %s items", success)
            msg = u"Загрузка аналогов прошла успешно. Загружено %s позиций" % success
            send_mail(
                msg, msg, settings.EMAIL_FROM,
                settings.MANAGERS_EMAILS, fail_silently=True)
        return success

tasks.register(SavePriceFileCsvTask)
tasks.register(SavePriceFileXlsTask)
tasks.register(SavePartAnalog)
