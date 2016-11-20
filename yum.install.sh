#!/bin/sh
#wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
#rpm -ivh epel-release-X-

chmod +x ./yum.install.sh

#wget --no-check-certificate https://github.com/FishDDev/tools/archive/Privated.zip

#get shadowsocks-libev
rm -rf shadowsocks-libev.sh
wget --no-check-certificate https://raw.githubusercontent.com/FishDDev/tools/Privated/install/shadowsocks-libev.sh
chmod +x shadowsocks-libev.sh

#get serverspeeder
rm -rf serverspeeder.sh
wget --no-check-certificate https://raw.githubusercontent.com/FishDDev/tools/Privated/install/serverspeeder.sh
chmod +x serverspeeder.sh

rm -rf upconfig.sh
wget --no-check-certificate https://raw.githubusercontent.com/FishDDev/tools/Privated/upconfig.sh
chmod +x upconfig.sh

rm -rf reload.sh
wget --no-check-certificate https://raw.githubusercontent.com/FishDDev/tools/Privated/reload.sh
chmod +x reload.sh


#yum
yum clean all
yum update 
yum upgrade

#yum & pip install
yum install -y libnet libpcap libnet-devel libpcap-devel net-tools python-pip libevent
pip install --upgrade -I pip
pip install -I greenlet gevent

