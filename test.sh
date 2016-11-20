#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

chkinstall_shadowsocks-libev(){
    if [ -f /usr/local/bin/ss-server ]; then
#Shadowsocks-libev 已安装提示
        echo "Shadowsocks-libev 已安装"                   
    else
#移除 Shadowsocks-libev 旧安装引导文件
        rm -rf /root/shadowsocks-libev.sh >/dev/null
#下载 Shadowsocks-libev 安装引导文件
        wget --no-check-certificate https://raw.githubusercontent.com/FishDDev/tools/Privated/install/shadowsocks-libev.sh && (chmod +x shadowsocks-libev.sh;echo "Shadowsocks-libev 安装引导文件已下载完成") || echo "Shadowsocks-libev 安装引导文件下载出错"
    fi
}

chkinstall_shadowsocks-libev
