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
        echo -e "* soft nofile 65535\n* hard nofile 65535" >> /etc/security/limits.conf
    fi
    ulimit -n 65535
    
    if ! [ -f /etc/sysctl.d/local.conf ] ; then
    cat > /etc/sysctl.d/local.conf<<-EOF
#Google BBR
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
# 提高整个系统的文件限制
# max open files
fs.file-max = 51200
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
# 表示开启SYN Cookies。当出现SYN等待队列溢出时，启用cookies来处理，可防范少量SYN攻击，默认为0，表示关闭；
net.ipv4.tcp_syncookies = 1
# reuse timewait sockets when safe
# 表示开启重用。允许将TIME-WAIT sockets重新用于新的TCP连接，默认为0，表示关闭；
net.ipv4.tcp_tw_reuse = 1
# turn off fast timewait sockets recycling
# 表示开启TCP连接中TIME-WAIT sockets的快速回收，默认为0，表示关闭；
net.ipv4.tcp_tw_recycle = 1
# short FIN timeout
# 修改系統默认的 TIMEOUT 时间。
net.ipv4.tcp_fin_timeout = 30
# short keepalive time
# 表示当keepalive起用的时候，TCP发送keepalive消息的频度。缺省是2小时，改为20分钟。
net.ipv4.tcp_keepalive_time = 1200
# outbound port range
# 表示用于向外连接的端口范围。缺省情况下很小：32768到61000，改为10000到65000。（注意：这里不要将最低值设的太低，否则可能会占用掉正常的端口！）
net.ipv4.ip_local_port_range = 10000 65000
# max SYN backlog
# 表示SYN队列的长度，默认为1024，加大队列长度为8192，可以容纳更多等待连接的网络连接数。
net.ipv4.tcp_max_syn_backlog = 4096
# max timewait sockets held by system simultaneously
# 表示系统同时保持TIME_WAIT的最大数量，如果超过这个数字，TIME_WAIT将立刻被清除并打印警告信息。
net.ipv4.tcp_max_tw_buckets = 5000

# TCP receive buffer
net.ipv4.tcp_rmem = 4096 87380 67108864
# TCP write buffer
net.ipv4.tcp_wmem = 4096 65536 67108864
# turn on path MTU discovery
net.ipv4.tcp_mtu_probing = 1

# turn on TCP Fast Open on both client and server side
# 对于内核版本新于**3.7.1**的，我们可以开启tcp_fastopen：
net.ipv4.tcp_fastopen = 3
EOF
    fi
    sysctl -p >>$relog 2>&1
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