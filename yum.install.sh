#wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
#rpm -ivh epel-release-X-Y.noarch.rpm

#yum upgrade
yum clean all
yum update upgrade

#yum & pip install
yum install -y libnet libpcap libnet-devel libpcap-devel net-tools python-pip libevent
pip install --upgrade -I pip
pip install -I greenlet gevent

#wget --no-check-certificate https://github.com/FishDDev/tools/archive/Privated.zip

#get shadowsocks-libev
rm -rf shadowsocks-libev.sh
wget --no-check-certificate https://raw.githubusercontent.com/FishDDev/tools/Privated/install/shadowsocks-libev.sh
chmod +x shadowsocks-libev.sh

#get serverspeeder
rm -rf serverspeeder.sh
wget --no-check-certificate https://raw.githubusercontent.com/FishDDev/tools/Privated/install/serverspeeder.sh
chmod +x serverspeeder.sh
