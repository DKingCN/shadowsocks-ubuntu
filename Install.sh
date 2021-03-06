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
read -p "Shadowsocks Method (aes-256-cfb, rc4-md5 or etc.)    >" YOURMETHOD

cp config/ss.conf.tpl config/ss.conf
sed -i "s/SS_IP/$SS_IP/g" config/ss.conf
sed -i "s/SS_PORT/$SS_PORT/g" config/ss.conf
sed -i "s/YOURPASSWORD/$YOURPASSWORD/g" config/ss.conf
sed -i "s/YOURMETHOD/$YOURMETHOD/g" config/ss.conf



echo "
         Then hit ENTER key to continue.
"
read junk


echo "The SS config file looks like:"
cat config/ss.conf
read -p "Hit Enter to continue" junk
echo "Hit Enter to begin automitically installation."

pushd libsodium
./install_libsodium.sh
popd

dpkg -R -i debfiles
apt-get -f install

mkdir -p /etc/shadowsocks-libev
mkdir -p /etc/polipo/
mv /etc/polipo/config /etc/polipo/config.bak 2>/dev/null
mv /etc/shadowsocks-libev/config.json /etc/shadowsocks-libev/config.json.bak 2>/dev/null
cp config/polipo.conf /etc/polipo/config
cp config/ss.conf /etc/shadowsocks-libev/config.json
cp -r acl_list /etc/shadowsocks-libev/acl_list
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

