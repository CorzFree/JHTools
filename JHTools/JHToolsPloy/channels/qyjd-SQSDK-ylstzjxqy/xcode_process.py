# -*- coding: utf-8 -*-

mods = {
    "group": "JHToolsSDK_SQSDK",
    "files": [
        "libJHToolsSDK_SQSDK.a"
    ],
    "folders":[
        "SDK"
    ],
    "frameworks": [

    ],
    "libs": [
    ]
}

#URLScheme设置
def post_process(self, project, infoPlist, sdkparams):
    project.add_other_ldflags('-ObjC')
    project.enable_bitcode("NO")
    infoPlist["NSAppTransportSecurity"] = { "NSAllowsArbitraryLoads": True }
    self.embed_binary("SDK/SQSDK.framework")
    self.embed_binary("SDK/nutsdk.framework")
    self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName="alipay", CFBundleURLSchemes=[self.getBundleId()])
    self.addAppQueriesSchemes(["alipays","weixin", "wechat"])
    infoPlist['NSCameraUsageDescription'] = ""
    infoPlist['NSPhotoLibraryAddUsageDescription'] = ""
    infoPlist['NSPhotoLibraryUsageDescription'] = ""
