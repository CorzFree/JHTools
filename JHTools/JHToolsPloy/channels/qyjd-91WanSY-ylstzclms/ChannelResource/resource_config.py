#!/usr/bin/env python3
# -*- coding: utf-8 -*-


import os
import sys
import json
import shutil
from xml.etree import ElementTree as ET


def configPlatform(srcRoot, workspace, channel):
	platformPath = os.path.join(workspace, "channels", channel["name"], "ChannelResource", "platform.txt")
	#找到原始文件
	sourcePlatform = find_file("platform.txt", srcRoot)
	

	with open(sourcePlatform, "r") as f:
		for line in f:
			if 'verInfo' in line:
				verInfoLine = line

	file_data = ""
	with open(platformPath, "r") as f:
		for line in f:
			if 'verInfo' in line:
				line = line.replace(line, verInfoLine)
			file_data += line
	with open(platformPath,"w") as f:
		f.write(file_data)
	
def find_file(name, path):
    for root,dirs,files in os.walk(path):
        if name in files:
            return os.path.join(root, name)