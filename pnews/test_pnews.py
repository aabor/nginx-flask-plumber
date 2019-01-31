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
print(os.getcwd())
sys.path.insert(0, '/home/jovyan/work/nginx-flask-plumber/pnews')
from helpers import create_payload, post_text_data, accept_text_data

url="http://pnews:5000"
def test_main_page():
    r = requests.get(url)
    assert r.status_code == requests.codes.ok
    assert r.text.strip() == 'Service pnews (language python) is ready!'
def test_health():
    r = requests.get(os.path.join(url, 'health'))
    assert r.status_code == requests.codes.ok
    assert r.text.strip() == 'Healthy'
def test_echo():
    payload = {'msg': 'pnews echo test'}
    r = requests.get(os.path.join(url, 'echo'), params=payload)
    assert r.status_code == requests.codes.ok
    msg=(r.json()['msg'].strip())
    assert msg == 'The message is: \"pnews echo test\"'
def test_pause():
    duration=2
    r = requests.get(os.path.join(url, 'pause', str(duration)))
    assert r.status_code == requests.codes.ok
    assert r.text.strip() == 'Pause of 2 seconds finished'
def test_browser_session():
    r = requests.get(os.path.join(url, 'browser_session'))
    assert r.status_code == requests.codes.ok
# def test_close_browser():
#     r = requests.get(os.path.join(url, 'close_browser'))
#     assert r.status_code == requests.codes.ok
def test_POST_df_to_rnews():
    r=post_text_data(data_type="df", url="http://rnews:5000")
    assert r.status_code == requests.codes.ok
    assert r.json()[0] == 'message accepted'
def test_POST_sr_to_rnews():
    r=post_text_data(data_type="sr", url="http://rnews:5000")
    assert r.status_code == requests.codes.ok
    assert r.json()[0] == 'message accepted'
def test_POST_df_to_pnews():
    r=post_text_data(data_type="df", url="http://pnews:5000")
    assert r.status_code == requests.codes.ok
    assert r.json() == 'message accepted'
def test_POST_sr_to_pnews():
    r=post_text_data(data_type="sr", url="http://pnews:5000")
    assert r.status_code == requests.codes.ok
    assert r.json() == 'message accepted'
def test_connectivity():
    r = requests.post(os.path.join("http://rnews:5000", "test_connectivity"), data="")
    assert r.status_code == requests.codes.ok
    assert r.json()[0] == 'finished successfully'

