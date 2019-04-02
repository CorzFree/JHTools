#!/usr/bin/env python
# -*- coding: utf-8 -*-


import os,sys
import shutil
import argparse
from collections import namedtuple
from collections import OrderedDict
import time
import glob
from datetime import datetime
from fnmatch import fnmatch
import tempfile
import re
import plistlib
import OpenSSL
import config

from mod_pbxproj.mod_pbxproj import load_mobileprovision
from mod_pbxproj.mod_pbxproj import install_provision
from mod_pbxproj.mod_pbxproj import get_cert_cn

import xcode_gen
import iconutils
from utils import error

def system(cmd):
    if type(cmd) == unicode:
        cmd = cmd.encode('utf-8')
    return os.system(cmd)

def get_mobileprovision(name):
    for provisionfile in glob.glob(os.path.expanduser("~/Library/MobileDevice/Provisioning Profiles/*.mobileprovision")):
        plist = load_mobileprovision(provisionfile)
        if name == plist.get('Name') or name == plist.get('UUID'):
            return (plist,provisionfile)

    return (None,None)
    
def copyAssets(src, dst):
    if not os.path.exists(src):
        return

    print("copyAssets from "+src+ " to " + dst)

    if not os.path.exists(dst):
        os.makedirs(dst)
        shutil.copystat(src,dst)

    for item in os.listdir(src):
        if item.startswith('.'):
            continue

        s = os.path.join(src, item)
        d = os.path.join(dst, item)

        if (os.path.isdir(s)):
            copyAssets(s, d)
        else:
            shutil.copy2(s, d)


def export_ipa(archivePath, exportPath, exportProvision, configDir = None):
    if exportProvision.endswith(".mobileprovision"):
        exportProvision = os.path.join(configDir, exportProvision)

        if not os.path.isfile(exportProvision):
            error("provision file not exist: %s"%exportProvision)
        provisionInfo = install_provision(exportProvision)
        provisionFile = exportProvision
    else:
        (provisionInfo, provisionFile) = get_mobileprovision(exportProvision)

    if (provisionFile == None):
        print("Can't find provision: " + exportProvision)
        return

    tempDir = tempfile.mkdtemp()

    tempArchivePath = os.path.join(tempDir, "archive")
    shutil.copytree(archivePath, tempArchivePath)

    archiveAppDir = glob.glob(os.path.join(tempArchivePath, "Products/Applications/*.app"))[0]
    shutil.copy2(provisionFile, archiveAppDir + "/embedded.mobileprovision")

    #certificate
    certBytes = provisionInfo['DeveloperCertificates'][0].data
    cert = OpenSSL.crypto.load_certificate(OpenSSL.crypto.FILETYPE_ASN1, certBytes)
    sign = cert.get_subject().commonName
    TeamID = cert.get_subject().organizationalUnitName

    # modify archived-expanded-entitlements.xcent
