#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

##by:      Fish
##mailto:  fishdev@qq.com


# Set Github download url
GITURL=https://raw.githubusercontent.com/FishDDev/tools/Privated
RELOADLOG=/var/log/reload.log

# Make sure only root can run our script
rootness(){
    if [[ $EUID -ne 0 ]]; then
       echo "Error: This script must be run as root!" 1>&2
       exit 1
    fi
}

# Disable selinux
disable_selinux(){
    if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
        setenforce 0
    fi
}

# Set Timezone
set_timezone()
{
    echo "Asia/Shanghai" >/etc/timezone
}

# Update /etc/sysctl.d/local.conf
update_local_config()
{
# Create directory /etc/sysctl.d
        mkdir -p /etc/sysctl.d
# Remove old /etc/sysctl.d/local.conf
        rm -rf ./local.conf
        rm -rf /etc/sysctl.d/local.conf
# Download /etc/sysctl.d/local.conf
        wget --no-check-certificate ${GITURL}/etc/sysctl.d/local.conf >>$RELOADLOG 2>&1 &&
# Update /etc/sysctl.d/local.conf & Refresh sysctl
        ( mv -f ./local.conf /etc/sysctl.d/local.conf && sysctl -p /etc/sysctl.d/local.conf >>$RELOADLOG 2>&1 ; 
        echo "/etc/sysctl.d/local.conf 更新成功 " ) ||
        echo "/etc/sysctl.d/local.conf 更新失败" 
}

# Update /etc/security/limits.conf
update_limits_conf()
{
# Create directory /etc/security
        mkdir -p /etc/security
# Remove old /etc/security/limits.conf
        rm -rf ./limits.conf
        rm -rf /etc/security/limits.conf ;
# Download /etc/security/limits.conf
        wget --no-check-certificate ${GITURL}/etc/security/limits.conf >>$RELOADLOG 2>&1 &&
# Update /etc/security/limits.conf & Set ulimit
        ( mv -f ./limits.conf /etc/security/limits.conf && ulimit -n 51200 ;
        echo "/etc/security/limits.conf 更新成功" ) ||
        echo "/etc/security/limits.conf 更新失败" ;
}

# Update /etc/shadowsocks-libev/config.json
update_config_json()
{
# Create directory /etc/shadowsocks-libev
        mkdir -p /etc/shadowsocks-libev
# Remove old /etc/shadowsocks-libev/config.json
        rm -rf ./config.json
        rm -rf /etc/shadowsocks-libev/config.json
# Download /etc/shadowsocks-libev/config.json
        wget --no-check-certificate ${GITURL}/etc/shadowsocks-libev/config.json >>$RELOADLOG 2>&1 &&
# Update /etc/shadowsocks-libev/config.json
        ( mv -f ./config.json /etc/shadowsocks-libev/config.json &&
        echo "/etc/shadowsocks-libev/config.json 更新成功 " ) ||
        echo "/etc/shadowsocks-libev/config.json 更新失败"
}

# Check Shadowsocks-libev installed
chkinstall_shadowsocks_libev()
{
    if [ -f /usr/local/bin/ss-server ] ; then
        echo "Shadowsocks-libev 已安装"
# Remove old shadowsocks-libev.sh
        rm -rf shadowsocks-libev.sh
# Update config
        update_local_config
        update_limits_conf
        update_config_json
# Restart shadowsocks-libev Service
        /etc/init.d/shadowsocks restart
    else
# Remove old shadowsocks-libev.sh
        rm -rf shadowsocks-libev.sh
# Download shadowsocks-libev.sh & Set permissions
        wget --no-check-certificate ${GITURL}/install/shadowsocks-libev.sh >>$RELOADLOG 2>&1 &&
        ( chmod +x shadowsocks-libev.sh ;
        echo "Shadowsocks-libev 安装引导文件已下载完成" ) ||
        echo "Shadowsocks-libev 安装引导文件下载出错"
    fi
}

# Check serverSpeeder installed
chkinstall_serverspeeder()
{
    if [ -f /serverspeeder/bin/serverSpeeder.sh ] ; then
        echo "serverSpeeder 已安装"
# Remove old serverspeeder.sh
        rm -rf serverspeeder.sh
        rm -rf 91yunserverspeeder
        rm -rf 91yunserverspeeder.tar.gz
# Restart serverspeeder Service
        /serverspeeder/bin/serverSpeeder.sh restart
    else
# Remove old serverspeeder.sh
        rm -rf serverspeeder.sh
        rm -rf 91yunserverspeeder
        rm -rf 91yunserverspeeder.tar.gz
# Download serverspeeder.sh & Set permissions
        wget --no-check-certificate ${GITURL}/install/serverspeeder.sh >>$RELOADLOG 2>&1  &&
        ( chmod +x serverspeeder.sh ;
        echo "serverSpeeder 安装引导文件已下载完成" ) ||
        echo "serverSpeeder 安装引导文件下载出错"
    fi
}

rm -rf $RELOADLOG
rootness
disable_selinux
set_timezone
chkinstall_shadowsocks_libev
chkinstall_serverspeeder
