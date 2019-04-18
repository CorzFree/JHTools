# -*- coding: utf-8 -*-

mods = {
    "group": "JHToolsSDK_BORANSDK",
    "files": [
        #需要导入的静态库，bundle文件，以及自己生成的.a库
        "libJHToolsSDK_BORANSDK.a"
    ],
    "folders": [
        "SDK"
    ],
    "frameworks": [
        #所依赖的原始库
                   "AddressBook.framework",
                   "CoreGraphics.framework",
                   "CoreTelephony.framework",
                   "QuartzCore.framework",
                   "SystemConfiguration.framework",
                   "UIKit.framework",
                   "Foundation.framework",
                   "MessageUI.framework",
                   "AdSupport.framework",
                   "CoreText.framework",
                   "MobileCoreServices.framework",
                   "Security.framework",
                   "StoreKit.framework",
                   "CoreMotion.framework",
                   "CFNetwork.framework"
    ],
    "libs": [
        #dylib，stdb库
             "libsqlite3.tbd",
             "libz.tbd",
             "libstdc++.tbd",
             "libc++.tbd"
    ]
}

def post_process(self, project, infoPlist, sdkparams):
    infoPlist["NSAppTransportSecurity"] = { "NSAllowsArbitraryLoads": True }
    self.addAppQueriesSchemes(["alipay", "alipays","alipayshare","weixin", "wechat"])
    self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName="appScheme", CFBundleURLSchemes=["BoRantls"])
