#!/bin/bash

ssinstdir="$(cd $(dirname $0) && pwd)"
cd $ssinstdir

if [ `uname -p` != 'x86_64' ]; then
    echo "Ubuntu/Debian 64bit required! Exiting..."
    exit 1
fi

if [ `id -u` != '0' ]; then
    echo "root permission required! Please run as root. Exiting..."
    exit 1
fi


read -p "Shadowsocks Server IP   >" SS_IP
read -p "Shadowsocks Server Port >" SS_PORT
read -p "Shadowsocks Password    >" YOURPASSWORD

cp config/ss.conf.tpl config/ss.conf
sed -i "s/SS_IP/$SS_IP/g" config/ss.conf
sed -i "s/SS_PORT/$SS_PORT/g" config/ss.conf
sed -i "s/YOURPASSWORD/$YOURPASSWORD/g" config/ss.conf



echo "
         Encrypting Method is set to 'aes-256-cfb' as default,
         (If not right , please manually fix 'config/ss.conf' now ),
         Then hit ENTER key to continue.
"
read junk


echo "The SS config file looks like:"
cat config/ss.conf
read -p "Hit Enter to continue" junk
echo "Hit Enter to begin automitically installation."

dpkg -R -i debfiles

mv /etc/polipo/config /etc/polipo/config.bak
mv /etc/shadowsocks-libev/config.json /etc/shadowsocks-libev/config.json.bak
cp config/polipo.conf /etc/polipo/config
cp config/ss.conf /etc/shadowsocks-libev/config.json
cp -r acl_list /etc/shadowsocks-libev/
echo "bypass-lan-china.acl" > /etc/shadowsocks-libev/acl_selection
update-rc.d polipo disable >/dev/null 2>/dev/null

chmod +x Shadowsocks
rm /usr/bin/Shadowsocks 2>/dev/null
ln -s $ssinstdir/Shadowsocks /usr/bin/Shadowsocks 2>/dev/null


# avoid duplicated installation
sed -i "s/alias Shadowsocks-setproxy='source \/etc\/shadowsocks-libev\/envproxy\/set'//g" /etc/bash.bashrc 
sed -i "s/alias Shadowsocks-unsetproxy='source \/etc\/shadowsocks-libev\/envproxy\/unset'//g" /etc/bash.bashrc 

# install alias to setup proxy
echo "
alias Shadowsocks-setproxy='source /etc/shadowsocks-libev/envproxy/set'
alias Shadowsocks-unsetproxy='source /etc/shadowsocks-libev/envproxy/unset'" >> /etc/bash.bashrc 

mkdir /etc/shadowsocks-libev/envproxy 2>/dev/null
echo "export HTTP_PROXY=http://127.0.0.1:1080
export http_proxy=\$HTTP_PROXY
export HTTPS_PROXY=\$HTTP_PROXY
export https_proxy=\$HTTP_PROXY
" > /etc/shadowsocks-libev/envproxy/set
echo "unset HTTP_PROXY http_proxy HTTPS_PROXY https_proxy" > /etc/shadowsocks-libev/envproxy/unset


echo "
    Installation Completed!
    Now you can run Shadowsocks at any terminal.
"

