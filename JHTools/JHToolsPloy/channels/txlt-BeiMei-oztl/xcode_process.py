# -*- coding: utf-8 -*-

mods = {
    "group": "JHToolsSDK_BeiMei",
    "files": [
           #需要导入的静态库，bundle文件，以及自己生成的.a库
           "libJHToolsSDK_BeiMei.a"
    ],
    "folders": [
           "SDK"
    ],
    "frameworks": [
           #所依赖的原始库
           "CoreGraphics.framework",
           "CoreTelephony.framework",
           "CoreMotion.framework",
           "CoreText.framework",
           "QuartzCore.framework",
           "SystemConfiguration.framework",
           "JavaScriptCore.framework",
           "CFNetwork.framework",
           "Security.framework",
           "AVFoundation.framework",
           "MobileCoreServices.framework",
           "QuickLook.framework"
    ],
    "libs": [
           #dylib，stdb库
           "libicucore.tbd",
           "libc++.1.tbd",
           "libc++.tbd",
           "libz.tbd",
           "libz.1.2.5.tbd",
           "libsqlite3.0.tbd",
           "libsqlite3.tbd"
    ]
}

def post_process(self, project, infoPlist, sdkparams):
    infoPlist["NSAppTransportSecurity"] = { "NSAllowsArbitraryLoads": True }
    self.addAppQueriesSchemes(["alipay", "alipayqr", "alipayshare", "alipays","weixin", "wechat","bmyxbox"])
    self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName="zhifubao", CFBundleURLSchemes=["bmyxtljqios"])
    self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName="weixin", CFBundleURLSchemes=["bmyxtljqios"])
    self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName="yxbox", CFBundleURLSchemes=["bmyx1"])
    self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName="yxbox", CFBundleURLSchemes=["bmyxtljqiosbox"])
    project.add_other_ldflags('-ObjC')
    project.enable_bitcode("NO")
