#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

##by:      Fish
##mailto:  fishdev@qq.com

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
relog=/var/log/relog.log
giturl=https://raw.githubusercontent.com/FishDDev/tools/Privated

ss_init[0]=/etc/init.d/shadowsocks
ss_init[1]=/etc/init.d/shadowsocks-python
ss_init[2]=/etc/init.d/shadowsocks-r
ss_init[3]=/etc/init.d/shadowsocks-go
ss_init[4]=/etc/init.d/shadowsocks-libev
serverspeeder_init=/serverspeeder/bin/serverSpeeder.sh

i=0
for init in ${ss_init[@]}; do
    if [ -f ${init} ]; then
    export ss_init=${init}
    fi
done

rootness(){
    if [[ $EUID -ne 0 ]]; then
       echo -e "${red}Error: This script must be run as root!${plain}" 1>&2
       exit 1
    fi
}

disable_selinux() {
    if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
        setenforce 0
    fi
}

set_timezone()
{
    if ! grep -q "Asia/Shanghai" /etc/timezone; then
    echo "Asia/Shanghai" >/etc/timezone
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    fi
}

chkinstall_shadowsocks()
{
    if [ -f ${ss_init} ] ; then
        echo -e "${green}Shadowsocks installed${plain}"
    else
        rm -rf ./shadowsocks-install.*
        wget --no-check-certificate ${giturl}/shadowsocks-install.sh >>$relog 2>&1 &&
        ( chmod +x shadowsocks-install.sh ;
        echo -e "${green}done: Shadowsocks installationscripts${plain}" ) ||
        echo -e "${red}failed: Shadowsocks installationscripts${plain}"
    fi
}

chkinstall_serverspeeder()
{
    if [ -f ${serverspeeder_init} ] ; then
        echo -e "${green}serverSpeeder installed${plain}"
    else
        rm -rf ./serverspeeder.*
        wget --no-check-certificate ${giturl}/serverspeeder.sh >>$relog 2>&1  &&
        ( chmod +x serverspeeder.sh ;
        echo -e "${green}done: serverSpeeder installationscripts${plain}" ) ||
        echo -e "${red}failed: serverSpeeder installationscripts${plain}"
    fi
}

optimized_shadowsocks()
{
    if ! grep -q "* soft nofile" /etc/security/limits.conf; then
        echo -e "* soft nofile 65535\n* hard nofile 65535" >> /etc/security/limits.conf
    fi
    ulimit -n 65535
    
    if ! [ -f /etc/sysctl.d/local.conf ] ; then
    cat > /etc/sysctl.d/local.conf<<-EOF
fs.file-max = 65535
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.rmem_default = 65536
net.core.wmem_default = 65536
net.core.netdev_max_backlog = 4096
net.core.somaxconn = 4096
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 4096
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mtu_probing = 1

#Google BBR
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
EOF
    fi
    sysctl --system >>$relog 2>&1
    sysctl -p /etc/sysctl.d/local.conf >>$relog 2>&1
}


restart_service()
{
    if [ -f ${ss_init} ] ; then
        echo -e "${red}Restart Service: Shadowsocks${plain}"
        ${ss_init} restart
    fi
    
    if [ -f ${serverspeeder_init} ] ; then
        echo -e "${red}Restart Service: serverSpeeder${plain}"
        ${serverspeeder_init} restart
    fi
}

rm -rf $relog
rootness
disable_selinux
set_timezone
chkinstall_shadowsocks
chkinstall_serverspeeder
optimized_shadowsocks
restart_service