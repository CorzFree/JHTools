# -*- coding: utf-8 -*-

mods = {
    "group": "JHToolsSDK_51WanSY",
    "files": [
        "libJHToolsSDK_51WanSY.a"
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
        "libc++.1.tbd",
        "libz.1.2.5.tbd",
        "libsqlite3.0.tbd"
    ]
}

#URLScheme设置
def post_process(self, project, infoPlist, sdkparams):
    self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName=self.getBundleId(), CFBundleURLSchemes=[self.getBundleId()])
    project.add_other_ldflags('-ObjC')
    project.enable_bitcode("NO")
    infoPlist['NSPhotoLibraryAddUsageDescription'] = ""
    infoPlist['NSPhotoLibraryUsageDescription'] = ""
