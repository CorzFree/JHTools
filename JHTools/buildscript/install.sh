#!/bin/bash


SCRIPTDIR=`dirname $0`

pushd $SCRIPTDIR >/dev/null
cd ..
JHToolsSDK_ROOT=$PWD
popd >/dev/null

prefix=/usr/local
action=install

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -p|--prefix)
    prefix="$2"
    shift # past argument
    ;;
    -r|-u|--uninstall|--remove)
	action=remove
	shift
	;;
    *)
    action=error
    ;;
esac
shift # past argument or value
done


if [ "$action" == "install" ]; then
	ln -sf $JHToolsSDK_ROOT/bin/JHToolssdk $prefix/bin/
	ln -sf $JHToolsSDK_ROOT/bin/JHToolsbuild $prefix/bin/
elif [ "$action" == "remove" ]; then
	rm $prefix/bin/JHToolssdk
	rm $prefix/bin/JHToolsbuild
else
	echo "Usage: $0 [-r] [-p PREFIX]"
	echo "optional arguments:"
	echo "    -r,-u,--uninstall,--remove    uninstall"
	echo "    -p,--prefix                   install path prefix"
fi
