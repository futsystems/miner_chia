#/bin/bash
  
apt-get update

apt install python3-virtualenv
apt install pv

#clean folder
rm -rf /opt/harvester

#mkdir
mkdir -p /opt/plotter
mkdir -p /opt/plotter/config

cd /opt/plotter
git config --global http.proxy http://miner:xyz123456@access.futsystems.com:8888
git clone git@github.com:futsystems/miner_plotmgr.git bin
git config --global --unset http.proxy
cd bin

virtualenv venv
source ./venv/bin/activate
pip install -r requirement.txt

# prepare supervisor config and api config
ln -s -f /opt/plotter/bin/supervisor/plotter.conf /etc/supervisor/conf.d/plotter.conf
cp plotmgr.conf /opt/plotter/config/

#start api service
supervisorctl reread
supervisorctl remove api.plotter
supervisorctl add api.plotter













