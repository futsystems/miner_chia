#!/bin/bash

# Wait until api.harvester started and listens on port 8080.
while [ -z "`netstat -tln | grep 8080`" ]; do
  echo 'Waiting for api.plotter to start ...'
  sleep 1
done
echo 'api.harvester started.'


cd /opt/chia/chia-blockchain/
. ./activate

echo '==== 1. stop all chia ===='
chia stop all -d

echo '==== 2. init chia with ca ===='
chia init -c /opt/tmp/ca/

echo '==== 3. generate harvester config ===='
wget http://127.0.0.1:8080/config/harvester/chia  -O /root/.chia/mainnet/config/config.yaml


echo '==== 4. start harvester ===='
chia start harvester -r







