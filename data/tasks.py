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
        errors = []
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

            success_counter = 0
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
                try:
                    Part(**data).save()
                except:
                    continue
                else:
                    success_counter += 1
        except Exception, e:
            transaction.rollback()
            area.pricefile = None
            area.save()
            logger.exception("%r" % e)
            send_mail(u"Загрузка деталей для `%s` прошла с ошибкой." % area.title, 
                      u"Детали загружены не были.", 
                      settings.EMAIL_FROM, settings.MANAGERS_EMAILS, 
                      fail_silently=True)
            response = 'error!'
        else:
            transaction.commit()
            send_mail(u"Загрузка деталей для `%s` прошла успешно." % area.title, 
                      u"Всего загружено %s деталей." % success_counter, 
                      settings.EMAIL_FROM, settings.MANAGERS_EMAILS, 
                      fail_silently=True)
            response = 'ok!'
        finally:
            f.close()

        return response


tasks.register(SavePriceFileTask)