# -*- coding: utf-8 -*-

mods = {
    "group": "JHToolsSDK_XSDK",
    "files": [
        #需要导入的静态库，bundle文件，以及自己生成的.a库
        "libJHToolsSDK_XSDK.a"
    ],
    "folders": [
        "SDK"
    ],
    "frameworks": [
        #所依赖的原始库
                   "CoreMotion.framework",
                   "CFNetwork.framework",
                   "CoreTelephony.framework",
                   "CoreText.framework",
                   "SystemConfiguration.framework",
                   "JavaScriptCore.framework",
                   "MessageUI.framework",
                   "Foundation.framework",
                   "UIKit.framework",
                   "QuartzCore.framework",
                   "CoreGraphics.framework"
    ],
    "libs": [
        #dylib，stdb库
             "libsqlite3.0.tbd",
             "libstdc++.tbd",
             "libz.tbd",
             "libc++.tbd",
             "libicucore.tbd"
    ]
}

def post_process(self, project, infoPlist, sdkparams):
    project.add_other_ldflags('-ObjC')
    self.addAppQueriesSchemes(["weixin", "wechat", "alipay", "safepay", "alipayshare"])
    infoPlist["NSAppTransportSecurity"] = { "NSAllowsArbitraryLoads": True }
    infoPlist['NSPhotoLibraryAddUsageDescription'] = ""
    infoPlist['NSPhotoLibraryUsageDescription'] = ""
    self.addBundleURLType(["ZWEi5XLgVenQ"])
    self.addBundleURLType(["QBW9LXogVwCLlQ7AJVYO52qhYsFd6Sk3"])
