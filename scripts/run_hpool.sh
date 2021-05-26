#!/bin/bash


# Wait until api.plotter started and listens on port 8080.
while [ -z "`netstat -tln | grep 8080`" ]; do
  echo 'Waiting for api.plotter to start ...'
  sleep 1
done
echo 'api.plotter started.'


echo 'generate hpool  config from api.plotter'
wget http://127.0.0.1:8080/config/hpool -O /opt/hpool/config.yaml

#start hpool
/opt/hpool/hpool-miner-chia -config /opt/hpool/config.yaml


