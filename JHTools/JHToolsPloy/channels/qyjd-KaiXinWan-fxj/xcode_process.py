# -*- coding: utf-8 -*-

mods = {
    "group": "JHToolsSDK_KaiXinWan",
    "files": [
        "libJHToolsSDK_KaiXinWanSDK.a"
    ],
    "folders":[
        "SDK"
    ],
    "frameworks": [
        "storekit.framework"
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
    infoPlist['NSPhotoLibraryUsageDescription'] = ""
    infoPlist['NSPhotoLibraryAddUsageDescription'] = ""
    project.add_other_ldflags('-ObjC')
    self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName="okgame", CFBundleURLSchemes=[self.getBundleId()])
