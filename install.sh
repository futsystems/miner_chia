#/bin/bash
  
apt-get update

apt install supervisor net-tools
apt install nvme-cli dstat sysstat glances smartmontools lm-sensors
apt install dracut-core
snap install duf-utility


#enable rc.local
rm -rf /etc/systemd/system/rc-local.service
rm -rf /etc/rc.local

ln -s /opt/src/rc-local.service /etc/systemd/system/rc-local.service
ln -s /opt/src/rc.local /etc/rc.local

systemctl enable rc-local.service


#endbale nvme
rm -rf /etc/modprobe.d/nvme.conf
ln -s /opt/src/nvme.conf /etc/modprobe.d/nvme.conf
#update-initramfs -u








