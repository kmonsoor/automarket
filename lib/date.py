# -*- coding=utf-8 -*-
import datetime

def date_month_ago(date=None):
    if date is None:
        date = datetime.date.today()
        _d = date - datetime.timedelta(weeks=4)
    return datetime.date(_d.year, _d.month, date.day)

def date_today():
    return datetime.date.today()