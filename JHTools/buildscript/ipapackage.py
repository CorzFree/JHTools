#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import utils
import glob
import OpenSSL
import re
import tempfile

def package_ipa(payloadPath, exportPath, configDir, channelConfig, workDir=None):
    if workDir == None:
        workDir = tempfile.mkdtemp()

    tempAppDir = glob.glob(os.path.join(payloadPath, "*.app"))[0]

    exportProvision = None
    provisionInfo = None
    provisionFile = None

    if channelConfig != None:
        if 'provision' in channelConfig:
            exportProvision = channelConfig['provision']
        elif 'DevelopmentTeam' in channelConfig:
            infoPlist = utils.plist_load(os.path.join(tempAppDir, "Info.plist"))
            DevelopmentTeam = channelConfig['DevelopmentTeam']
            (provisionInfo, provisionFile) = utils.find_match_provision(DevelopmentTeam, channelConfig.get('export-method'), infoPlist['CFBundleIdentifer'])
            if provisionInfo == None:
                error("Can't find matched provision for team(%s) and (%s)"%(DevelopmentTeam,infoPlist['CFBundleIdentifer']))
                exit(1)

    if exportProvision != None:
        if exportProvision.endswith(".mobileprovision"):
            exportProvision = os.path.join(configDir, channelConfig['name'], exportProvision)

            if not os.path.isfile(exportProvision):
                error("provision file not exist: %s"%exportProvision)
                
            provisionInfo = utils.load_mobileprovision(exportProvision)
            provisionFile = exportProvision
        else:
            (provisionInfo, provisionFile) = utils.get_mobileprovision(exportProvision)

        if (provisionFile == None):
            print("Can't find provision: " + exportProvision)
            exit(1)

    if provisionFile != None:
        shutil.copy2(provisionFile, tempAppDir + "/embedded.mobileprovision")
    else:
        provisionInfo = utils.load_mobileprovision(tempAppDir + "/embedded.mobileprovision")

    #certificate
    certBytes = provisionInfo['DeveloperCertificates'][0]
    certBytes = certBytes if type(certBytes) == str else certBytes.data
    cert = OpenSSL.crypto.load_certificate(OpenSSL.crypto.FILETYPE_ASN1, certBytes)
    sign = cert.get_subject().commonName
    TeamID = cert.get_subject().organizationalUnitName

    # modify archived-expanded-entitlements.xcent
    archived_entitlements = utils.plist_load(tempAppDir+"/archived-expanded-entitlements.xcent")
    archived_entitlements['application-identifier'] = re.sub(r"^(\w+.)", TeamID+".", archived_entitlements['application-identifier'])

    if 'keychain-access-groups' in archived_entitlements:
        archived_entitlements['keychain-access-groups'] = [re.sub(r"^(\w+.)", TeamID+".", item) for item in archived_entitlements['keychain-access-groups']]

    utils.plist_write(archived_entitlements, tempAppDir+"/archived-expanded-entitlements.xcent")

    print("\n\ncodesign %s\n \n"%sign);
    entitlements = provisionInfo["Entitlements"]
    utils.plist_write(entitlements, os.path.join(workDir, "entitlements.plist"))
    print("/usr/bin/codesign -s \"%s\" -fv --entitlements %s --no-strict \"%s\""%(sign, os.path.join(workDir, "entitlements.plist"), tempAppDir))
    retValue = utils.system("/usr/bin/codesign -s \"%s\" -fv --entitlements %s --no-strict \"%s\""%(sign, os.path.join(workDir, "entitlements.plist"), tempAppDir))

    #TODO: 支持动态库签名

    if retValue != 0:
        print("codesign failed!")
        exit(1)

    os.chdir(os.path.dirname(payloadPath))
    print(exportPath)
    cmd = "zip -qry \"%s\" Payload"%(exportPath)
    ret = utils.system(cmd)

    return ret
