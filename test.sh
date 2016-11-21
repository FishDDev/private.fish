#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Set Download URL
GITURL=https://raw.githubusercontent.com/FishDDev/tools/Privated

chkinstall_shadowsocks-libev()
{
    if [ -f /usr/local/bin/ss-server ] ; then
        echo "Shadowsocks-libev 已安装"    
    else
        wget --no-check-certificate ${GITURL}/install/shadowsocks-libev.sh &&
          { chmod +x shadowsocks-libev.sh ; echo "Shadowsocks-libev 安装引导文件已下载完成" } || 
          echo "Shadowsocks-libev 安装引导文件下载出错"
    fi
}


chkinstall_serverSpeeder()
{
    if [ -f /serverspeeder/bin/serverSpeeder.sh ] ; then
        echo "serverSpeeder 已安装"
    else
        wget --no-check-certificate ${GITURL}/install/serverspeeder.sh &&
          { chmod +x serverspeeder.sh ; echo "serverSpeeder 安装引导文件已下载完成" } || 
          echo "serverSpeeder 安装引导文件下载出错"
    fi
}


chkinstall_shadowsocks-libev
chkinstall_serverspeeder
