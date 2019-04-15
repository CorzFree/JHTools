# -*- coding: utf-8 -*-

mods = {
    "group": "JHToolsSDK_YiJie",
    "files": [
         "libJHToolsSDK_YiJie.a"
    ],
    "folders": [
         "SDK"
    ],
    "frameworks": [
     ],
    "libs": [
         "libz.dylib",
         "libc++.1.dylib",
         "libz.1.2.5.dylib",
         "libsqlite3.0.dylib"
    ]
}

#URLScheme设置
def post_process(self, project, infoPlist, sdkparams):
    self.embed_binary("SDK/OnlineAHelper.framework")
    infoPlist['com.snowfish.customer'] = "SNOWFISH"
    infoPlist['com.snowfish.channel'] = "SNOWFISH"
    infoPlist['com.snowfish.sdk.version'] = "2"
    infoPlist['com.snowfish.appid'] = "{8C80848B-16EDB7D4}"
    infoPlist['com.snowfish.channelid'] = "{6EDC1D7C-654416C7}"
    pass


