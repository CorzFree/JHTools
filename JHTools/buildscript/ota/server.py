#!/usr/bin/env python
# -*- coding: utf-8 -*-

from flask import Flask
from flask import request, url_for
from flask import render_template   
from flask import make_response
from flask import send_from_directory
import argparse
import re

from struct import unpack,pack

import time
import json
import os, sys
from fnmatch import fnmatch
import zipfile
import utils

from random import random

import OpenSSL
from OpenSSL import crypto

try:
    from urllib.parse import urljoin
except ImportError:
    from urlparse import urljoin

app = Flask(__name__)
shareDir = os.path.abspath(".")

re_ip = re.compile('\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$')

def make_ca_cert(CN = "JHToolsSDK OTA CA"):
    cakey = crypto.PKey()
    cakey.generate_key(crypto.TYPE_RSA, 2048)
    cacert = crypto.X509()
    cacert.set_version(2)
    sub = cacert.get_subject()
    sub.C="CN"
    sub.ST="Shanghai"
    sub.L="Pudong"
    sub.O="JHToolsSDK"
    sub.OU="ios"
    sub.CN=CN
    cacert.set_serial_number(int(OpenSSL.rand.bytes(8).encode('hex'), 16))
    cacert.gmtime_adj_notBefore(-3600*24)
    cacert.gmtime_adj_notAfter(3600*24*365*5)
    cacert.set_issuer(sub)
    cacert.set_pubkey(cakey)

    cacert.add_extensions([
        crypto.X509Extension(b'keyUsage', True, b'digitalSignature,keyEncipherment,keyCertSign'),
        crypto.X509Extension("subjectKeyIdentifier", False, "hash", subject=cacert),
        crypto.X509Extension(b'basicConstraints', True, b'CA:true')
        ])

    #cacert.add_extensions([
    #    crypto.X509Extension(b'authorityKeyIdentifier', False, "keyid:always", issuer=cacert)
    #    ])

    cacert.sign(cakey, 'sha256')

    return (cacert,cakey)

def make_server_cert(cacert, cakey, hostname):
    skey = crypto.PKey()
    skey.generate_key(crypto.TYPE_RSA, 2048)

    req = crypto.X509Req()
    sub = req.get_subject()
    sub.C="CN"
    sub.ST="Shanghai"
    sub.L="Pudong"
    sub.O="JHToolsSDK"
    sub.OU="ios"
    sub.CN=hostname
    
    req.set_pubkey(skey)
    req.sign(skey, "sha256")

    scert = crypto.X509()
    scert.set_version(2)
    scert.set_serial_number(int(OpenSSL.rand.bytes(8).encode('hex'), 16))
    scert.gmtime_adj_notBefore(0)
    scert.gmtime_adj_notAfter(3600*24*365*2)
    scert.set_issuer(cacert.get_subject())
    scert.set_subject(req.get_subject())
    scert.set_pubkey(req.get_pubkey())

    if re_ip.match(hostname):
        altName = b"IP:%s, DNS:%s"%(hostname,hostname)
    else:
        altName = b"DNS:%s"%(hostname)

    scert.add_extensions([
        crypto.X509Extension("subjectKeyIdentifier", False, "hash", subject=scert),
        crypto.X509Extension(b'keyUsage', True, b'digitalSignature,keyEncipherment'),
        crypto.X509Extension(b'extendedKeyUsage', True, b'serverAuth,clientAuth'),
        crypto.X509Extension(b'basicConstraints', True, b'CA:false'),
        crypto.X509Extension(b'subjectAltName', False, altName)
        ])

    scert.add_extensions([
        crypto.X509Extension(b'authorityKeyIdentifier', False, "keyid:always", issuer=cacert)
        ])

    scert.sign(cakey, 'sha256')

    return (scert,skey)

def get_ssl_context(hostname):
    if hostname == None:
        if os.path.isfile(ssl_cer) and os.path.isfile(ssl_key) and os.path.isfile(ca_cer):
            scert=crypto.load_certificate(crypto.FILETYPE_PEM, open(ssl_cer, 'rt').read())
            skey=crypto.load_privatekey(crypto.FILETYPE_PEM, open(ssl_key, 'rt').read())
            hostname = scert.get_subject().CN
            ssl_context = (ssl_cer, ssl_key)
        else:
            print("first time run must specify hostname!")
            exit(-1)
    else:
        ssl_context = make_ssl_cert(hostname)

    return (ssl_context, hostname)

ca_cer = os.path.join(app.root_path, "ca.cer")
ca_key = os.path.join(app.root_path, "ca.key")
ssl_cer = os.path.join(app.root_path, "ssl.cer")
ssl_key = os.path.join(app.root_path, "ssl.key")

def get_ssl_hostname(ssl_cer):
    scert=crypto.load_certificate(crypto.FILETYPE_PEM, open(ssl_cer, 'rt').read())
    return scert.get_subject().CN

