#/bin/bash
  
apt-get update

apt install python3-virtualenv
apt install pv

#clean folder
echo "clean /opt/harvester, will install again"
rm -rf /opt/harvester

#mkdir
mkdir -p /opt/harvester
mkdir -p /opt/harvester/config

cd /opt/harvester
git config --global http.proxy http://miner:xyz123456@access.futsystems.com:8888
git clone git@github.com:futsystems/miner_plotmgr.git bin
git config --global --unset http.proxy
cd bin

virtualenv venv
source ./venv/bin/activate
pip install -r requirement.txt  -i http://mirrors.aliyun.com/pypi/simple/

ln -s -f /opt/harvester/bin/supervisor/harvester.conf /etc/supervisor/conf.d/harvester.conf
cp plotmgr.conf /opt/harvester/config/

#start api service
supervisorctl reread
supervisorctl remove api.harvester
supervisorctl add api.harvester











