#!/bin/bash

yum install -y iptables-services

systemctl stop firewalld.service
systemctl disable firewalld.service

systemctl stop haproxy.service
systemctl disable haproxy.service
chkconfig haproxy off

systemctl restart iptables.service
systemctl enable iptables.service
chkconfig iptables on

echo "1"> /proc/sys/net/ipv4/ip_forward

iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination 45.76.67.7:443
iptables -t nat -A PREROUTING -p udp --dport 443 -j DNAT --to-destination 45.76.67.7:443
iptables -t nat -A POSTROUTING -p tcp -d 45.76.67.7 --dport 443 -j SNAT --to-source 10.104.118.75
iptables -t nat -A POSTROUTING -p udp -d 45.76.67.7 --dport 443 -j SNAT --to-source 10.104.118.75

service iptables save
service iptables restart

#echo 'net.ipv4.ip_forward = 1' >>/etc/sysctl.conf
sysctl -p /etc/sysctl.conf
sysctl --system

echo 'done'