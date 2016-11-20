#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

chkinstall_ss()
{
    if [ -f /usr/local/bin/ss-server ] ; then
        echo "Shadowsocks-libev 已安装"    
    else
        wget --no-check-certificate https://raw.githubusercontent.com/FishDDev/tools/Privated/install/shadowsocks-libev.sh &&
          chmod +x shadowsocks-libev.sh;
          echo "Shadowsocks-libev 安装引导文件已下载完成" || 
          echo "Shadowsocks-libev 安装引导文件下载出错"
    fi
}

chkinstall_ss