#    print archiveAppDir
#    archived_entitlements = plistlib.readPlist(archiveAppDir+"/archived-expanded-entitlements.xcent")
#    
#    if 'application-identifier' in archived_entitlements:
#        archived_entitlements['application-identifier'] = re.sub(r"^(\w+.)", TeamID+".", archived_entitlements['application-identifier'])
#
#    if 'keychain-access-groups' in archived_entitlements:
#        archived_entitlements['keychain-access-groups'] = [re.sub(r"^(\w+.)", TeamID+".", item) for item in archived_entitlements['keychain-access-groups']]
#
#    plistlib.writePlist(archived_entitlements, archiveAppDir+"/archived-expanded-entitlements.xcent")

    # modify info.plist
    archivePlist = plistlib.readPlist(tempArchivePath+"/Info.plist")
    archivePlist["ApplicationProperties"]["SigningIdentity"] = sign
    plistlib.writePlist(archivePlist, tempArchivePath+"/Info.plist")

    print("\n\ncodesign %s\n \n"%sign);
    entitlements = provisionInfo["Entitlements"]
    plistlib.writePlist(entitlements, os.path.join(tempDir, "entitlements.plist"))

    retValue = system("/usr/bin/codesign -s \"%s\" -fv --entitlements %s --no-strict \"%s\""%(sign, os.path.join(tempDir, "entitlements.plist"), tempArchivePath))
    if retValue != 0:
        print("codesign failed!")
        exit(1)

    exportOptionPlist = os.path.join(tempDir, "exportOptions.plist")
    exportOptions = {"uploadSymbols": False}

    if entitlements['get-task-allow']:
        exportOptions['method'] = "development"
    elif 'ProvisionedDevices' in provisionInfo:
        exportOptions['method'] = "ad-hoc"
    else:
        exportOptions['method'] = "app-store"

    exportOptions["teamID"] = TeamID
    plistlib.writePlist(exportOptions, exportOptionPlist)
    cmd = "xcodebuild -exportArchive -archivePath \"%s\" -exportPath \"%s\" -exportOptionsPlist \"%s\""%(tempArchivePath, tempDir, exportOptionPlist)
    ret = system(cmd)

    if ret == 0:
        ipaPath = glob.glob(os.path.join(tempDir, "*.ipa"))[0]
        shutil.move(ipaPath, exportPath)
        print(exportPath)

        dSYMExportPath = exportPath.replace("ipa", "app.dSYM")
        dSYMPath = glob.glob(os.path.join(tempDir, "archive/dSYMs/*"))[0]
        shutil.move(dSYMPath, dSYMExportPath)

        dirPath = os.path.dirname(exportPath)
        print dirPath

        appName = os.path.basename(os.path.dirname(dirPath))
        print appName
        #放到共享盘
        if  os.path.exists("/Volumes/xiyou/ios_ipa/"):
            sharePath = os.path.join("/Volumes/xiyou/ios_ipa/", appName)
            if not os.path.exists(sharePath):
                os.makedirs(sharePath)    
            system('scp -r %s /Volumes/xiyou/ios_ipa/%s/'%(dirPath, appName)) 
        else:
            print("共享盘目录错误")    

        #上传fir.im
        system("fir login a4da3f304b1ca2c958a326333b44af62")
        system('fir publish %s'%(exportPath))

        #上传蒲公英
        #system('curl -F "file=@%s" \-F "uKey=6a39afcea0b3c7e8e0c478916522020f" \-F "_api_key=8e89ca37c188330e2ab40ce873c3f559" \http://www.pgyer.com/apiv1/app/upload'%(exportPath))
        

    return ret

def export_last_archive(channelConfig, workspace):
    target_name = None
    if 'target' in channelConfig:
        target_name = channelConfig['target']

    product_name = channelConfig["product_name"]
    #provision = channelConfig["provision"]

    if not os.path.isabs(workspace):
        workspace = os.path.abspath(workspace)
    channelConfigPath = os.path.join(workspace, "channels", channel["name"])

    folderName = '%s_%s'%(channelConfig['appName'], time.strftime('%Y%m%d%H%M'))
    channelAppName = '%s-%s'%(channelConfig['appName'], channelConfig['desc'])
    exportPath = os.path.join(workspace, 'release', channelAppName, folderName)
    #exportPath = os.path.join(workspace, 'release', channelConfig['appName'], time.strftime('%Y%m%d%H%M'))
    if not os.path.exists(exportPath):
        os.makedirs(exportPath)

#    archivePath = glob.glob(os.path.expanduser("~/Library/Developer/Xcode/Archives/*/%s_%s_*.xcarchive"%(product_name, channelConfig['name'])))
    archivePath = glob.glob(os.path.expanduser("~/Library/Developer/Xcode/Archives/*/%s*.xcarchive"%(product_name)))
    if len(archivePath) == 0:
        print("can't find archive for %s_%s"%(product_name, channelConfig['name']))
        exit(-1)
    else:
        archivePath = archivePath[-1]
    archiveName = '%s_%s'%(channelConfig['appName'], time.strftime('%Y%m%d%H%M'))
    exportProvision = None
    
    if 'exportProvision' in channelConfig:
        exportProvision = channelConfig['exportProvision']
    elif 'provision' in channelConfig:
        exportProvision = channelConfig['provision']

    if exportProvision:
        if type(exportProvision) in (str, unicode):
            exportIpaPath = os.path.join(exportPath,'%s.ipa'%archiveName)
            retValue = export_ipa(archivePath, exportIpaPath, exportProvision, channelConfigPath)
        elif type(exportProvision) == list:
            for idx,provision in enumerate(exportProvision):
                exportIpaPath = os.path.join(exportPath,'%s_%s.ipa'%(archiveName, idx))
                retValue = export_ipa(archivePath, exportIpaPath, provision, channelConfigPath)
                if retValue != 0:
                    exit(1)
        elif type(exportProvision) == dict:
            for key,provision in exportProvision.items():
                exportIpaPath = os.path.join(exportPath, '%s_%s.ipa'%(archiveName, key))
                retValue = export_ipa(archivePath, exportIpaPath, provision, channelConfigPath) 
                if retValue != 0:
                    exit(1)
        else:
            print(type(exportProvision))
    else:
        exportIpaPath = os.path.join(exportPath,'%s.ipa'%archiveName)
        appdir = glob.glob(os.path.join(archivePath, "Products/Applications/*.app"))[0]
        retValue = export_ipa(archivePath, exportIpaPath, os.path.join(appdir,"embedded.mobileprovision"))
    if retValue != 0:
        exit(1)

