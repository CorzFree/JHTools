# -*- coding: utf-8 -*-

mods = {
    "group": "JHToolsSDK_AoFengSDK",
    "files": [
        #需要导入的静态库，bundle文件，以及自己生成的.a库
        "libJHToolsSDK_AoFengSDK.a"
    ],
    "folders": [
        "SDK"
    ],
    "frameworks": [
        #所依赖的原始库
                   "CoreMotion.framework",
                   "CoreTelephony.framework",
                   "SystemConfiguration.framework",
                   "CFNetwork.framework",
                   "AdSupport.framework"
    ],
    "libs": [
        #dylib，stdb库
             "libz.tbd",
             "libc++.tbd"
    ]
}

def post_process(self, project, infoPlist, sdkparams):
    project.add_other_ldflags('-ObjC')
    infoPlist["NSAppTransportSecurity"] = { "NSAllowsArbitraryLoads": True }
    self.addBundleURLType([self.getBundleId()])
