#wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
#rpm -ivh epel-release-X-Y.noarch.rpm

#yum upgrade
yum clean all
yum update upgrade

#yum & pip install
yum install -y libnet libpcap libnet-devel libpcap-devel net-tools python-pip libevent
pip install --upgrade -I pip
pip install -I greenlet gevent
