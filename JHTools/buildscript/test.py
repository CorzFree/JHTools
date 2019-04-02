#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import sys
import os
import shutil
import traceback
import json
import copy
import time
import glob
import tempfile
import re
import plistlib
import OpenSSL

import unittest

import utils
from utils import error
from utils import system

import config


class JHToolsSDKTest(unittest.TestCase):
    #def test_find_match_provision(self):
    #    print(utils.find_match_provision("A42NAN47A6", "development", "com.baidu.com"))

    def test_configs(self):
        print(config.load_all_config(os.path.abspath("../JHToolstest")))

if __name__ == '__main__':
    unittest.main()
