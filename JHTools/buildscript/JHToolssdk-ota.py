#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse

import time
import json
import os, sys
from fnmatch import fnmatch
import zipfile
import utils
import threading
import time
from random import random
import webbrowser
from OpenSSL import crypto
import traceback
import socket

try:
    from urllib.parse import urljoin
except ImportError:
    from urlparse import urljoin

try:
    from urllib2 import urlopen
except ImportError:
    from urllib.request import urlopen

import ota
from ota import app

class OpenBrowser(threading.Thread):

    def __init__(self, host, port, url):
        super(OpenBrowser, self).__init__()
        self.daemon = True
        self.host = host
        self.port = port
        self.url = url

    def notResponding(self):
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        return sock.connect_ex((self.host, self.port))

    def run(self):
        while self.notResponding():
           time.sleep(0.5)
        webbrowser.open_new(self.url)
        print('browser opened!')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(sys.argv[0])

    parser.add_argument('sharepath', help=u"要分享的ipa包目录")
    parser.add_argument('-n', '--hostname', help=u"主机名称， 可以是域名或者ip", nargs='?', default=None)
    parser.add_argument('-p', '--port', help=u"端口号", nargs='?', default=8000)

    args = parser.parse_args()

    app.debug=True

    ssl_context = None

    (ssl_context,args.hostname) = ota.get_ssl_context(args.hostname)

    if os.path.isdir(args.sharepath):
        ota.server.shareDir = os.path.abspath(args.sharepath)
        url = "https://%s:%s/"%(args.hostname, args.port)
    elif os.path.isfile(args.sharepath):
        if (args.sharepath.endswith(".ipa")):
            ota.server.shareDir = os.path.dirname(os.path.abspath(args.sharepath))
            url = "https://%s:%s/ipa_view/%s"%(args.hostname, args.port, os.path.basename(args.sharepath))
        else:
            print("The sharepath isn't a ipa file")
            exit(-1)
    else:
        print("The sharepath should be a directory or ipa file")
        exit(-1)

    OpenBrowser(args.hostname, args.port, url).start()
    app.run(host=args.hostname, port=int(args.port), ssl_context=ssl_context, use_reloader=False, threaded=True)

