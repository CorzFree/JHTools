#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''
xcode_gen
修改XCode项目文件
'''

import sys,os
import plistlib
import argparse
import json
import glob
import shutil
import fileinput
import re
import mod_pbxproj
import collections
import copy
import traceback

from mod_pbxproj import XcodeProject
from mod_pbxproj.mod_pbxproj import XCBuildConfiguration
from mod_pbxproj.mod_pbxproj import install_provision
from utils import error

#设置编译的架构
def XCBuildConfiguration_set_archs(self, archs):
    modified = False
    base = 'buildSettings'
    key = 'ARCHS'

    if base not in self:
        self[base] = PBXDict()

    if key in self[base]:
        if self[base][key] != archs:
            self[base][key] = archs       
            modified = True    
    else:
        self[base][key] = archs

    return modified

def XCBuildConfiguration_set_sdk(self, sdk):
    modified = False
    base = 'buildSettings'
    key = 'SDKROOT'

    if base not in self:
        self[base] = PBXDict()

    if key in self[base]:
        if self[base][key] != sdk:
            self[base][key] = sdk
            modified = True

    return modified

def XCBuildConfiguration_preprocessor_macros(self, preprocessorMacros):
    modified = False
    base = 'buildSettings'
    key = 'GCC_PREPROCESSOR_DEFINITIONS'

    if base not in self:
        self[base] = PBXDict()

    if (not (key in self[base])) or (self[base][key] != preprocessorMacros):
        self[base][key] = preprocessorMacros
        modified = True
    return modified

def XCBuildConfiguration_enable_bitcode(self, enable):
    modified = False
    base = 'buildSettings'
    key = 'ENABLE_BITCODE'

    if base not in self:
        self[base] = PBXDict()

    if (not (key in self[base])) or (self[base][key] != enable):
        self[base][key] = enable
        modified = True

    return modified

def XCBuildConfiguration_enable_objc_exception(self, enable_objc_exception):
    modified = False
    base = 'buildSettings'
    key = 'GCC_ENABLE_OBJC_EXCEPTIONS'

    if base not in self:
        self[base] = PBXDict()

    if (not (key in self[base])) or (self[base][key] != enable_objc_exception):
        self[base][key] = enable_objc_exception
        modified = True

    return modified

def XCBuildConfiguration_c_language_standard(self, c_language_standard):
    modified = False
    base = 'buildSettings'
    key = 'GCC_C_LANGUAGE_STANDARD'

    if base not in self:
        self[base] = PBXDict()

    if (not (key in self[base])) or (self[base][key] != c_language_standard):
        self[base][key] = c_language_standard
        modified = True

    return modified

def XCBuildConfiguration_enable_objc_weak(self, enable_objc_weak):
    modified = False
    base = 'buildSettings'
    key = 'CLANG_ENABLE_OBJC_WEAK'

    if base not in self:
        self[base] = PBXDict()

    if (not (key in self[base])) or (self[base][key] != enable_objc_weak):
        self[base][key] = enable_objc_weak
        modified = True

    return modified

XCBuildConfiguration.set_archs = XCBuildConfiguration_set_archs
XCBuildConfiguration.set_sdk = XCBuildConfiguration_set_sdk
XCBuildConfiguration.enable_bitcode = XCBuildConfiguration_enable_bitcode
XCBuildConfiguration.preprocessor_macros = XCBuildConfiguration_preprocessor_macros
XCBuildConfiguration.enable_objc_exception = XCBuildConfiguration_enable_objc_exception
XCBuildConfiguration.c_language_standard = XCBuildConfiguration_c_language_standard
XCBuildConfiguration.enable_objc_weak = XCBuildConfiguration_enable_objc_weak

def XcodeProject_set_archs(self, archs):
    build_configs = [b for b in self.objects.values() if b.get('isa') == 'XCBuildConfiguration']

    for b in build_configs:
        if b.set_archs(archs):
            self.modified = True

def XcodeProject_set_sdk(self, sdk):
    build_configs = [b for b in self.objects.values() if b.get('isa') == 'XCBuildConfiguration']

    for b in build_configs:
        if b.set_sdk(sdk):
            self.modified = True

def XcodeProject_enable_bitcode(self, enable):
    build_configs = [b for b in self.objects.values() if b.get('isa') == 'XCBuildConfiguration']

    for b in build_configs:
        if b.enable_bitcode(enable):
            self.modified = True

def XcodeProject_preprocessor_macros(self, preprocessorMacros):
    build_configs = [b for b in self.objects.values() if b.get('isa') == 'XCBuildConfiguration']

    for b in build_configs:
        if b.preprocessor_macros(preprocessorMacros):
            self.modified = True

def XcodeProject_enable_objc_exception(self, enable_objc_exception):
    build_configs = [b for b in self.objects.values() if b.get('isa') == 'XCBuildConfiguration']

    for b in build_configs:
        if b.enable_objc_exception(enable_objc_exception):
            self.modified = True

def XcodeProject_c_language_standard(self, c_language_standard):
    build_configs = [b for b in self.objects.values() if b.get('isa') == 'XCBuildConfiguration']

    for b in build_configs:
        if b.c_language_standard(c_language_standard):
            self.modified = True

def XcodeProject_enable_objc_weak(self, enable_objc_weak):
    build_configs = [b for b in self.objects.values() if b.get('isa') == 'XCBuildConfiguration']

    for b in build_configs:
        if b.enable_objc_weak(enable_objc_weak):
            self.modified = True

XcodeProject.set_archs = XcodeProject_set_archs
XcodeProject.set_sdk = XcodeProject_set_sdk
XcodeProject.enable_bitcode = XcodeProject_enable_bitcode
XcodeProject.preprocessor_macros = XcodeProject_preprocessor_macros
XcodeProject.enable_objc_exception = XcodeProject_enable_objc_exception
XcodeProject.c_language_standard = XcodeProject_c_language_standard
XcodeProject.enable_objc_weak = XcodeProject_enable_objc_weak

class XcodeProcess:
    def __init__(self, baseProject, dstProject, target_name, configPath, channelConfig):
        self.project = mod_pbxproj.XcodeProject.Load(os.path.join(baseProject, "project.pbxproj"))
        self.configPath = configPath
        self.channelConfigPath = os.path.join(configPath, 'channels', channelConfig['name'])
        self.channelConfig = channelConfig

        baseSrcRoot = self.project.source_root
        XcodeProcess.forceload_libs = []

        self.project.migrate_to_path(dstProject)

        target = self.project.get_target(target_name)

        if target == None:
            print("Can't find target \"%s\" in project \"%s\""%(target_name, baseProject))
            sys.exit(-1)

        infoPlistFile = os.path.join(baseSrcRoot, target.get_buildconfigs()[0]['buildSettings']['INFOPLIST_FILE'])
        infoPlist = plistlib.readPlist(infoPlistFile)

        self.target = target
        self.infoPlist = infoPlist
        self.srcRoot = self.project.source_root
        self.projectPath = dstProject

    @property
    def commonConfigDir(self):
        return os.path.join(self.configPath, "common")

    @property
    def channelConfigDir(self):
        return os.path.join(self.configPath, self.channelConfig['name'])

    def filter_duplicates(self, seq):
        seen = set()
        seen_add = seen.add
        return [x for x in seq if not (x in seen or seen_add(x))]

    def save(self):
        if 'CFBundleURLTypes' in self.infoPlist and len(self.infoPlist['CFBundleURLTypes']) == 0:
            self.infoPlist.pop('CFBundleURLTypes')

        if 'LSApplicationQueriesSchemes' in self.infoPlist:
            self.infoPlist['LSApplicationQueriesSchemes'] = self.filter_duplicates(self.infoPlist['LSApplicationQueriesSchemes'])

        infoPlistFile = os.path.join(self.srcRoot, self.target.get_buildconfigs()[0]['buildSettings']['INFOPLIST_FILE'])
        plistlib.writePlist(self.infoPlist, infoPlistFile)

        self.project.add_forceload_libs(self.forceload_libs)

        self.project.save(os.path.join(self.projectPath, "project.pbxproj"))

    def getBundleId(self):
        return self.infoPlist['CFBundleIdentifier']

    def addBundleURLType(self, CFBundleURLSchemes, CFBundleURLName = None, CFBundleTypeRole = "Editor"):
        urltype = {
            "CFBundleTypeRole":CFBundleTypeRole,
            "CFBundleURLSchemes": CFBundleURLSchemes
        }

        if CFBundleURLName != None:
            urltype["CFBundleURLName"] = CFBundleURLName

        if (not 'CFBundleURLTypes' in self.infoPlist):
            self.infoPlist['CFBundleURLTypes'] = []

        self.infoPlist['CFBundleURLTypes'].append(urltype)

    def add_forceload(self, libpath):
        self.forceload_libs.append(self.project.get_relative_path(libpath))

    def addAppQueriesSchemes(self, items):
        if not isinstance(items, list):
            items = [items]

        if not 'LSApplicationQueriesSchemes' in self.infoPlist:
            self.infoPlist['LSApplicationQueriesSchemes'] = items
        else:
            self.infoPlist['LSApplicationQueriesSchemes'].extend(items)

    @staticmethod
    def merge_dict(d1, d2):
        """
        Modifies d1 in-place to contain values from d2.  If any value
        in d1 is a dictionary (or dict-like), *and* the corresponding
        value in d2 is also a dictionary, then merge them in-place.
        """
        for k,v2 in d2.items():
            v1 = d1.get(k) # returns None if v1 has no value for this key
            if (isinstance(v1, collections.Mapping) and isinstance(v2, collections.Mapping) ):
                XcodeProcess.merge_dict(v1, v2)
            else:
                d1[k] = v2

    def updateInfoPlist(self, m):
        XcodeProcess.merge_dict(self.infoPlist, m)

    def getInfoJHToolsSDKParams(self):
        if 'JHToolsSDK' in self.infoPlist:
            return self.infoPlist['JHToolsSDK']

        ret = {}
        self.infoPlist['JHToolsSDK'] = ret

        return ret

    # 添加iphone竖屏支持（应对银联充值闪退）
    def addOrientationPortrait(self):
        if 'UISupportedInterfaceOrientations' in self.infoPlist and not 'UIInterfaceOrientationPortrait' in self.infoPlist['UISupportedInterfaceOrientations']:
            # 如果游戏是横屏，则为iPhone添加竖屏支持
            # ipad不需要添加
            if not 'UISupportedInterfaceOrientations~ipad' in self.infoPlist:
                self.infoPlist['UISupportedInterfaceOrientations~ipad'] = list(self.infoPlist['UISupportedInterfaceOrientations'])

            self.infoPlist['UISupportedInterfaceOrientations'].append('UIInterfaceOrientationPortrait')

    def getInfoJHToolsSDKPlugins(self):
        JHToolssdkparams = self.getInfoJHToolsSDKParams()
        if 'Plugins' in JHToolssdkparams:
            return JHToolssdkparams['Plugins']

        ret = []
        JHToolssdkparams['Plugins'] = ret

        return ret

    def addPlugin(self, name, params):
        plugins = self.getInfoJHToolsSDKPlugins()

        plugin = [p for p in plugins if (p['name'] ==  name)]
        
        if (len(plugin) > 0):
            XcodeProcess.merge_dict(plugin[0], params)
        else:
            params['name'] = name
            plugins.append(params)

    def post_process(self, script, params):
        if not os.path.isfile(script):
            return

        self.scriptDir = os.path.abspath(os.path.dirname(script))

        try:
            processScript = {}
            processScript['__file__'] = script
            execfile(script, processScript)

            if 'mods' in processScript:
                self.project.apply_mods(processScript['mods'], self.scriptDir)

            processScript['post_process'](self, self.project, self.infoPlist, params)
        except Exception as e:
            print(u"处理脚本%s执行出现异常!"%script)
            traceback.print_exc()
            sys.exit(-1)

    def embed_binary(self, path):
        path = os.path.join(self.scriptDir, path)
        self.target.embed_binary(os.path.relpath(path,self.srcRoot))

    def remove_file(self, path):
        path = os.path.join(self.scriptDir, path)
        self.project.remove_file_by_path(os.path.relpath(path, self.srcRoot))
    
def modify_xcode(baseProject, xcode_project, pluginRoot, configPath, channelConfig):
    if not os.path.isabs(configPath):
        configPath = os.path.abspath(configPath)

    channelConfigDir = os.path.join(configPath, "channels", channelConfig['name'])

    if 'provision' in channelConfig:
        if channelConfig['provision'].endswith(".mobileprovision"):
            provisionFile = os.path.join(channelConfigDir, channelConfig['provision'])
            if not os.path.isfile(provisionFile):
                error("provision file not exist: %s"%provisionFile)
            provisionInfo = install_provision(provisionFile)
            channelConfig['provision'] = provisionInfo['UUID']
    
    if xcode_project.endswith("/"):
        xcode_project = os.path.dirname(xcode_project)
    
    target_name = None

    if 'target' in channelConfig:
        target_name = channelConfig['target']
    else:
        target_name = os.path.splitext(os.path.basename(xcode_project))[0]


    processor = XcodeProcess(baseProject, xcode_project, target_name, configPath, channelConfig)

    # 通用处理脚本
    processor.post_process(os.path.join(os.path.dirname(__file__), 'xcode_process.py'), channelConfig)

    # 自定义通用处理脚本
    processor.post_process(os.path.join(configPath, 'common/xcode_process.py'), channelConfig)

    # 插件处理脚本
    for plugin in channelConfig['plugins']:
        plugin_dir = get_plugin_dir(pluginRoot, plugin)

        if not os.path.isdir(plugin_dir):
            error("Can't find plugin: " + plugin['name'])
            continue

        pluginparams = processor.post_process(os.path.join(plugin_dir, 'xcode_process.py'), plugin)
        if pluginparams == None:
            pluginparams = plugin

        # 如果返回False，不添加插件
        if pluginparams:
            processor.addPlugin(plugin['name'], pluginparams)

            libplugin = os.path.join(get_plugin_dir(pluginRoot, plugin), "libJHToolsSDK_%s.a"%plugin['name'])
            processor.add_forceload(libplugin)

    # 渠道处理脚本
    processor.post_process(os.path.join(channelConfigDir, 'xcode_process.py'), channelConfig)

    processor.save()
    
def get_plugin_dir(pluginRoot, plugin):
    return os.path.join(pluginRoot, 'JHToolsSDK_' + plugin['name'])


