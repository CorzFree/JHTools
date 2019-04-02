# -*- coding: utf-8 -*-

'''
自定义XCode工程处理脚本，这个脚本将会应用于所有渠道
'''

# apply_mods
mods = {
}

def post_process(self, project, infoPlist, channelConfig):
    project.add_other_ldflags('-ObjC')
    
    if not 'ChannelName' in channelConfig['JHToolsSDK']:
    	channelConfig['JHToolsSDK']['ChannelName'] = channelConfig['name']
    	
    self.updateInfoPlist({"JHToolsSDK":channelConfig["JHToolsSDK"]})

    if 'CFBundleIdentifier' in channelConfig:
    	infoPlist["CFBundleIdentifier"] = channelConfig["CFBundleIdentifier"]
        if not self.target.get_buildconfig_value('PRODUCT_BUNDLE_IDENTIFIER') in (None,""):
            self.target.set_buildconfig_value('PRODUCT_BUNDLE_IDENTIFIER', channelConfig["CFBundleIdentifier"])

    if 'CFBundleVersion' in channelConfig:
    	infoPlist["CFBundleVersion"] = channelConfig["CFBundleVersion"]
    	infoPlist["CFBundleShortVersionString"] = channelConfig["CFBundleVersion"]

    if 'CFBundleShortVersionString' in channelConfig:
    	infoPlist["CFBundleShortVersionString"] = channelConfig["CFBundleShortVersionString"]

    if 'CFBundleDisplayName' in channelConfig:
    	infoPlist["CFBundleDisplayName"] = channelConfig["CFBundleDisplayName"]

    if 'archs' in channelConfig:
    	project.set_archs(channelConfig['archs'])

    if 'DevelopmentTeam' in channelConfig:
        self.target.set_development_team(channelConfig['DevelopmentTeam'])

    if 'provision' in channelConfig:
        self.target.set_provision(channelConfig['provision'])

    if 'product_name' in channelConfig:
        self.target.set_product_name(channelConfig['product_name'])
    else:
        channelConfig['product_name'] = self.target.get_product_name()
