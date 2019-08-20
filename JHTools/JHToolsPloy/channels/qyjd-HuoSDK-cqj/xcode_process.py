# -*- coding: utf-8 -*-

mods = {
    "group": "JHToolsSDK_HuoSDK",
    "files": [
        "libJHToolsSDK_HuoSDK.a"
    ],
    "folders":[
        "SDK"
    ],
    "compiler_flags":{
        "-fno-objc-arc":[
            "OpenUDID.m"
        ]
    },
    "frameworks": [
        "CoreGraphics.framework",
        "QuartzCore.framework",
        "AdSupport.framework",
        "CoreFoundation.framework",
        "UIKit.framework",
        "Security.framework",
        "CoreText.framework",
        "CoreTelephony.framework",
        "CFNetwork.framework",
        "AVFoundation.framework",
        "CoreMotion.framework",
        "CoreLocation.framework",
        "ImageIO.framework",
        "JavaScriptcore.framework",
        "SystemConfiguration.framework",
        "StoreKit.framework"
    ],
    "libs": [
        "libc++.dylib",
        "libc++.1.dylib",
        "libz.1.2.5.dylib",
        "libiconv.dylib",
        "libicucore.dylib",
        "libsqlite3.0.dylib"
    ]
}

#URLScheme设置
def post_process(self, project, infoPlist, sdkparams):
    project.add_other_ldflags('-ObjC')
    project.enable_bitcode("NO")
    project.preprocessor_macros("HAVE_CONFIG_H")
    project.enable_objc_exception("YES")
    self.addAppQueriesSchemes(["weixin", "alipay", "wechat", "safepay", "uppaysdk", "uppaywallet", "uppayx1", "uppayx2", "uppayx3", "mqqapi", "alipays", "mqq", "mqqOpensdkSSoLogin", "mqqconnect", "mqqopensdkapi", "mqqopensdkapiV2", "mqzoneopensdk", "wtloginmqq", "wtloginmqq2"])
    infoPlist["NSAppTransportSecurity"] = { "NSAllowsArbitraryLoads": True }
    self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName="huosdk", CFBundleURLSchemes=["huosdk"+self.getBundleId()])
    self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName="huosdk", CFBundleURLSchemes=["huosdk6073"])
    self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName="wx", CFBundleURLSchemes=["wx9efca7e13875a222"])
    self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName="qq", CFBundleURLSchemes=["tencent101379012"])
    self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName="wb", CFBundleURLSchemes=["wb1220169449"])
    self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName="sdk", CFBundleURLSchemes=["had1717.com607382"])
    infoPlist['NSPhotoLibraryAddUsageDescription'] = ""
    infoPlist['NSPhotoLibraryUsageDescription'] = ""