def build_target(channelConfig, workspace, xcodeproj, buildConfig):
    target_name = None
    if 'target' in channelConfig:
        target_name = channelConfig['target']

    scheme_name = target_name or os.path.splitext(os.path.basename(xcodeproj))[0]
    product_name = channelConfig["product_name"]
    #provision = channelConfig["provision"]

    if not os.path.isabs(workspace):
        workspace = os.path.abspath(workspace)
    channelConfigPath = os.path.join(workspace, "channels", channel["name"])


    folderName = '%s_%s'%(channelConfig['appName'], time.strftime('%Y%m%d%H%M'))
    channelAppName = '%s-%s'%(channelConfig['appName'], channelConfig['desc'])
    exportPath = os.path.join(workspace, 'release', channelAppName, folderName)
    if not os.path.exists(exportPath):
        os.makedirs(exportPath)

    archiveName = '%s_%s'%(channelConfig['appName'], time.strftime('%Y%m%d%H%M'))

    #调用xcode命令行进行打包
    old_cwd = os.getcwd()
    os.chdir(os.path.dirname(xcodeproj))

    if not buildConfig and 'BuildConfig' in channelConfig:
        buildConfig = channelConfig['BuildConfig']

    if buildConfig:
        retValue = system('xcodebuild  -configuration %s'%buildConfig)
        if retValue == 0:
            productApp = [ f for f in glob.glob('build/%s-iphoneos/*.app'%buildConfig)][0]
            exportIpaPath = os.path.join(exportPath,'%s.ipa'%archiveName)
            cmd = 'xcrun -sdk iphoneos PackageApplication -v "%s" -o "%s"'%(productApp, exportIpaPath)
            retValue = system(cmd)
    else:
        archivePath = os.path.expanduser("~/Library/Developer/Xcode/Archives/%s/%s_%s.xcarchive"%(time.strftime('%Y-%m-%d'), product_name, archiveName))
        cmd = 'xcodebuild -project "%s" -scheme %s archive -archivePath "%s"'%(xcodeproj, scheme_name, archivePath)
        retValue = system(cmd)

        if retValue != 0:
            print('xcode build failed!')
            exit(1)

        appdir = glob.glob(os.path.join(archivePath, "Products/Applications/*.app"))[0]

        exportProvision = None
        if 'exportProvision' in channelConfig:
            exportProvision = channelConfig['exportProvision']
        elif 'provision' in channelConfig:
            exportProvision = channelConfig['provision']

        if exportProvision:
            if type(exportProvision) in (str, unicode):
                exportIpaPath = os.path.join(exportPath,'%s.ipa'%archiveName)
                retValue = export_ipa(archivePath, exportIpaPath, exportProvision, channelConfigPath)
            elif type(exportProvision) == list:
                for idx,provision in enumerate(exportProvision):
                    exportIpaPath = os.path.join(exportPath,'%s_%s.ipa'%(archiveName, idx))
                    retValue = export_ipa(archivePath, exportIpaPath, provision, channelConfigPath)
                    if retValue != 0:
                        print("fail to export ipa")
                        exit(1)
            elif type(exportProvision) == dict:
                for key,provision in exportProvision.items():
                    exportIpaPath = os.path.join(exportPath, '%s_%s.ipa'%(archiveName, key))
                    retValue = export_ipa(archivePath, exportIpaPath, provision, channelConfigPath) 
                    if retValue != 0:
                        print("fail to export ipa")
                        exit(1)
            else:
                print(type(exportProvision))
        else:
            exportIpaPath = os.path.join(exportPath,'%s.ipa'%archiveName)
            export_ipa(archivePath, exportIpaPath, os.path.join(appdir,"embedded.mobileprovision"))

    os.chdir(old_cwd)

    if retValue != 0:
        exit(1)

