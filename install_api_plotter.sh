#/bin/bash
  
apt-get update

apt install python3-virtualenv
apt install pv

#mkdir
mkdir -p /opt/plotter
mkdir -p /opt/plotter/config

cd /opt/plotter
git clone https://gitlab.marvelsystem.net/miner/plotmgr.git bin
cd bin

virtualenv venv
source ./venv/bin/activate
pip install -r requirement.txt

# prepare supervisor config and api config
ln -s /opt/plotter/bin/supervisor/plotter.conf /etc/supervisor/conf.d/plotter.conf
cp plotmgr.conf /opt/plotter/config/

#start api service
supervisorctl reread
supervisorctl add api.plotter













