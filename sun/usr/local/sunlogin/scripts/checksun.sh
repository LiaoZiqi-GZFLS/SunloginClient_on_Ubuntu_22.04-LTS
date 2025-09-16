#!/bin/bash
if [ -f "/usr/local/sunlogin/bin/sunloginclient_linux" ];then
        cp /etc/orayconfig.conf /tmp/	
	/usr/local/sunlogin/uninstall.sh > /dev/null 2>$1
	exit 0;
fi
if [ -f "/usr/local/sunlogin/uninstall.sh" ];then
	/usr/local/sunlogin/uninstall.sh -s 
fi
