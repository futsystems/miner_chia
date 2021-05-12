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

apt-get install icinga2

# ln commands
ln -s /opt/src/icinga2/commands.conf commands.conf

icinga2 node wizard
