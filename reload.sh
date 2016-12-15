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
giturl=https://raw.githubusercontent.com/FishDDev/tools/Privated/setuptools

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
        echo -e "${green}done: Shadowsocks installation scripts${plain}" ) ||
        echo -e "${red}failed: Shadowsocks installation scripts${plain}"
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
        echo -e "${green}done: serverSpeeder installation scripts${plain}" ) ||
        echo -e "${red}failed: serverSpeeder installation scripts${plain}"
    fi
}

optimized_shadowsocks()
{
    if ! grep -q "* soft nofile" /etc/security/limits.conf; then
        echo -e "* soft nofile 512000\n* hard nofile 1024000" >> /etc/security/limits.conf
    fi
    
    if ! grep -q "ulimit -SHn 1024000" /etc/profile; then
        echo -e "ulimit -SHn 1024000" >> /etc/profile
    fi
    
    ulimit -SHn 1024000
    
    if ! [ -f /etc/sysctl.d/local.conf ] ; then
    cat > /etc/sysctl.d/local.conf<-EOF
#Google BBR
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
# max open files
fs.file-max = 1024000
# max read buffer
net.core.rmem_max = 67108864
# max write buffer
net.core.wmem_max = 67108864
# default read buffer
net.core.rmem_default = 65536
# default write buffer
net.core.wmem_default = 65536
# max processor input queue
net.core.netdev_max_backlog = 4096
# max backlog
net.core.somaxconn = 4096
# resist SYN flood attacks
net.ipv4.tcp_syncookies = 1
# reuse timewait sockets when safe
net.ipv4.tcp_tw_reuse = 1
# turn off fast timewait sockets recycling
net.ipv4.tcp_tw_recycle = 0
# short FIN timeout
net.ipv4.tcp_fin_timeout = 30
# short keepalive time
net.ipv4.tcp_keepalive_time = 1200
# outbound port range
net.ipv4.ip_local_port_range = 10000 65000
# max SYN backlog
net.ipv4.tcp_max_syn_backlog = 4096
# max timewait sockets held by system simultaneously
net.ipv4.tcp_max_tw_buckets = 5000
# TCP receive buffer
net.ipv4.tcp_rmem = 4096 87380 67108864
# TCP write buffer
net.ipv4.tcp_wmem = 4096 65536 67108864
# turn on path MTU discovery
net.ipv4.tcp_mtu_probing = 1
# forward ivp4
net.ipv4.ip_forward = 1
EOF
    sysctl -p >>$relog 2>&1
    sysctl --system >>$relog 2>&1
    sysctl -p /etc/sysctl.d/local.conf >>$relog 2>&1
    fi
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