#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

##by:      Fish
##mailto:  fishdev@qq.com

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

GITURL=https://raw.githubusercontent.com/FishDDev/tools/Privated
RELOADLOG=/var/log/reload.log


rootness(){
    if [[ $EUID -ne 0 ]]; then
       echo -e "${red}Error: This script must be run as root!${plain}" 1>&2
       exit 1
    fi
}

disable_selinux(){
    if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
        setenforce 0
    fi
}

chkinstall_shadowsocks()
{
    if [ -f /usr/local/bin/ss-server ] ; then
        echo -e "Shadowsocks installed"
    else
        rm -rf shadowsocks-install.sh
        wget --no-check-certificate ${GITURL}/setuptools/shadowsocks-install.sh >>$RELOADLOG 2>&1 &&
        ( chmod +x shadowsocks-install.sh ;
        echo -e "${green}done: Shadowsocks installation Script${plain}" ) ||
        echo -e "${red}failed: Shadowsocks installation Script${plain}"
    fi
}

chkinstall_serverspeeder()
{
    if [ -f /serverspeeder/bin/serverSpeeder.sh ] ; then
        echo -e "${green}serverSpeeder installed${plain}"
    else
        rm -rf *erverspeede*
        wget --no-check-certificate ${GITURL}/setuptools/serverspeeder.sh >>$RELOADLOG 2>&1  &&
        ( chmod +x serverspeeder.sh ;
        echo -e "${green}done: serverSpeeder installation Script${plain}" ) ||
        echo -e "${red}failed: serverSpeeder installation Script${plain}"
    fi
}

optimized_shadowsocks()
{
    if ! grep -q "* soft nofile" /etc/security/limits.conf; then
        echo -e "* soft nofile 51200\n* hard nofile 51200" >> /etc/security/limits.conf
    fi
    ulimit -n 51200
}


restart_service()
{
    if [ -f /etc/init.d/shadowsocks* ] ; then
        echo -e "${red}Restart Service: Shadowsocks${plain}"
        /etc/init.d/shadowsocks-libev restart
    fi
    
    if [ -f /serverspeeder/bin/serverSpeeder.sh ] ; then
        echo -e "${red}Restart Service: serverSpeeder${plain}"
        /serverspeeder/bin/serverSpeeder.sh restart
    fi
}


rm -rf $RELOADLOG
rootness
disable_selinux
chkinstall_shadowsocks
chkinstall_serverspeeder
optimized_shadowsocks
restart_service