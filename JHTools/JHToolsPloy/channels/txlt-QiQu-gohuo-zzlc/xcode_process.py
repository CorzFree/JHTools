# -*- coding: utf-8 -*-

mods = {
    "group": "JHToolsSDK_GoHuoPaySDK",
    "files": [
              #需要导入的静态库，bundle文件，以及自己生成的.a库
              "libJHToolsSDK_GoHuoPaySDK.a"
              ],
              "folders":[
                         "SDK"
                         ],
              "frameworks": [
                             #所依赖的原始库
                             "Security.framework",
                             "CoreText.framework",
                             "QuartzCore.framework",
                             "SystemConfiguration.framework",
                             "UIKit.framework",
                             "CFNetwork.framework",
                             "Foundation.framework",
                             "CFNetwork.framework",
                             "CoreTelephony.framework",
                             "CoreMotion.framework",
                             "CoreGraphics.framework"
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
    self.addBundleURLType(["GohuoSDK"])
    self.addBundleURLType(["wxec2b7488e0dd2815"])
    #other link flag设置
    project.add_other_ldflags('-ObjC')
    project.enable_bitcode("NO")
    infoPlist["NSAppTransportSecurity"] = { "NSAllowsArbitraryLoads": True }
