#!/bin/bash


# Wait until api.plotter started and listens on port 8080.
while [ -z "`netstat -tln | grep 8080`" ]; do
  echo 'Waiting for api.plotter to start ...'
  sleep 1
done
echo 'api.plotter started.'


echo 'generate plotman config from api.plotter'
mkdir -p /root/.config/plotman/
wget http://127.0.0.1:8080/config/plotman?version=2 -O /root/.config/plotman/plotman.yaml


is_plotting_run=$(curl http://127.0.0.1:8080/config/plotman/is_plotting_run)

if [ $is_plotting_run == 1 ];then
        echo 'run plotman plot '
	/opt/src/scripts/runinenv.sh /opt/chia/chia-blockchain/venv plotman plot
else
        echo 'plotter is set not running, just exit'
	sleep 5
	exit
fi



