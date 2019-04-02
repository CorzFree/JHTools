#!/usr/bin/env python
#-*- coding:utf-8 -*-
import os,urllib2,urllib,requests
import sys

def get_status(url):
#获取http返回状态码函数
    r = requests.get(url, allow_redirects = False)
    return r.status_code

gameid = 0           #游戏id
root_path = os.getcwd()  #打包工具根目录

#输入游戏id
str = raw_input("请输入需要打包的游戏id:")
while True:
    if str.isdigit():
        gameid=str
        print "开始为游戏ID为: ",gameid," 的游戏打包...\n"
        break
    else:
        str = raw_input("Error！请重新输入游戏id:")

#接口访问(type：android为0,ios为1)
api_url="http://sdkserver.wan669.com/Api/Sdk/getConfigByAppID?appID=%s&type=1" %gameid   #接口url
print "接口地址:",api_url,"\n"
status=get_status(api_url)
if status!=200:
    print "Error!!! Api接口返回状态非200,退出脚本！"
    sys.exit(1)

#获取接口返回内容
response = urllib2.urlopen(api_url)
if response.read()=="":
	print "Error!!! Api接口返回为空,退出脚本！"
	sys.exit(1)

#多渠道下载及配置文件拷贝
res = urllib2.urlopen(api_url).read()

for line in res.split(';'):
#	print line
	if line.strip()=='':
		break
	conf_url=line.split(',')[0]	#配置文件地址
	re_path=line.split(',')[1].strip('\n')	#配置文件存储相对路径
	file=conf_url.split('/')[-1]	#配置文件
	folder=file.replace('.zip','')
#	print "配置文件url:",conf_url,"\n相对路径",re_path,"\n"
#	print "配置文件:",file,"\n配置文件目录",folder,"\n"
	if conf_url.strip()=="":
		print "Error!!! 配置文件下载地址为空,退出脚本！"
		sys.exit(2)
	else:
		status=get_status(conf_url)
		if status!=200:
			print "Error!!! 下载配置文件返回状态非200,退出脚本！"
			sys.exit(3)

	if re_path.strip()=="":
		print "Error!!! 配置文件相对路径为空,退出脚本！"
		sys.exit(4)

	print " 下载地址为 "+conf_url+" \n conf文件相对路径为 "+re_path
	print " 压缩文件为 "+file+" \n conf文件目录为 "+folder
	#下载文件并拷贝
	f=urllib2.urlopen(conf_url)
	data=f.read()
	with open(file,"wb") as code:
		code.write(data)
	if not os.path.isfile(file):
		print 'Error!!!配置文件下载失败,退出脚本！'
		os.system ("rm -rf %s" % (file))
		sys.exit(5)
	path=repr(re_path)
	if not os.path.isdir(re_path):
		print 'Error!!!配置文件相对路径错误,退出脚本！'
		os.system ("rm -rf %s" % (file))
		sys.exit(6)
	path = re_path+'/'+folder
	os.system ("rm -rf %s" % (path))
	os.system ("unzip %s -d %s -x __MACOSX/*  &>/dev/null" % (file, re_path))
	os.system ("rm -rf %s" % (file))
	print "----------------------\n"

print "配置文件修改完成!\n"
sys.exit(0)