def selectValidDir(*paths):
    for base,child in paths:
        if (base and os.path.isdir(os.path.join(base, child))):
            return os.path.join(base, child)

    return None

def find_dir(name, path):
    for root,dirs,files in os.walk(path):
        if name in dirs:
            return os.path.join(root, name)

def find_file(name, path):
    for root,dirs,files in os.walk(path):
        if name in files:
            return os.path.join(root, name)

#处理文件覆盖
def process_overrideAssets(srcRoot, workspace, channel, folder):
    """处理文件覆盖

    srcRoot 是xcode工程所在目录
    workspace 是打包配置目录
    channel 是渠道配置数据
    folder 是要处理的文件夹
    """
    channelAssetsPath = os.path.join(workspace, "channels", channel["name"], folder)
    commonAssetsPath = os.path.join(workspace, "common", folder)

    # 渠道目录下的文件优先覆盖common目录下的文件
    overrideAssets = {}
    if os.path.isdir(commonAssetsPath):
        for f in os.listdir(commonAssetsPath):
            overrideAssets[f] = os.path.join(commonAssetsPath, f)

    if os.path.isdir(channelAssetsPath):
        for f in os.listdir(channelAssetsPath):
            overrideAssets[f] = os.path.join(channelAssetsPath, f)

    for f,path in overrideAssets.items():
        if (os.path.isdir(path)):
            # 要覆盖的是目录
            baseAssetFolder = find_dir(f, srcRoot)
            if baseAssetFolder:
                shutil.rmtree(baseAssetFolder)
                shutil.copytree(path, baseAssetFolder)
            else:
                print('no matched folder to override:' + path)
        elif os.path.isfile(path):
            # 要覆盖的是文件
            baseAssetFile = find_file(f, srcRoot)
            if baseAssetFile:
                os.remove(baseAssetFile)
                shutil.copy2(path, baseAssetFile)
            else:
                print('no matched file to override:' + path)

#处理文件覆盖
def process_overrideGameAssets(srcRoot, workspace, channel):
    process_channelScript(srcRoot, workspace, channel)

    channelAssetsPath = os.path.join(workspace, "channels", channel["name"], "ChannelResource")

    overrideAssets = {}

    if os.path.isdir(channelAssetsPath):
        for f in os.listdir(channelAssetsPath):
            overrideAssets[f] = os.path.join(channelAssetsPath, f)

    for f,path in overrideAssets.items():
        if (os.path.isdir(path)):
            # 要覆盖的是目录
            baseAssetFolder = find_dir(f, srcRoot)
            
            if baseAssetFolder:
                shutil.rmtree(baseAssetFolder)
                shutil.copytree(path, baseAssetFolder)
            else:
                print('no matched folder to override:' + path)

        elif os.path.isfile(path):
            # 要覆盖的是文件
            baseAssetFile = find_file(f, srcRoot)
            if baseAssetFile:
                os.remove(baseAssetFile)
                shutil.copy2(path, baseAssetFile)
            else:
                print('no matched file to override:' + path)

#调用渠道资源配置脚本
def process_channelScript(srcRoot, workspace, channel):
    script = os.path.join(workspace, "channels", channel["name"], "ChannelResource", "resource_config.py")

    if not os.path.isfile(script):
        return

    try:
        processScript = {}
        processScript['__file__'] = script
        execfile(script, processScript)
        processScript['configPlatform'](srcRoot, workspace, channel)
    except Exception as e:
        print(u"处理脚本%s执行出现异常!"%script)
        traceback.print_exc()
        sys.exit(-1)


