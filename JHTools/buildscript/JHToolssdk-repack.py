#!/usr/bin/env python
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
import config
import app_process
import zipfile

import utils

from utils import error
from utils import system
from ipapackage import package_ipa

def extractIpa(ipafile, workdir):
    zf = zipfile.ZipFile(ipafile, 'r')
    zf.extractall(workdir)
    zf.close()

if __name__ == '__main__':
    parser = argparse.ArgumentParser("JHToolssdk export")

    parser.add_argument('ipafile', help=u"基础ipa文件路径(扩展名为.ipa)")
    parser.add_argument('configdir', help=u"配置目录")

    parser.add_argument('-c', '--channel', help=u"渠道名")
    parser.add_argument('-s', '--suffix', help=u"配置文件的后缀", nargs='?', default=None)
    parser.add_argument('-a', '--asset', help=u"附加资源包,指定资源包目录")

    args = parser.parse_args()

    channelConfig = None
    if args.channel != None:
        channelConfig = config.load_config(args.configdir, args.channel, args.suffix)

    if 'suffix' in channelConfig:
        ipaFileName = '%s_%s_%s'%(channelConfig['name'], channelConfig['suffix'], time.strftime('%Y%m%d%H%M'))
    else:
        ipaFileName = '%s_%s'%(channelConfig['name'], time.strftime('%Y%m%d%H%M'))

    #默认输出目录
    outputPath = os.path.join(args.configdir, "release/%s.ipa"%ipaFileName)

    workDir = tempfile.mkdtemp()
    extractIpa(args.ipafile, workDir)
    tempPayloadPath = os.path.join(workDir, "Payload")

    app_process.process(tempPayloadPath, args.configdir, channelConfig, workDir)

    package_ipa(tempPayloadPath, os.path.abspath(outputPath), args.configdir, channelConfig, workDir)
