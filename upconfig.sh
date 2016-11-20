#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

rm -rf ./limits.conf
rm -rf /etc/security/limits.conf
wget --no-check-certificate https://raw.githubusercontent.com/FishDDev/tools/Privated/etc/security/limits.conf
mv -vf ./limits.conf /etc/security/limits.conf


rm -rf ./local.conf
rm -rf /etc/sysctl.d/local.conf
wget --no-check-certificate https://raw.githubusercontent.com/FishDDev/tools/Privated/etc/sysctl.d/local.conf
mv -vf ./local.conf /etc/sysctl.d/local.conf


rm -rf ./config.json
rm -rf /etc/shadowsocks-libev/config.json
wget --no-check-certificate https://raw.githubusercontent.com/FishDDev/tools/Privated/etc/shadowsocks-libev/config.json
mv -vf ./config.json /etc/shadowsocks-libev/config.json

