# coding=utf-8
import logging
logger = logging.getLogger('data.tasks')

from django.db import transaction
from django.core.mail import send_mail
from django.conf import settings

from celery.task import Task
from celery.registry import tasks
from data.models import Part, Area


class SavePriceFileTask(Task):
    accept_magic_kwargs = False

    @transaction.commit_manually
    def run(self, area):
        Part.objects.filter(area=area).delete()
        try:
            f = area.pricefile
            if not f:
                transaction.commit()
                return 'ok!'
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
            fields = [fields_map[x.strip()] for x in f.readline().split(sep)]

            for line in f.xreadlines():
                data = {}
                for field, value in zip(fields, [x.strip() \
                                                 for x in line.split(sep)]):
                    try:
                        value = fields_types_map[field](value) or None
                        data[field] = value
                    except:
                        continue
                data.update({'area': area})
                Part(**data).save()
        except Exception, e:
            transaction.rollback()
            logger.exception("%r" % e)
            send_mail(u"Загрузка цен для `%s` прошла с ошибкой", 
                      u"Цены из файла `%s` загружены не были." % \
                      area.pricefile.name, 
                      settings.EMAIL_FROM, settings.MANAGERS_EMAILS, 
                      fail_silently=True)
            response = 'error!'
        else:
            transaction.commit()
            send_mail(u"Загрузка цен для `%s` прошла успешно" % area.title, 
                      u"Цены из файла `%s` успешно загружены." % \
                      area.pricefile.name, 
                      settings.EMAIL_FROM, settings.MANAGERS_EMAILS, 
                      fail_silently=True)
            response = 'ok!'
        finally:
            f.close()

        return response


tasks.register(SavePriceFileTask)