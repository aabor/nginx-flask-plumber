import sys, os
import logging
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
from tabulate import tabulate
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from flask import Flask, jsonify
from flask import Flask, session
from flask_session import Session

url="http://pnews:5000"
def test_main_page():
  r = requests.get(url)
  assert r.status_code == requests.codes.ok
  assert r.text == 'Service pnews (language python) is ready!'

# class SimpleTest(unittest.TestCase):
#     @unittest.skip("demonstrating skipping")
#     def test_skipped(self):
#         self.fail("shouldn't happen")

#     def test_pass_assert_equal(self):
#         self.assertEqual(10, 7 + 3)

#     def test_pass_not_equal(self):
#         self.assertNotEqual(11, 7 + 3)

    # def test_fail(self):
    #     self.assertEqual(11, 7 + 3)


# if __name__ == '__main__':
#     import xmlrunner
#     unittest.main(testRunner=xmlrunner.XMLTestRunner(output='test-reports'))