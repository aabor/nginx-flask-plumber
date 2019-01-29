import sys
import os
import shutil
import json
import pandas as pd
import numpy as np
import string
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
from flask import Flask, jsonify, request, url_for
from flask import Flask, session
from flask_session import Session
import requests

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
    payload = {'msg': 'rnews echo test'}
    msg="rnews echo test"
    r = requests.get(os.path.join(url, 'echo'), params=payload)
    assert r.status_code == requests.codes.ok
    msg=(r.json()['msg'].strip())
    assert msg == 'The message is: \"rnews echo test\"'
def test_pause():
    duration=2
    r = requests.get(os.path.join(url, 'pause', str(duration)))
    assert r.status_code == requests.codes.ok
    assert r.text.strip() == 'Pause of 2 seconds finished'
def test_open_browser():
    r = requests.get(os.path.join(url, 'open_browser'))
    assert r.status_code == requests.codes.ok
def test_open_browser():
    r = requests.get(os.path.join(url, 'close_browser'))
    assert r.status_code == requests.codes.ok
def test_connectivity():
    r = requests.get(os.path.join(url, 'test_connectivity'))
    assert r.status_code == requests.codes.ok
    assert r.text.strip() == 'finished successfully'

