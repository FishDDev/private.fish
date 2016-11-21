#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Set Download URL
GITURL=https://raw.githubusercontent.com/FishDDev/tools/Privated


set_timezone()
{
    echo "Asia/Shanghai" >/etc/timezone
}

chkinstall_shadowsocks-libev()
{
    if [ -f /usr/local/bin/ss-server ] ; then
        echo "Shadowsocks-libev 已安装"

#Update /etc/shadowsocks-libev/config.json
        rm -rf ./config.json
        rm -rf /etc/shadowsocks-libev/config.json
        wget --no-check-certificate ${GITURL}/etc/shadowsocks-libev/config.json &&
          { mv -vf ./config.json /etc/shadowsocks-libev/config.json &&
          echo "/etc/shadowsocks-libev/config.json 更新成功 " } ||
          echo "/etc/shadowsocks-libev/config.json 更新失败"

#Update /etc/sysctl.d/local.conf
        rm -rf ./local.conf
        rm -rf /etc/sysctl.d/local.conf
        wget --no-check-certificate ${GITURL}/etc/sysctl.d/local.conf &&
          { mv -vf ./local.conf /etc/sysctl.d/local.conf && sysctl -p /etc/sysctl.d/local.conf &&
          echo "/etc/sysctl.d/local.conf 更新成功 " } ||
          echo "/etc/sysctl.d/local.conf 更新失败"

#Update /etc/security/limits.conf
        rm -rf ./limits.conf
        rm -rf /etc/security/limits.conf
        wget --no-check-certificate ${GITURL}/etc/security/limits.conf &&
          { mv -vf ./limits.conf /etc/security/limits.conf && ulimit -n 51200 && 
          echo "/etc/security/limits.conf 更新成功" } ||
          echo "/etc/security/limits.conf 更新失败"

#restart shadowsocks-libev
        /etc/init.d/shadowsocks restart
    else

#Download shadowsocks-libev.sh
        rm -rf ./shadowsocks-libev.sh
        wget --no-check-certificate ${GITURL}/install/shadowsocks-libev.sh &&
          { chmod +x shadowsocks-libev.sh &&
          echo "Shadowsocks-libev 安装引导文件已下载完成" } || 
          echo "Shadowsocks-libev 安装引导文件下载出错"
    fi
}


chkinstall_serverSpeeder()
{
    if [ -f /serverspeeder/bin/serveSppeeder.sh ] ; then
        echo "serverSpeeder 已安装"

#Update /serverspeeder/etc/config
        rm -rf ./config
        rm -rf /serverspeeder/etc/config
        wget --no-check-certificate ${GITURL}/serverspeeder/etc/config &&
          { mv -vf ./config /serverspeeder/etc/config &&
          echo "/serverspeeder/etc/config 更新成功" } ||
          echo "/serverspeeder/etc/config 更新失败"

#restart serverspeeder
       /serverspeeder/bin/serverSpeeder.sh restart
    else

#Download serverspeeder.sh
        rm -rf ./serverspeeder.sh
        wget --no-check-certificate ${GITURL}/install/serverspeeder.sh &&
          { chmod +x serverspeeder.sh &&
          echo "serverSpeeder 安装引导文件已下载完成" } || 
          echo "serverSpeeder 安装引导文件下载出错"
    fi
}

set_timezone
chkinstall_shadowsocks-libev
chkinstall_serverspeeder
