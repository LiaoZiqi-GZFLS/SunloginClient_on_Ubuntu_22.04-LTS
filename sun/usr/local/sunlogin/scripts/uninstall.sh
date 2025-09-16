#!/bin/bash


echo "Sunlogin client for linux uninstaller"
echo "-------------------------------"


#change directory to script path
curpath=$(cd "$(dirname "$0")"; pwd)
cd $curpath > /dev/null

source /usr/local/sunlogin/scripts/common.sh

#check root
check_root "Installed Sunlogin client needs root to uninstall"

bash /usr/local/sunlogin/scripts/stop.sh
os_version_int=${os_version%.*}
for i in $(seq 1 10)
do
	os_version_int=${os_version_int%.*}
done

echo "Removing files"
if [ $os_name == 'ubuntu' ]; then
	if [ $os_version_int -lt 15 ]; then
		rm /etc/init/runsunloginclient.conf > /dev/null 2>&1
	else
		systemctl disable runsunloginclient.service
		rm /etc/systemd/system/runsunloginclient.service > /dev/null 2>&1
	fi

elif [ $os_name == 'Kylin' ]; then
	systemctl disable runsunloginclient.service
	rm /etc/systemd/system/runsunloginclient.service > /dev/null 2>&1
elif [ $os_name == 'deepin' ]; then
	if [ $os_version_int -gt 2000 ]; then
                let os_version_int=os_version_int-2000
        fi
        if [ $os_version_int -lt 15 ]; then
                rm /etc/init/runsunloginclient.conf > /dev/null 2>&1
        else
                systemctl disable runsunloginclient.service
                rm /etc/systemd/system/runsunloginclient.service > /dev/null 2>&1
        fi

elif  [ "$os_name" == "centos" ] || [ $(echo $os_name |grep redhat) != "" ] ; then
	if [ $os_version_int -lt 7 ]; then
		/sbin/chkconfig runsunloginclient off
		/sbin/chkconfig --del runsunloginclient
		rm /etc/init.d/runsunloginclient > /dev/null 2>&1

		#delete soft link
		for i in $(seq 0 6)
		do
			rm /etc/rc$i.d/S99slrmct > /dev/null 2>&1
			rm /etc/rc$i.d/S99slscreenagentsvr  > /dev/null 2>&1
		done
	else
		systemctl disable runsunloginclient.service
		rm /etc/systemd/system/runsunloginclient.service > /dev/null 2>&1
	fi

fi

echo "Removing man directory"
rm "$path_main" -rf
rm /usr/share/applications/sunlogin.desktop

if [ "$1" == "-s" ]; then
    echo "skip" >> /dev/null
else
    rm /etc/orayconfig.conf
fi
echo "Sunlogin client removed :-("
cd - > /dev/null