def make_ssl_cert(hostname):
    cacert = None
    cakey = None
    if not os.path.isfile(ca_cer) or not os.path.isfile(ca_key):
        print("make_ca_cert")
        (cacert,cakey) = make_ca_cert()
    else:
        cacert=crypto.load_certificate(crypto.FILETYPE_PEM, open(ca_cer, 'rt').read())
        cakey=crypto.load_privatekey(crypto.FILETYPE_PEM, open(ca_key, 'rt').read())

    if (not os.path.isfile(ssl_cer) or 
        not os.path.isfile(ssl_key) or
        get_ssl_hostname(ssl_cer) != hostname):
        (scert,skey) = make_server_cert(cacert, cakey, hostname)

        with open(ca_cer, 'wb') as f:
            f.write(crypto.dump_certificate(crypto.FILETYPE_PEM, cacert))
        with open(ca_key, 'wb') as f:
            f.write(crypto.dump_privatekey(crypto.FILETYPE_PEM, cakey))

        with open(ssl_cer, 'wb') as f:
            f.write(crypto.dump_certificate(crypto.FILETYPE_PEM, scert))
        with open(ssl_key, 'wb') as f:
            f.write(crypto.dump_privatekey(crypto.FILETYPE_PEM, skey))

    return (ssl_cer, ssl_key)

@app.route('/plist/<filename>')
def plist(filename):
    ipafilename = os.path.splitext(filename)[0] + ".ipa"

    with zipfile.ZipFile(os.path.join(shareDir, ipafilename)) as ipazip:
        namelist = ipazip.namelist()
        infoplistfile = [f for f in ipazip.namelist() if fnmatch(f, "Payload/*.app/Info.plist")][0]

        infoplist = utils.plist_loadb(ipazip.read(infoplistfile))

        #icons = [ipazip.getinfo(appdir+f) for f in infoplist["CFBundleIconFiles"] if (appdir + f) in namelist and (f.find("57") != -1)]
        #icon = max(icons, key=lambda x:x.file_size).filename
        #iconurl = None
        #if (len(icons) > 0):
        #    iconurl = urljoin(request.url_root, "appicon/" + os.path.splitext(filename)[0] + "/" + os.path.basename(icon))

        ipaurl = urljoin(request.url_root, "ipa/" + ipafilename)
        template = render_template('ipa.plist', ipaurl=ipaurl, **infoplist)
        response = make_response(template)
        response.headers["Content-Type"] = "application/xml"
        
        return response

@app.route('/appicon/<filename>/<iconfile>')
def appicon(filename, iconfile):
    ipafilename = os.path.splitext(filename)[0] + ".ipa"

    with zipfile.ZipFile(os.path.join(shareDir, ipafilename)) as ipazip:
        infoplistfile = [f for f in ipazip.namelist() if fnmatch(f, "Payload/*.app/Info.plist")][0]

        appdir = os.path.dirname(infoplistfile)

        pngdata = ipazip.read(appdir + iconfile)

        response = make_response(pngdata)
        response.headers["Content-Type"] = "image/png"
        
        return response

def makeItmsLink(url_root, ipafile):
    plisturl = urljoin(url_root, "plist/" + os.path.splitext(ipafile)[0]+".plist")
    return "itms-services://?action=download-manifest&url=%s"%plisturl

@app.route('/JHToolssdk.cer')
def getcert():
    return send_from_directory(directory=app.root_path, filename="ca.cer", mimetype="application/pkix-cert")

@app.route('/ipa/<filename>')
def ipa(filename):
    return send_from_directory(directory=shareDir, filename=filename)

@app.route('/ipa_view/<filename>')
def ipa_view(filename):
    ipaInfo = dict(filename=filename)

    ipafilename = os.path.splitext(filename)[0] + ".ipa"

    with zipfile.ZipFile(os.path.join(shareDir, ipafilename)) as ipazip:
        namelist = ipazip.namelist()
        infoplistfile = [f for f in ipazip.namelist() if fnmatch(f, "Payload/*.app/Info.plist")][0]

        infoplist = utils.plist_loadb(ipazip.read(infoplistfile))

        ipaInfo["icon"] = "/appicon/%s/Icon.png"%filename
        ipaInfo["url"] = "/ipa/%s"%filename
        ipaInfo["itms_url"] = makeItmsLink(request.url_root, filename)

        if "CFBundleDisplayName" in infoplist:
            ipaInfo["name"] = infoplist["CFBundleDisplayName"]
        else:
            ipaInfo["name"] = infoplist["CFBundleName"]

        return render_template("ipa_view.html", info=ipaInfo)

@app.route('/')
def index():
    print(shareDir)
    if os.path.isdir(shareDir):
        ipafiles = os.listdir(shareDir)
        itmslinks = [dict(itmsUrl=makeItmsLink(request.url_root, f), url="ipa_view/%s"%f, name=f) for f in ipafiles if f.endswith(".ipa")]
    else:
        itmslinks = []

    return render_template('ipa_index.html', itmslinks=itmslinks)




