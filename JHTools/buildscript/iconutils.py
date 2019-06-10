# -*- coding: utf-8 -*-

'''
Icon角标处理
'''
import os
import glob
from utils import error

def maskIconImage(imgIcon, imgMark, position):
    if imgIcon.mode != 'RGBA':
        imgIcon = imgIcon.convert('RGBA')
    markLayer = Image.new('RGBA', imgIcon.size, (0,0,0,0))
    markLayer.paste(imgMark.resize(imgIcon.size, Image.ANTIALIAS), position)
    return Image.composite(markLayer, imgIcon, markLayer)

def get_plugin_dir(pluginRoot, plugin):
    return os.path.join(pluginRoot, 'JHToolsSDK_' + plugin['name'])
    
def addIconCorner(folder, channelConfig, pluginRoot):
    for plugin in channelConfig['plugins']:
        if not "IconCorner" in plugin:
            continue

        icon_mark_file = os.path.join(get_plugin_dir(pluginRoot, plugin), "IconCorner", plugin.pop('IconCorner')+".png")

        if not os.path.isfile(icon_mark_file):
            error("plugin did not config iconmark file: "+icon_mark_file)
            continue

        global Image
        from PIL import Image, ImageEnhance

        iconMark = Image.open(icon_mark_file)
        for iconFile in glob.glob(os.path.join(folder, "*.png")):
            iconImage = Image.open(iconFile)
            iconImage = maskIconImage(iconImage, iconMark, (0,0))
            iconImage.save(iconFile, 'PNG')
