# coding=utf-8
import logging
logger = logging.getLogger('data.tasks')

from django.db import transaction
from django.core.mail import send_mail
from django.conf import settings

from celery.task import Task
from celery.registry import tasks

from lib import xlsreader
from data.models import Part, Brand


class SavePriceFileBase(Task):
    accept_magic_kwargs = False

    @transaction.commit_manually
    def run(self, price):
        self.presave_parts(price)
        transaction.commit()

        f = price.price
        if not f:
            return 'ok!'

        try:
            success = self.save_parts(price)
        except Exception, e:
            transaction.rollback()
            logger.exception("%r" % e)
            send_mail(u"Загрузка деталей для `%s` прошла с ошибкой." % price.area.title,
                      u"Детали загружены не были.",
                      settings.EMAIL_FROM, settings.MANAGERS_EMAILS,
                      fail_silently=True)
            response = 'error!'
        else:
            transaction.commit()
            send_mail(u"Загрузка деталей для `%s` прошла успешно." % price.area.title,
                      u"Всего загружено %s деталей." % success,
                      settings.EMAIL_FROM, settings.MANAGERS_EMAILS,
                      fail_silently=True)
            response = 'ok!'
        finally:
            f.close()

        return response

    def presave_parts(self, price):
        Part.objects\
            .filter(area=price.area, brandgroup=price.brand_group)\
            .delete()

    def get_parts(self, price):
        raise NotImplementedError

    def save_parts(self, price):
        success = 0
        for cleaned_data in self.get_parts(price):
            kwargs = {
                'partnumber': cleaned_data.pop('partnumber'),
                'area': cleaned_data.pop('area'),
                'brandgroup': cleaned_data.pop('brandgroup'),
                'defaults': cleaned_data,
            }
            obj, created = Part.objects.get_or_create(**kwargs)
            if not created:
                for field, value in cleaned_data.iteritems():
                    setattr(obj, field, value)
                obj.save()
                continue
            success += 1
        return success


class SavePriceFileXlsTask(SavePriceFileBase):

    def get_parts(self, price):
        mapping = (
           (u'БРЭНД', 'brand', lambda x: Brand.objects.get(title__iexact=x)),
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

        xls = xlsreader.readexcel(file_contents=price.price.read())
        for sheet in xls.book.sheet_names():
            for row in xls.iter_dict(sheet):
                cleaned_data = {
                    'area': price.area,
                    'brandgroup': price.brand_group,
                }
                for cell_title, cell_value in row.iteritems():
                    cleaned_fieldname = clean_fieldname(cell_title)
                    cleaned_fieldvalue = clean_fieldvalue(cell_title, cell_value)
                    cleaned_data[cleaned_fieldname] = cleaned_fieldvalue
                yield cleaned_data


class SavePriceFileCsvTask(SavePriceFileBase):

    def get_parts(self, price):
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

        for line in price.price.xreadlines():
            cleaned_data = {
                'area': price.area,
                'brandgroup': price.brand_group,
            }
            for field, value in zip(fields, [x.strip() for x in line.split(sep)]):
                try:
                    value = fields_types_map[field](value) or None
                    cleaned_data[field] = value
                except:
                    continue
            yield cleaned_data

tasks.register(SavePriceFileCsvTask)
tasks.register(SavePriceFileXlsTask)
