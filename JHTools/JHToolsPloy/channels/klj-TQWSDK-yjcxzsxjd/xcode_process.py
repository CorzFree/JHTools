# -*- coding: utf-8 -*-

mods = {
    "group": "JHToolsSDK_TQWSDK",
    "files": [
        "libJHToolsSDK_TQWSDK.a"
    ],
    "folders":[
        "SDK"
    ],
    "frameworks": [
        "Accelerate.framework",
        "JavaScriptcore.framework",
        "CoreMotion.framework",
        "CoreTelephony.framework",
        "CoreGraphics.framework",
        "SystemConfiguration.framework",
        "CFNetwork.framework"
    ],
    "libs": [
        "libc++.1.dylib",
        "libz.1.2.5.dylib",
        "libsqlite3.0.dylib"
    ]
}

#URLScheme设置
def post_process(self, project, infoPlist, sdkparams):
    project.add_other_ldflags('-ObjC')
    infoPlist["NSAppTransportSecurity"] = { "NSAllowsArbitraryLoads": True }
    self.addAppQueriesSchemes(["alipay", "alipayauth","safepay","weixin","wechat"])
    self.addBundleURLType([self.getBundleId()])
    self.addBundleURLType(["wxaeb1a7cda56257b5"])
    self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName=self.getBundleId(), CFBundleURLSchemes=["wxaeb1a7cda56257b5"])
