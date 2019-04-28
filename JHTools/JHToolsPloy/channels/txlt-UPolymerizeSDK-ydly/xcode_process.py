# -*- coding: utf-8 -*-

mods = {
    "group": "JHToolsSDK_UPolymerizeSDK",
    "files": [
              #需要导入的静态库，bundle文件，以及自己生成的.a库
              "libJHToolsSDK_UPolymerizeSDK.a"
              ],
              "folders":[
                         "SDK"
                         ],
              "frameworks": [
                             #所依赖的原始库
                             "CoreData.framework",
                             "JavaScriptCore.framework",
                             "CoreMotion.framework",
                             "CFNetwork.framework",
                             "QuartzCore.framework",
                             "coreText.framework",
                             "CoreTelephony.framework",
                             "WebKit.framework",
                             "CoreFoundation.framework",
                             "CoreGraphics.framework",
                             "Foundation.framework",
                             "ImageIO.framework",
                             "MobileCoreServices.framework",
                             "Security.framework",
                             "SystemConfiguration.framework",
                             "UIKit.framework"
                             ],
              "libs": [
                       #dylib，stdb库
                       "libresolv.tbd",
                       "libc++.1.tbd",
                       "libz.1.2.5.tbd",
                       "libsqlite3.0.tbd"
                       ]
}

def post_process(self, project, infoPlist, sdkparams):
    self.embed_binary("SDK/UPolymerizeSDK.framework")
    self.embed_binary("SDK/Frameworks/Channel/otherSDK/ChannelSDK.framework")
    project.add_other_ldflags('-ObjC')
    project.add_other_ldflags('-l"sqlite3.0"')
    project.add_other_ldflags('-l"z"')
    project.add_other_ldflags('-l"resolv"')
    project.add_other_ldflags('-l"c++"')
    project.enable_bitcode("NO")
    infoPlist['NSCameraUsageDescription'] = ""
    infoPlist['NSPhotoLibraryAddUsageDescription'] = ""
    infoPlist['NSPhotoLibraryUsageDescription'] = ""
    infoPlist["NSAppTransportSecurity"] = { "NSAllowsArbitraryLoads": True }
    self.addBundleURLType(["ingcleSdk"+self.getBundleId()])
    self.addAppQueriesSchemes(["alipay", "alipays", "wechat", "weixin"])
    project.enable_bitcode("NO")
    project.c_language_standard("gnu99")
    project.enable_objc_weak("YES")