# 处理图片资源（AppIcon， LaunchImage)
def process_imageassets(srcRoot, workspace, channel):
    channelConfigPath = os.path.join(workspace, "channels", channel["name"])
    commonConfigPath = os.path.join(workspace, "common")

    overrideAssets = {}
    for f in os.listdir(commonConfigPath):
        if (fnmatch(f, '*.launchimage') or 
            fnmatch(f, '*.imageset')):
            overrideAssets[f] = os.path.join(commonConfigPath, f)

    for f in os.listdir(channelConfigPath):
        if (fnmatch(f, '*.launchimage') or
            fnmatch(f, '*.imageset')):
            overrideAssets[f] = os.path.join(channelConfigPath, f)

    for f,path in overrideAssets.items():
        if (os.path.isdir(path)):
            # 要覆盖的是目录
            baseAssetFolder = find_dir(f, srcRoot)
            if baseAssetFolder:
                shutil.rmtree(baseAssetFolder)
                shutil.copytree(path, baseAssetFolder)
            else:
                print('no matched folder to override:' + path)

def process_appiconsets(srcRoot, workspace, channel, pluginRoot):
    channelConfigPath = os.path.join(workspace, "channels", channel["name"])
    commonConfigPath = os.path.join(workspace, "common")

    overrideAssets = {}
    for f in os.listdir(commonConfigPath):
        if (fnmatch(f, '*.appiconset')):
            overrideAssets[f] = os.path.join(commonConfigPath, f)

    for f in os.listdir(channelConfigPath):
        if (fnmatch(f, '*.appiconset')):
            overrideAssets[f] = os.path.join(channelConfigPath, f)

    for f,path in overrideAssets.items():
        if (os.path.isdir(path)):
            # 要覆盖的是目录
            baseAssetFolder = find_dir(f, srcRoot)
            if baseAssetFolder:
                shutil.rmtree(baseAssetFolder)
                shutil.copytree(path, baseAssetFolder)
            else:
                print('no matched folder to override:' + path)

            iconutils.addIconCorner(baseAssetFolder, channel, pluginRoot)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(sys.argv[0])

    parser.add_argument('xcodeproj', help=u"基础xcode工程路径(扩展名为.xcodeproj)")

    parser.add_argument('-p', '--pluginpath', help=u"JHToolsSDK插件目录，默认为Plugins")
    parser.add_argument('workspace', help=u"工作目录")
    parser.add_argument('-c', '--channel', help=u"要处理的渠道名")
    parser.add_argument('-a', '--asset', help=u"全资源包,指定资源包目录")
    parser.add_argument('-n', '--nobuild', help=u"不编译，只处理xcode工程", action='store_true')
    parser.add_argument('-k', '--keep', help=u"不删除已有的渠道工程，否则重新从基础工程拷贝", action='store_true')
    parser.add_argument('-b', '--buildconfig', help=u"项目配置",  nargs='?', const='Release', default=None)
    parser.add_argument('-f', '--fast', help=u"直接编译渠道工程", action='store_true')
    parser.add_argument('-e', '--exportlast', help=u"只导出最新编译的归档，不处理xcode工程", action='store_true')

    args = parser.parse_args()

    if args.xcodeproj.endswith("/"):
        args.xcodeproj = os.path.dirname(args.xcodeproj)

    if not args.xcodeproj.endswith(".xcodeproj"):
        #print("无效的xcode工程目录, 必须以.xcodeproj结尾")
        find_xcodeprojs = [d for d in os.listdir(args.xcodeproj) if d.endswith('.xcodeproj')]
        if len(find_xcodeprojs) == 0:
            print("目录%s下找不到xcode项目(.xcodeproj)"%args.xcodeproj)
            exit(-1)
        elif len(find_xcodeprojs) > 1:
            print("在目录%s下发现有多个xcode项目")
            exit(-1)
        else:
            args.xcodeproj = os.path.join(args.xcodeproj, find_xcodeprojs[0])

    if args.pluginpath == None:
        args.pluginpath = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "Plugins")

    if not os.path.isdir(args.pluginpath):
        print("插件目录不存在: \"%s\""%args.pluginpath)
        exit(-1)

    if not os.path.isdir(args.workspace):
        print("工作目录不存在: \"%s\""%args.workspace)
        exit(-1)

    allchannels = config.load_all_config(args.workspace)

    targets = []

    targetinput = args.channel

    if (targetinput == None):
        print(u"*****************渠道列表*****************")

        # print("Config目录(AppID-ChannelID)  \t\t 出包游戏名  \t\t 聚合平台 \t\t ChannelName-原游戏")
        print("%-30s  \t %-25s  \t %-15s \t %s"%("%s(%s-%s)"%("configDir", "AppID", "ChannelID"), "游戏名", "platformName", "ChannelSDK-游戏",))
        for channel in allchannels:
            print("%-30s  \t %-18s  \t %-15s \t %s"%("%s(%s-%s)"%(channel["name"], channel['JHToolsSDK']['AppID'], channel['JHToolsSDK']['Channel']), channel["appName"], channel["platform"], channel["desc"],))

    while True:
        if (targetinput == None):
            sys.stdout.write(u"渠道列表匹配规则（支持通配符, 用逗号分割)：\n渠道名列表-要排除的渠道名列表\n请输入需要打包的渠道:")
            sys.stdout.flush()

            targetinput = raw_input()

        #包括-排除
        targetinput = targetinput.split(' ')

        targetNames = OrderedDict()
        for t in targetinput[0].split(','):
            t = t.strip()

            matchChannels = [c for c in allchannels if fnmatch(c['name'].lower(), t.lower())]
            for c in matchChannels:
                targetNames[c['name']] = c

        if len(targetinput) > 1:
            for t in targetinput[1].split(','):
                t = t.strip()

                matchChannels = [c for c in allchannels if fnmatch(c['name'].lower(), t.lower())]

                for c in matchChannels:
                    print c
                    if c['name'] in targetNames:
                        targetNames.pop(c['name'])

        targetinput = None

        targets = [c for c in targetNames.values()]
        if (len(targets) == 0):
            print('无效的渠道名！！!')
        else:
            break

    starttime = datetime.now()

    for channel in targets:
        # 基础工程主目录，取xcodeproj的上一级目录
        # 对于非Unity引擎工程，可能需要修改此方法
        baseSrcRoot = os.path.abspath(os.path.join(args.xcodeproj, ".."))
        if (baseSrcRoot.endswith('/')):
            baseSrcRoot = os.path.dirname(baseSrcRoot)

        # 拷贝基础工程到工作目录
        if os.path.isdir(os.path.join(args.workspace, "projects")):
            targetSrcRoot = os.path.join(args.workspace, "projects", os.path.basename(baseSrcRoot) + '.' + channel["name"])
        else:
            targetSrcRoot = baseSrcRoot + '.' + channel["name"]

        if (args.exportlast):
            export_last_archive(channel, args.workspace)
            continue

        if ( (not args.keep and not args.fast) and os.path.exists(targetSrcRoot) ):
            shutil.rmtree(targetSrcRoot)

        if (not os.path.isdir(targetSrcRoot)):
            shutil.copytree(baseSrcRoot, targetSrcRoot)

        targetXcodeProj = os.path.join(targetSrcRoot, os.path.basename(args.xcodeproj))

        if not args.fast:
            # 拷贝资源
            if args.asset:
                copyAssets(args.asset, os.path.join(targetSrcRoot, 'Data/Raw'))
            copyAssets(os.path.join(args.workspace, "channels", channel["name"], "Appends"), targetSrcRoot)

            # 处理Icon、闪屏图片资源
            process_imageassets(targetSrcRoot, args.workspace, channel)
            process_appiconsets(targetSrcRoot, args.workspace, channel, args.pluginpath)
            process_overrideAssets(targetSrcRoot, args.workspace, channel, "LaunchScreen")
            process_overrideAssets(targetSrcRoot, args.workspace, channel, "Overrides")
            process_overrideGameAssets(targetSrcRoot, args.workspace, channel)
            # 处理xcode工程文件
            xcode_gen.modify_xcode(args.xcodeproj, targetXcodeProj, args.pluginpath, args.workspace, channel)
        else:
            if not args.buildconfig:
                args.buildconfig = 'Release'

        if args.nobuild:
            continue
        
        build_target(channel, args.workspace, os.path.abspath(targetXcodeProj), args.buildconfig)
        print(u'处理完成！总共耗时: %s'%str(datetime.now() - starttime))

