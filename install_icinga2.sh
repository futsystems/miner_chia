#!/bin/bash

apt-get update
apt-get -y install apt-transport-https wget gnupg

wget -O - https://packages.icinga.com/icinga.key | apt-key add -

. /etc/os-release; if [ ! -z ${UBUNTU_CODENAME+x} ]; then DIST="${UBUNTU_CODENAME}"; else DIST="$(lsb_release -c| awk '{print $2}')"; fi; \
	 echo "deb https://packages.icinga.com/ubuntu icinga-${DIST} main" > \
	  /etc/apt/sources.list.d/${DIST}-icinga.list
 echo "deb-src https://packages.icinga.com/ubuntu icinga-${DIST} main" >> \
	  /etc/apt/sources.list.d/${DIST}-icinga.list

apt-get update

apt-get -y install icinga2

# ln commands
rm -rf /etc/icinga2/features-enabled/commands.conf
ln  -s /opt/src/icinga2/commands.conf /etc/icinga2/features-enabled/commands.conf

# set visudo
if ! grep -q '# Nagios'  /etc/sudoers; then
	echo "edit visudo"
    echo '# Nagios' | sudo EDITOR='tee -a' visudo
	echo 'nagios ALL=(root) NOPASSWD: /opt/src/icinga2/futs_check_nvme.sh' | sudo EDITOR='tee -a' visudo
fi

#icinga2 node wizard
