#/bin/bash
  
apt-get update

apt install python3-virtualenv
apt install pv

#mkdir
mkdir -p /opt/nas
mkdir -p /opt/nas/config

cd /opt/nas
git clone https://gitlab.marvelsystem.net/miner/plotmgr.git bin
cd bin

virtualenv venv
source ./venv/bin/activate
pip install -r requirement.txt

ln -s /opt/nas/bin/supervisor/nas.conf /etc/supervisor/conf.d/nas.conf
cp plotmgr.conf /opt/nas/config/











