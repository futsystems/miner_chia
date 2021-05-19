#/bin/bash
  
apt-get update

apt install python3-virtualenv
apt install pv

#mkdir
mkdir -p /opt/harvester
mkdir -p /opt/harvester/config

cd /opt/nas
git clone https://gitlab.marvelsystem.net/miner/plotmgr.git bin
cd bin

virtualenv venv
source ./venv/bin/activate
pip install -r requirement.txt

ln -s /opt/harvester/bin/supervisor/nas.conf /etc/supervisor/conf.d/nas.conf
cp plotmgr.conf /opt/harvester/config/











