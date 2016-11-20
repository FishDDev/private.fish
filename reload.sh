#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#remove boot script
rm -rf serverspeeder.sh shadowsocks-libev.sh yum.install.sh upconfig.sh >/dev/null

#set timezone
echo "Asia/Shanghai" >/etc/timezone

#set ulimit
ulimit -n 51200

#reload /etc/sysctl.d/local.conf
sysctl -p /etc/sysctl.d/local.conf

#reload shadowsocks
/etc/init.d/shadowsocks restart

#reload serverspeeder
/serverspeeder/bin/serverSpeeder.sh restart

