#!/bin/bash


# Wait until api.plotter started and listens on port 8080.
while [ -z "`netstat -tln | grep 8080`" ]; do
  echo 'Waiting for api.plotter to start ...'
  sleep 1
done
echo 'api.plotter started.'


mkdir -p /opt/monero

echo 'generate monero json config from api.plotter'
wget http://127.0.0.1:8080/config/monero -O /opt/monero/config.json


is_monero=$(curl http://127.0.0.1:8080/config/plotman/is_plotting_run)

if [ $is_monero == 1 ];then
        echo 'run monero '
        cd /opt/monero
        /opt/monero/xmrig --config /opt/monero/config.json
else
        echo 'monero is set not running, just exit'
        sleep 10
        exit
fi
