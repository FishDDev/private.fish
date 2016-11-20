#!/bin/sh

rm -rf serverspeeder.sh shadowsocks-libev.sh yum.install.sh upconfig.sh >/dev/null

echo "Asia/Shanghai" >/etc/timezone
/etc/init.d/shadowsocks restart
/serverspeeder/bin/serverSpeeder.sh restart
clear
sysctl -p
ulimit -n 51200
