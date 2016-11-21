#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

rm -rf ./reload.sh
wget --no-check-certificate https://raw.githubusercontent.com/FishDDev/tools/Privated/reload.sh
chmod +x ./reload.sh
cp -f ./reload.sh /usr/bin/reload
chmod +x /usr/bin/reload


#yum
yum clean all
yum update 
yum upgrade

#yum & pip install
yum install -y libnet libpcap libnet-devel libpcap-devel net-tools python-pip libevent
pip install --upgrade -I pip
pip install -I greenlet gevent
