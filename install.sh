#/bin/bash
  
apt-get update

apt install -y supervisor net-tools sysfsutils
apt install -y nvme-cli dstat sysstat glances smartmontools lm-sensors
apt install -y dracut-core
apt install -y sysbench p7zip-fulil
apt install -y python3-virtualenv
apt install -y pv
snap install duf-utility


#enable rc.local
rm -rf /etc/systemd/system/rc-local.service
rm -rf /etc/rc.local

ln -s /opt/src/rc-local.service /etc/systemd/system/rc-local.service
ln -s /opt/src/rc.local /etc/rc.local

systemctl enable rc-local.service

#set git config
git config --global user.email "miner@example.com"
git config --global user.name "miner"

#endbale nvme

if [ $(lsblk | grep --count 'nvme0') == '0' ];then
  echo 'nvme not installed'
else
  echo 'nvme installed'
  rm -rf /etc/modprobe.d/nvme.conf
  ln -s /opt/src/nvme.conf /etc/modprobe.d/nvme.conf
  update-initramfs -u
fi









