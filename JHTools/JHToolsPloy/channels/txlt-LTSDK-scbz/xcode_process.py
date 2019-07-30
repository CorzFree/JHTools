# -*- coding: utf-8 -*-

mods = {
    "group": "JHToolsSDK_LTSDK",
    "files": [
        "libJHToolsSDK_LTSDK.a"
    ],
    "folders":[
        "SDK"
    ],
    "frameworks": [
        "CoreTelephony.framework",
        "SystemConfiguration.framework",
        "Security.framework",
        "CoreGraphics.framework",
        "QuartzCore.framework",
        "CoreText.framework",
        "ImageIO.framework",
        "UIKit.framework",
        "Foundation.framework",
        "CFNetwork.framework",
        "CoreMotion.framework",
        "Photos.framework"
    ],
    "libs": [
        "libc++.1.tbd",
        "libc++.tbd",
        "libz.tbd",
        "libz.1.2.5.tbd",
        "libsqlite3.0.tbd",
        "libiconv.tbd"
    ]
}

#URLScheme设置
def post_process(self, project, infoPlist, sdkparams):
    project.add_other_ldflags('-ObjC')
    project.enable_bitcode("NO")
    self.addBundleURLType(["wxb812fa31f3e3e96e"])
    self.addBundleURLType(["tencent101480145"])
    self.addBundleURLType(["wb2899996505"])
    self.addBundleURLType(["wap.hjygame.com"])
    self.addBundleURLType([self.getBundleId()])
    self.addAppQueriesSchemes(["wechat", "weixin", "sinaweibohd","sinaweibo", "sinaweibosso", "weibosdk","weibosdk2.5", "mqqapi", "mqq","mqqOpensdkSSoLogin", "mqqconnect", "mqqopensdkdataline","mqqopensdkgrouptribeshare", "mqqopensdkfriend", "mqqopensdkapi","mqqopensdkapiV2", "mqqopensdkapiV3", "mqqopensdkapiV4","mqzoneopensdk", "wtloginmqq", "wtloginmqq2","mqqwpa", "mqzone", "mqzonev2","mqzoneshare", "wtloginqzone", "mqzonewx","mqzoneopensdkapiV2", "mqzoneopensdkapi19", "mqzoneopensdkapi","mqqbrowser", "mttbrowser", "tim","timapi", "timopensdkfriend", "timwpa","timgamebindinggroup", "timapiwallet", "timOpensdkSSoLogin","wtlogintim", "timopensdkgrouptribeshare", "timopensdkapiV4","timgamebindinggroup", "timopensdkdataline", "wtlogintimV1","timapiV1", "alipay"])
