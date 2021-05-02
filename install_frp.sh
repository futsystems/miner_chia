#!/bin/bash

mkdir -p /opt/frp

cp frp_0.36.2_linux_amd64.tar.gz /opt/frp

cd /opt/frp
tar zxvf frp_0.36.2_linux_amd64.tar.gz

ln -s frp_0.36.2_linux_amd64 bin

cd /opt/src
cp /opt/src/configs/frpc.ini.tpl /opt/frp/frpc.ini
ln -s /opt/src/supervisor/frpc.conf /etc/supervisor/conf.d/frpc.conf

echo "please change config for frp"