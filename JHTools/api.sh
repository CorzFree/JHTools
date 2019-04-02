#!/bin/bash
gameid=$1           #游戏id
root_path=`pwd`   #打包工具根目录

#下载配置文件并覆盖
function cp_conf(){
cd /tmp
curl -O $1 &>/dev/null
xml=${1##*/}        #压缩包名称
folder=${xml%.*}   #配置文件目录名称
#echo "/bin/cp /tmp/$xml $root_path/$2"
echo -e " 压缩包为 $xml \n 配置文件为 $folder"
/bin/cp /tmp/$xml $root_path/$2
if [ $? -ne 0 ];then
    echo "Error!!!拷贝文件出错,退出脚本！"
fi
cd $root_path/$2
#echo "1=$xml 2=$folder"
rm -rf $folder    #删除旧的目录
unzip $xml -x __MACOSX/*  &>/dev/null #解压包
rm -rf $xml /tmp/$xml #删除下载的压缩包
}

#输入游戏id
while((1))
do
if [ "$gameid" -gt 0 ] 2>/dev/null ;then
    echo -e " 开始为游戏ID为 :$gameid 的游戏打包...\n"
    break
else
    read -p "请输入需要打包的游戏id:" gameid
fi
done

#接口访问
api_url="http://unionsdk.51wansy.com/Api/Sdk/getConfigByAppID?appID=$gameid\&type=1"
echo -e "api接口地址为 $api_url \n"
#接口url
code=`curl -I -m 10 -o /dev/null -s -w %{http_code} $api_url`
if [ "$code" != "200" ];then
    echo -e "Error!!! Api接口返回状态非200,退出脚本！"
    exit
fi

#获取文件下载地址以及相对路径
content=`curl -s $api_url`    #接口返回内容
#echo $content|while read LINE
for i in `echo $content|tr ';' ' '`
do
xml_url=${i%%,*}
re_path=${i##*,}
#echo -e "i=$i \n 下载地址为 $xml_url \n xml文件相对路径为 $re_path"
if [ "$xml_url" = "" ];then
    echo -e "Error!!! 配置文件下载地址为空,退出脚本！"
    exit
else
    code=`curl -I -m 10 -o /dev/null -s -w %{http_code} $xml_url`
    if [ "$code" != "200" ];then
        echo -e "Error!!! 下载文件返回状态非200,退出脚本！"
        exit
    fi
fi
if [ "$re_path" = "" ];then
    echo -e "Error!!! 配置文件相对路径为空,退出脚本！"
    exit
fi
echo -e " 下载地址为 $xml_url \n 配置文件相对路径为 $re_path"
cp_conf $xml_url $re_path
echo -e "---------------\n"
done

echo -e "配置文件替换完成! \n \n开始进行打包操作...\n"

read -p "请输入工程.xcodeproj相对路径:" proj
read -p "请输入当前游戏工作目录:" work
cd $root_path
echo “./buildscript/build.py $proj $work”
echo “开始打包...”
./buildscript/build.py $proj $work
