# -*- coding: utf-8 -*-

mods = {
    "group": "JHToolsSDK_QiQuXYSDK",
    "files": [
              #需要导入的静态库，bundle文件，以及自己生成的.a库
              "libJHToolsSDK_QiQuXYSDK.a"
              ],
              "folders":[
                         "SDK"
                         ],
              "frameworks": [
                             #所依赖的原始库
                             "SystemConfiguration.framework",
                             "CFNetwork.framework",
                             "CoreTelephony.framework",
                             "Security.framework",
                             "CoreMotion.framework",
                             "UIKit.framework",
                             "CoreGraphics.framework",
                             "Foundation.framework",
                             "JavaScriptCore.framework",
                             "WebKit.framework",
                             "StoreKit.framework"
                             ],
              "libs": [
                       #dylib，stdb库
                       "libsqlite3.0.tbd",
                       "libc++.1.tbd",
                       "libz.1.2.5.tbd"
                       ]
}

def post_process(self, project, infoPlist, sdkparams):
    #URLScheme设置
    self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName=self.getBundleId(), CFBundleURLSchemes=[self.getBundleId()])
    #other link flag设置
    project.add_other_ldflags('-ObjC')
    project.enable_bitcode("NO")
    infoPlist['NSCameraUsageDescription'] = ""
    infoPlist['NSPhotoLibraryAddUsageDescription'] = ""
    infoPlist['NSPhotoLibraryUsageDescription'] = ""
    infoPlist["NSAppTransportSecurity"] = { "NSAllowsArbitraryLoads": True }
