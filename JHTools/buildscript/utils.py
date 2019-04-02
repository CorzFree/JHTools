# -*- coding: utf-8 -*-

import os
import collections
import subprocess
import plistlib
import glob
import re
import fnmatch
import tempfile

try:
   input = raw_input
except NameError:
   pass

try:
    plist_loads = plistlib.loads
    plistlib_isnew = True
except AttributeError:
    plist_loads = plistlib.readPlistFromString
    plistlib_isnew = False

def plist_loadb(bytes):
    if plistlib_isnew:
        return plist_loads(bytes)
    else:
        f = tempfile.NamedTemporaryFile(delete=False)
        f.write(bytes)
        f.close()
        system("plutil -convert xml1 \"%s\""%f.name)
        plistdata = plistlib.readPlist(f.name)
        os.remove(f.name)
        return plistdata

def plist_load(path):
    print("plutil -convert xml1 -o - \"%s\""%path)
    if plistlib_isnew:
        return plistlib.load(open(path, "rb"))
    else:
        with open(os.devnull, 'w') as devnull:
            plistcontent = subprocess.check_output("plutil -convert xml1 -o - \"%s\""%path, stderr=devnull, shell=True)
            return plist_loads(plistcontent)

def plist_write(object, path, binary=False):
    if plistlib_isnew:
        plistlib.dump(object, open(path, "wb"), fmt=(plistlib.FMT_BINARY if binary else plistlib.FMT_XML))
    else:
        plistlib.writePlist(object, path)
        if binary:
            system("plutil -convert binary1 \"%s\""%path)

def merge_dict(d1, d2):
    """
    Modifies d1 in-place to contain values from d2.  If any value
    in d1 is a dictionary (or dict-like), *and* the corresponding
    value in d2 is also a dictionary, then merge them in-place.
    """
    for k,v2 in d2.items():
        v1 = d1.get(k) # returns None if v1 has no value for this key
        if (isinstance(v1, collections.Mapping) and isinstance(v2, collections.Mapping) ):
            merge_dict(v1, v2)
        else:
            d1[k] = v2

def error(message):
	print(message)
	exit(1)

def system(cmd):
    if type(cmd) != str:
        cmd = cmd.encode('utf-8')
    return os.system(cmd)

def load_mobileprovision(provisionfile):
    with open(os.devnull, 'w') as devnull:
        plistcontent = subprocess.check_output("openssl smime -in \"%s\" -inform der -verify"%provisionfile, stderr=devnull, shell=True)
        return plist_loads(plistcontent)

def get_mobileprovision(name):
    for provisionfile in glob.glob(os.path.expanduser("~/Library/MobileDevice/Provisioning Profiles/*.mobileprovision")):
        plist = load_mobileprovision(provisionfile)
        if name == plist.get('Name') or name == plist.get('UUID'):
            return (plist,provisionfile)

    return (None,None)

def guess_provision_type(provisionInfo):
    entitlements = provisionInfo["Entitlements"]
    if entitlements['get-task-allow']:
        return "development"
    elif 'ProvisionedDevices' in provisionInfo:
        return "ad-hoc"
    else:
        return "app-store"

def match_bundleid(bundleId, provisionInfo):
    provisionBundleId = provisionInfo["Entitlements"].get("application-identifier")
    provisionBundleId = re.sub(r"^(\w+.)", "", provisionBundleId)

    return fnmatch.fnmatch(bundleId, provisionBundleId)

def find_match_provision(teamid, method, bundleId):
    method = method or "development"
    for provisionfile in glob.glob(os.path.expanduser("~/Library/MobileDevice/Provisioning Profiles/*.mobileprovision")):
        plist = load_mobileprovision(provisionfile)
        if (teamid in plist.get('TeamIdentifier') and
            guess_provision_type(plist) == method and 
            match_bundleid(bundleId, plist)):
            return plist,provisionfile

    return (None,None)
