# -*- coding: utf-8 -*-

mods = {
    "group": "JHToolsSDK_GameEverestSDK",
    "files": [
        "libJHToolsSDK_GameEverestSDK.a"
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
    self.embed_binary("SDK/GameEverestSDK.framework")
