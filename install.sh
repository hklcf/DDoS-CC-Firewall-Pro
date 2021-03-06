#!/bin/bash
# DDOS & CC Firewall Pro installation wrapper
# modify by HKLCF

#
# Currently Supported Operating Systems:
#
#   RHEL 5, RHEL 6
#   CentOS 5, CentOS 6, CentOS 7
#   Debian 7
#

SCRIPT_SERVER=https://raw.githubusercontent.com/hklcf/DDoS-CC-Firewall-Pro/master

# Check OS type
if [ -e '/etc/redhat-release' ]; then
    type="rhel"
    OS_VER=`cat /etc/redhat-release |cut -d\  -f3`;
    if [ "$OS_VER" = "release" ]; then
        OS_VER=`cat /etc/redhat-release | cut -d\  -f4`
    fi
    OS_VER=`echo $OS_VER | cut -d. -f1,2`
fi
if [ -z "$type" ]; then
    os=$(head -n1 /etc/issue | cut -f 1 -d ' ')
    if [ "$os" == 'Debian' ]; then
        type="debian"
    fi
fi
# Check type
if [ -z "$type" ]; then
    echo 'Error: only RHEL,CentOS,Debian 7 is supported'
    exit 1
fi
# Install iptables-services and net-tools for CentOS 7
if [ "$type" = "rhel" ]; then
    case "$OS_VER" in
        7|7.0|7.1|7.2|7.3) yum -y install iptables-services net-tools
            ;;
    esac
fi
# Check wget
if [ -e '/usr/bin/wget' ]; then
    wget --no-check-certificate $SCRIPT_SERVER/install-rhel.sh
    chmod 0700 install-rhel.sh
    if [ "$?" -eq '0' ]; then
        bash install-rhel.sh $*
        exit
    else
        echo "Error: install-rhel.sh download failed."
        exit 1
    fi
fi
# Let's try to install wget automaticaly
if [ "$type" = 'rhel' ]; then
    yum -y install wget
    if [ $? -ne 0 ]; then
        echo "Error: can't install wget"
        exit 1
    fi
fi
# OK, last try
if [ -e '/usr/bin/wget' ]; then
    wget --no-check-certificate $SCRIPT_SERVER/install-rhel.sh
    if [ "$?" -eq '0' ]; then
        bash install-rhel.sh $*
        exit
    else
        echo "Error: install-rhel.sh download failed."
        exit 1
    fi
else
    echo "Error: /usr/bin/wget not found"
    exit 1
fi
exit
