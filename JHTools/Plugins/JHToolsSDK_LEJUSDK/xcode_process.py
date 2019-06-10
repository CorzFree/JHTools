# -*- coding: utf-8 -*-

mods = {
    "group": "JHToolsSDK_LEJUSDK",
    "files": [
        #需要导入的静态库，bundle文件，以及自己生成的.a库
        "libJHToolsSDK_LEJUSDK.a"
    ],
    "folders": [
        "SDK"
    ],
    "frameworks": [
        #所依赖的原始库
       "ImageIO.framework"
    ],
    "libs": [
        #dylib，stdb库
             "libz.1.2.5.tbd",
             "libicucore.tbd",
             "libiconv.tbd",
             "libsqlite3.tbd",
             "libstdc++.tbd"
    ]
}

def post_process(self, project, infoPlist, sdkparams):
    project.add_other_ldflags('-ObjC')
    project.add_other_ldflags('-lsqlite3.0')
    project.enable_bitcode("NO")
    project.preprocessor_macros("HAVE_CONFIG_H")
    infoPlist["NSAppTransportSecurity"] = { "NSAllowsArbitraryLoads": True }
    self.addBundleURLType(CFBundleTypeRole="Editor",CFBundleURLName="sdk", CFBundleURLSchemes=["h5taogame.com1383560319"])
    self.addBundleURLType(CFBundleTypeRole="Editor",CFBundleURLName="weixin", CFBundleURLSchemes=["wx9efca7e13875a222"])
    self.addBundleURLType(CFBundleTypeRole="Editor",CFBundleURLName="qq", CFBundleURLSchemes=["tencent101379012"])
    self.addBundleURLType(CFBundleTypeRole="Editor",CFBundleURLName="weibo", CFBundleURLSchemes=["wb1220169449"])
