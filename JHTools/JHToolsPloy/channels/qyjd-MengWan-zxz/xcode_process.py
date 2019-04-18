# -*- coding: utf-8 -*-

mods = {
    "group": "JHToolsSDK_MengWanSDK",
    "files": [
        "libJHToolsSDK_MengWanSDK.a"
    ],
    "folders":[
        "SDK"
    ],
    "frameworks": [
        "ImageIO.framework",
        "SystemConfiguration.framework",
        "CoreTelephony.framework",
        "Security.framework",
        "CFNetwork.framework",
        "AVFoundation.framework",
        "CoreMotion.framework"
    ],
    "libs": [
        "libc++.1.tbd",
        "libz.1.2.5.tbd",
        "libsqlite3.0.tbd"
    ]
}

#URLScheme设置
def post_process(self, project, infoPlist, sdkparams):
    infoPlist["NSAppTransportSecurity"] = { "NSAllowsArbitraryLoads": True }
    project.add_other_ldflags('-ObjC')
    project.enable_bitcode("NO")
    self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName="weixin", CFBundleURLSchemes=["wxde3be52e5a02231f"])
    self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName="tencent", CFBundleURLSchemes=["tencent1105801370"])
    self.addBundleURLType("gamesdkpayback")
    self.addAppQueriesSchemes(["MwPayPlugin", "weixin", "wechat", "mqqOpensdkSSoLogin", "mqqopensdkapiV2", "mqqopensdkapiV3", "wtloginmqq2", "mqq", "mqqapi"])
