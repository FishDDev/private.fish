#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

##by:      Fish
##mailto:  fishdev@qq.com


GITURL=https://raw.githubusercontent.com/FishDDev/tools/Privated
RELOADLOG=/var/log/reload.log


rootness(){
    if [[ $EUID -ne 0 ]]; then
       echo "Error: This script must be run as root!" 1>&2
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
        echo "Shadowsocks installed"
    else
        rm -rf shadowsocks-install.sh
        wget --no-check-certificate ${GITURL}/setuptools/shadowsocks-install.sh >>$RELOADLOG 2>&1 &&
        ( chmod +x shadowsocks-install.sh ;
        echo "done: Shadowsocks installation Script" ) ||
        echo "failed: Shadowsocks installation Script"
    fi
}

chkinstall_serverspeeder()
{
    if [ -f /serverspeeder/bin/serverSpeeder.sh ] ; then
        echo "serverSpeeder installed"
    else
        rm -rf *erverspeede*
        wget --no-check-certificate ${GITURL}/setuptools/serverspeeder.sh >>$RELOADLOG 2>&1  &&
        ( chmod +x serverspeeder.sh ;
        echo "done: serverSpeeder installation Script" ) ||
        echo "failed: serverSpeeder installation Script"
    fi
}

optimized_shadowsocks()
{
    if ! grep -q "* soft nofile" /etc/security/limits.conf; then
        echo -e "* soft nofile 51200\n* hard nofile 51200"
        ulimit -n 51200
    fi
}


restart_service()
{
    if [ -f /usr/local/bin/ss-server ] ; then
        tools_shadowsocks
        echo "Restart Service: Shadowsocks"
        /etc/init.d/shadowsocks-libev restart
    fi
    
    if [ -f /serverspeeder/bin/serverSpeeder.sh ] ; then
        echo "Restart Service: serverSpeeder"
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