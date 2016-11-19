echo "Asia/Shanghai" >/etc/timezone
/etc/init.d/shadowsocks restart
/serverspeeder/bin/serverSpeeder.sh restart
clear
sysctl -p
ulimit -n 51200
