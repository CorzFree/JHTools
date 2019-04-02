# -*- coding: utf-8 -*-

"""
    JHToolssdk config

"""

import os
import json
import copy
import utils
import collections  
import traceback
import sys

def cmpChannel(a, b):
    # ca = a['JHToolsSDK']["Channel"]
    # cb = b['JHToolsSDK']["Channel"]
    ca = a['name']
    cb = b['name']
    
    if ca > cb:
        return 1
    elif ca < cb:
        return -1
    else:
        return 0

def _merge_dict(d1, d2):
    """
    Modifies d1 in-place to contain values from d2.  If any value
    in d1 is a dictionary (or dict-like), *and* the corresponding
    value in d2 is also a dictionary, then merge them in-place.
    """
    for k,v2 in d2.items():
        v1 = d1.get(k) # returns None if v1 has no value for this key
        if (isinstance(v1, collections.Mapping) and isinstance(v2, collections.Mapping) ):
            _merge_dict(v1, v2)
        else:
            d1[k] = v2

class Config(dict):
    def __init__(self, path, baseConfig, channelConfig, suffixConfig=None):
        dict.__init__(self, copy.deepcopy(baseConfig))
        _merge_dict(self, channelConfig)
        if suffixConfig != None:
            _merge_dict(self, suffixConfig)

        self.path = path
        self.baseConfig = baseConfig
        self.channelConfig = channelConfig

def load_json(jsonFile):
    return json.load(open(jsonFile))

def load_json_sets(path, channel, suffix):
    """Load json from common/config.json, channels/$channel/config.json, channels/$channel/config_$suffix.json
    """
    baseJsonFile = os.path.join(path, "common/config.json")

    try:
        baseConfig = load_json(baseJsonFile)
    except Exception as e:
        traceback.print_exc()
        print("游戏配置(common/config.json)错误: \n%s"%e)
        sys.exit(-1)

    channelJsonFile = os.path.join(path, "channels/%s/config.json"%channel)

    try:
        channelConfig = load_json(channelJsonFile)
        channelConfig['name'] = channel
    except Exception as e:
        traceback.print_exc()
        print("渠道配置(channels/%s/config.json)错误: \n%s"%(channel, e))
        sys.exit(-1)

    suffixConfig = None

    if suffix != None:
        suffixJsonFile = os.path.join(path, "channels/%s/config_%s.json"%(channel, suffix))
        if os.path.isfile(suffixJsonFile):
            try:
                suffixConfig = load_json(suffixJsonFile)
                suffixConfig["suffix"] = suffix
            except Exception as e:
                traceback.print_exc()
                print("渠道配置(channels/%s/config_%s.json)错误: \n%s"%(channel, suffix, e))
                sys.exit(-1)

    return (baseConfig, channelConfig, suffixConfig)

def load_all_config(configPath, suffix=None):
    allConfigs = []
    channelsDir = os.path.join(configPath, "channels")

    for f in os.listdir(channelsDir):
        if f[0] == '.':
            continue

        fullpath = os.path.join(channelsDir, f)
        if not os.path.isdir(fullpath):
            continue

        channelJsonFile = os.path.join(fullpath, "config.json")

        if not os.path.isfile(channelJsonFile):
            continue

        allConfigs.append(load_config(configPath, f, suffix))

    allConfigs.sort(cmpChannel)

    return allConfigs

def load_config(path, channel, suffix=None):
    jsons = load_json_sets(path, channel, suffix)
    return Config(path, *jsons)



