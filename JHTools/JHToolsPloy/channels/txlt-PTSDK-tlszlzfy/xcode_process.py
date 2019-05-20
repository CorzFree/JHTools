# -*- coding: utf-8 -*-

mods = {
    "group": "JHToolsSDK_PTSDK",
    "files": [
        "libJHToolsSDK_PTSDK.a"
    ],
    "folders":[
        "SDK"
    ],
    "frameworks": [
        "SystemConfiguration.framework",
        "CFNetwork.framework",
        "JavaScriptCore.framework",
        "CoreMotion.framework",
        "CoreTelephony.framework",
        "CoreGraphics.framework"
    ],
    "libs": [
        "libc++.1.dylib",
        "libz.1.2.5.dylib",
        "libsqlite3.0.dylib",
        "libz.tbd"
    ]
}

#URLScheme设置
def post_process(self, project, infoPlist, sdkparams):
    self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName=self.getBundleId(), CFBundleURLSchemes=[self.getBundleId()])
    project.add_other_ldflags('-ObjC')
    project.enable_bitcode("NO")
    infoPlist["NSAppTransportSecurity"] = { "NSAllowsArbitraryLoads": True }
    self.addAppQueriesSchemes(["uppayx1", "uppayx2", "uppayx3", "alipay", "uppaysdk", "uppaywallet", "safepay", "cydia", "alipayauth", "weixin", "wechat"])
    infoPlist['NSPhotoLibraryAddUsageDescription'] = ""
    infoPlist['NSPhotoLibraryUsageDescription'] = ""
