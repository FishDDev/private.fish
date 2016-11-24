
#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

##by:      Fish
##mailto:  fishdev@qq.com


# set github download url
GITURL=https://raw.githubusercontent.com/FishDDev/tools/Privated
RELOADLOG=/var/log/reload.log

# make sure only root can run our script
rootness(){
    if [[ $EUID -ne 0 ]]; then
       echo "Error: This script must be run as root!" 1>&2
       exit 1
    fi
}

# disable selinux
disable_selinux(){
    if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
        setenforce 0
    fi
}

# set timezone
set_timezone()
{
    echo "Asia/Shanghai" >/etc/timezone
}

# update reload.sh
update_script()
{
cat > /usr/bin/upreload<<-EOF
#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

cd /root
wget --no-check-certificate https://raw.githubusercontent.com/FishDDev/tools/Privated/yum.install.sh
chmod +x yum.install.sh
sh ./yum.install.sh
rm -rf ./yum.install.sh
EOF
chmod +x /usr/bin/upreload
}

# update /etc/sysctl.d/local.conf
update_local_config()
{
# create directory /etc/sysctl.d
        mkdir -p /etc/sysctl.d
# remove old /etc/sysctl.d/local.conf
        rm -rf ./local.conf
        rm -rf /etc/sysctl.d/local.conf
# download /etc/sysctl.d/local.conf
        wget --no-check-certificate ${GITURL}/etc/sysctl.d/local.conf >>$RELOADLOG 2>&1 &&
# update /etc/sysctl.d/local.conf & refresh sysctl
        ( mv -f ./local.conf /etc/sysctl.d/local.conf && sysctl -p /etc/sysctl.d/local.conf >>$RELOADLOG 2>&1 ; 
        echo "更新成功: /etc/sysctl.d/local.conf" ) ||
        echo "更新失败: /etc/sysctl.d/local.conf" 
}

# update /etc/security/limits.conf
update_limits_conf()
{
# create directory /etc/security
        mkdir -p /etc/security
# remove old /etc/security/limits.conf
        rm -rf ./limits.conf
        rm -rf /etc/security/limits.conf
# download /etc/security/limits.conf
        wget --no-check-certificate ${GITURL}/etc/security/limits.conf >>$RELOADLOG 2>&1 &&
# update /etc/security/limits.conf & set ulimit
        ( mv -f ./limits.conf /etc/security/limits.conf && ulimit -n 51200 ;
        echo "更新成功: /etc/security/limits.conf" ) ||
        echo "更新失败: /etc/security/limits.conf" ;
}

# update /etc/shadowsocks-libev/config.json
update_config_json()
{
# create directory /etc/shadowsocks-libev
        mkdir -p /etc/shadowsocks-libev
# remove old /etc/shadowsocks-libev/config.json
        rm -rf ./config.json
        rm -rf /etc/shadowsocks-libev/config.json
# download /etc/shadowsocks-libev/config.json
        wget --no-check-certificate ${GITURL}/etc/shadowsocks-libev/config.json >>$RELOADLOG 2>&1 &&
# update /etc/shadowsocks-libev/config.json
        ( mv -f ./config.json /etc/shadowsocks-libev/config.json &&
        echo "更新成功: /etc/shadowsocks-libev/config.json" ) ||
        echo "更新失败: /etc/shadowsocks-libev/config.json"
}

# check shadowsocks-libev installed
chkinstall_shadowsocks_libev()
{
    if [ -f /usr/local/bin/ss-server ] ; then
        echo "已安装: Shadowsocks-libev"
# remove old shadowsocks-libev.sh
        rm -rf shadowsocks-libev.sh
# update config
        update_local_config
        update_limits_conf
        update_config_json
# restart shadowsocks-libev service
        /etc/init.d/shadowsocks restart
    else
# remove old shadowsocks-libev.sh
        rm -rf shadowsocks-libev.sh
# download shadowsocks-libev.sh & set permissions
        wget --no-check-certificate ${GITURL}/install/shadowsocks-libev.sh >>$RELOADLOG 2>&1 &&
        ( chmod +x shadowsocks-libev.sh ;
        echo "获取成功: Shadowsocks-libev installation Script" ) ||
        echo "获取失败: Shadowsocks-libev installation Script"
    fi
}

# check serverspeeder installed
chkinstall_serverspeeder()
{
    if [ -f /serverspeeder/bin/serverSpeeder.sh ] ; then
        echo "已安装: serverSpeeder"
# remove old serverspeeder.sh
        rm -rf serverspeeder.sh
        rm -rf 91yunserverspeeder
        rm -rf 91yunserverspeeder.tar.gz
# restart serverspeeder service
        /serverspeeder/bin/serverSpeeder.sh restart
    else
# remove old serverspeeder.sh
        rm -rf serverspeeder.sh
        rm -rf 91yunserverspeeder
        rm -rf 91yunserverspeeder.tar.gz
# download serverspeeder.sh & set permissions
        wget --no-check-certificate ${GITURL}/install/serverspeeder.sh >>$RELOADLOG 2>&1  &&
        ( chmod +x serverspeeder.sh ;
        echo "获取成功: serverSpeeder installation Script" ) ||
        echo "获取失败: serverSpeeder installation Script"
    fi
}

# remove old /var/log/reload.log
rm -rf $RELOADLOG
# run shell
rootness
disable_selinux
set_timezone
chkinstall_shadowsocks_libev
chkinstall_serverspeeder
update_script
