#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Set Download URL
GITURL=https://raw.githubusercontent.com/FishDDev/tools/Privated
RELOADLOG=/var/log/reload.log

set_timezone()
{
    echo "Asia/Shanghai" >/etc/timezone
}

update_local_config()
{
        rm -rf ./local.conf /etc/sysctl.d/local.conf ;
        wget --no-check-certificate ${GITURL}/etc/sysctl.d/local.conf >>$RELOADLOG 2>&1 &&
        ( mv -f ./local.conf /etc/sysctl.d/local.conf && sysctl -p /etc/sysctl.d/local.conf >>$RELOADLOG 2>&1 ; 
        echo "/etc/sysctl.d/local.conf 更新成功 " ) ||
        echo "/etc/sysctl.d/local.conf 更新失败" 
}

update_limits_conf()
{
        rm -rf ./limits.conf /etc/security/limits.conf ;
        wget --no-check-certificate ${GITURL}/etc/security/limits.conf >>$RELOADLOG 2>&1 &&
       ( mv -f ./limits.conf /etc/security/limits.conf && ulimit -n 51200 ;
        echo "/etc/security/limits.conf 更新成功" ) ||
        echo "/etc/security/limits.conf 更新失败" ;
}


update_config_json()
{
        rm -rf ./config.json /etc/shadowsocks-libev/config.json
        wget --no-check-certificate ${GITURL}/etc/shadowsocks-libev/config.json >>$RELOADLOG 2>&1 &&
        ( mv -f ./config.json /etc/shadowsocks-libev/config.json &&
        echo "/etc/shadowsocks-libev/config.json 更新成功 " ) ||
        echo "/etc/shadowsocks-libev/config.json 更新失败"
}

clean_file()
{
        rm -rf shadowsocks-libev.sh
        rm -rf serverspeeder.sh
        rm -rf 91yunserverspeeder
        rm -rf 91yunserverspeeder.tar.gz
        rm -rf yum.install.sh
}

chkinstall_shadowsocks_libev()
{
    if [ -f /usr/local/bin/ss-server ]; then
        echo "Shadowsocks-libev 已安装"
        update_local_config
        update_limits_conf
        update_config_json
        /etc/init.d/shadowsocks restart
    else
        wget --no-check-certificate ${GITURL}/install/shadowsocks-libev.sh >>$RELOADLOG 2>&1 &&
        ( chmod +x shadowsocks-libev.sh ;
        echo "Shadowsocks-libev 安装引导文件已下载完成" ) ||
        echo "Shadowsocks-libev 安装引导文件下载出错"
    fi
}

chkinstall_serverspeeder()
{
    if [ -f /serverspeeder/bin/serverSpeeder.sh ] ; then
        echo "serverSpeeder 已安装"
        /serverspeeder/bin/serverSpeeder.sh restart
    else
        wget --no-check-certificate ${GITURL}/install/serverspeeder.sh >>$RELOADLOG 2>&1  &&
       ( chmod +x serverspeeder.sh ;
        echo "serverSpeeder 安装引导文件已下载完成" ) ||
        echo "serverSpeeder 安装引导文件下载出错"
    fi
}

rm -rf $RELOADLOG
set_timezone
clean_file
chkinstall_shadowsocks_libev
chkinstall_serverspeeder
clean_file
