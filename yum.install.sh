#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#by: Fish

#update reload script
rm -rf ./reload.sh
rm -rf /usr/bin/reload
wget --no-check-certificate https://raw.githubusercontent.com/FishDDev/tools/Privated/reload.sh
cp -f ./reload.sh /usr/bin/reload
chmod +x ./reload.sh
chmod +x /usr/bin/reload

#yum clean & update & upgrade
yum clean all
yum update 
yum upgrade

#yum & pip install packages
yum install -y libnet libpcap libnet-devel libpcap-devel net-tools python-pip libevent
pip install --upgrade -I pip
pip install -I greenlet gevent

#remove old script
rm -rf ./yum.install.sh
rm -rf ./reload

reload
