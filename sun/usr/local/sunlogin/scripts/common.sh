
function echoAndExit
{
	echo -n 'Error:'
	echo $1
	echo 'Installation failed'
	exit 1
}

#check root
function check_root
{
	if [ $(whoami) != 'root' ]; then
		if [ "$1" == "" ]; then
			echo 'Sunlogin client needs root to complete installation'
		else
			echo "$1"
		fi
		exit 1
	fi
}

function killallsunloginclient
{
	if [[ $(ps -A | grep sunloginclient) != "" ]]; then
		killall sunloginclient
	fi
}

path_main='/usr/local/sunlogin'
path_bin="$path_main/bin"
path_etc="$path_main/etc"
path_doc="$path_main/doc"
path_log="$path_main/var/log"

#get operation system info
function get_os_name()
{
    if grep -Eqii "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        DISTRO='centos'
        PM='yum'
    elif grep -Eqi "Red Hat Enterprise Linux Server" /etc/issue || grep -Eq "Red Hat Enterprise Linux Server" /etc/*-release; then
        DISTRO='redhat'
        PM='yum'
    elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
        DISTRO='Aliyun'
        PM='yum'
    elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
        DISTRO='Fedora'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        DISTRO='Debian'
        PM='apt'
    elif grep -Eqi "Deepin" /etc/issue || grep -Eq "Deepin" /etc/*-release; then
        DISTRO='Deepin'
        PM='apt'
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        DISTRO='ubuntu'
        PM='apt'
    elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
        DISTRO='Raspbian'
        PM='apt'
    elif grep -Eqi "Kylin" /etc/issue || grep -Eq "Kylin" /etc/*-release; then
        DISTRO='kylin'
        PM='apt'
    elif grep -Eqi "uos" /etc/issue || grep -Eq "uos" /etc/*-release; then
        DISTRO='Deepin'
        PM='apt'
    elif grep -Eqi "NFS Server" /etc/issue || grep -Eq "NFS Server" /etc/*-release; then
        DISTRO='nfs_server'
	    PM='yum'
    elif grep -Eqi "方德桌面" /etc/issue || grep -Eq "方德桌面" /etc/*-release; then
        DISTRO='nfs_desktop'
	    PM='apt'
    elif grep -Eqi "Loongnix" /etc/issue || grep -Eq "Loongnix" /etc/*-release; then
        DISTRO='Loongnix'
	    PM='apt'
    else
        DISTRO='unknow'
    fi
    echo $DISTRO;
}

os_name=$(get_os_name)
os_version='0.0'

if [ $os_name == 'ubuntu' ]; then
	os_version=`cat /etc/issue | cut -d' ' -f2`
elif [ $os_name == 'kylin' ]; then
	os_version=`cat /etc/issue | cut -d' ' -f2`
elif [ $os_name == 'Deepin' ]; then
	os_version=`cat /etc/lsb-release |grep DISTRIB_RELEASE | cut -d'=' -f2 |sed 's/"//g'`
elif  [ "$os_name" == "centos" ] || [ "$(echo $os_name |grep redhat)" != "" ] ; then
	os_version=`rpm -q centos-release|cut -d- -f3`
elif [ $os_name == 'nfs_server' ] || [ $os_name == 'nfs_desktop' ]; then
	os_version=`cat /etc/os-release |grep VERSION_ID | cut -d'=' -f2 |sed 's/"//g'`
elif [ $os_name == 'Loongnix' ]; then
	os_version=`cat /etc/issue | cut -d' ' -f3`
fi

os_name=$(echo $os_name | tr [A-Z] [a-z])
os_bits=$(getconf LONG_BIT)


srv_type="initd"
which systemctl >/dev/null 2>&1
if [ $? -eq 0 ]; then
    srv_type="systemd"
else
    srv_type="initd"
fi


#echo $os_name
#echo $os_version
