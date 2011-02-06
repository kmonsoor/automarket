#!/usr/bin/env bash

source ../bin/activate
export PYTHONPATH=.
python ./manage.py runfcgi protocol=scgi host=127.0.0.1 port=8085
