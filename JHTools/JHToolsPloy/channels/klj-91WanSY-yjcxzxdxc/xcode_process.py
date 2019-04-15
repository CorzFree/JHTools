# -*- coding: utf-8 -*-

mods = {
    "group": "JHToolsSDK_91WanSY",
    "files": [
        "libJHToolsSDK_91WanSY.a"
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
    self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName=self.getBundleId(), CFBundleURLSchemes=[self.getBundleId()])
    self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName="wxMini",CFBundleURLSchemes=["wxc5865d85ba0f03b3"])
    project.add_other_ldflags('-ObjC')
    project.enable_bitcode("NO")
    infoPlist['NSPhotoLibraryAddUsageDescription'] = ""
    infoPlist['NSPhotoLibraryUsageDescription'] = ""
