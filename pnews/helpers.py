import sys
import os
import io
import shutil
import logging, logging.config, yaml
from logging.handlers import RotatingFileHandler
from logging import Formatter, FileHandler, StreamHandler
import json
import pandas as pd
import numpy as np
import string
from io import StringIO
import random
import math
import time
import re
from datetime import datetime
from datetime import date
from datetime import timedelta
from datetime import timezone
from pytz import timezone
import pytz
import pause
import humanfriendly
from bs4 import BeautifulSoup
from tabulate import tabulate
from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from flask import Flask, session, render_template, request, jsonify, redirect, g, url_for
import requests

working_time_zone='Europe/Kiev'
alpari_date_format="%m/%d/%Y"
fh_time_format="%Y-%m-%d %H:%M:%S"
fh_date_format='%Y-%m-%d'
def create_test_df():
    date_rng = pd.date_range(start='2019-01-24', end='2019-01-25', freq='H')
    l=len(date_rng)
    dts = pd.to_datetime(date_rng, format=fh_time_format)  
    hashes=[''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(3)) for x in range(l)]
    ns=list(range(l))
    vs=random.sample(range(100), l)
    d={'dt': dts, "event":hashes, "number": ns, "value": vs}
    df=pd.DataFrame(d)
    df['dt']=[dt.strftime('%Y-%m-%d %H:%M:%S') for dt in df.dt]
    return df.head()
def create_test_series():
    date_rng = pd.date_range(start='2019-01-24', end='2019-01-25', freq='H')
    l=len(date_rng)
    dts = pd.to_datetime(date_rng, format=fh_time_format)  
    ns=list(range(l))
    vs=random.sample(range(100), l)
    d={'dt': dts, "number": ns, "value": vs}
    df=pd.DataFrame(d)
    df['dt']=[dt.strftime('%Y-%m-%d %H:%M:%S') for dt in df.dt]
    return df.head()
def create_payload(data_type="sr"):
    if data_type not in ['sr', 'df']:
        raise Exception("Invalid data_type! " + data_type)
        return None
    output = StringIO()
    if data_type == "df":
        df=create_test_df()
        output.write(df.to_csv(index=False))
    if data_type == 'sr':
        sr=create_test_series()
        output.write(sr.to_csv(index=False))
    payload = {"spec":data_type, "text":output.getvalue()}
    output.close()
    return payload
def post_text_data(data_type="sr", url="http://pnews:5000", endpoint="text_message"):
    payload=create_payload(data_type)
    data=json.dumps(payload)
    url_path=os.path.join(url, endpoint)
    headers = {'Content-Type': 'application/json',}
    return requests.post(url_path, data=data, headers=headers)
def accept_text_data(payload):
    output = StringIO(payload['text'])
    msg=output.getvalue()
    df=pd.read_csv(output)
    output.close()    
    return df
def write_request_json(out_file='test.json'):
    df=create_test_df()
    df.head()
    df.to_json(out_file)
    df1=pd.read_json(out_file)
    df1.head()
def read_response_json(in_file='response.json'):
    df=pd.read_json(in_file)
    df.head()