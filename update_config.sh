#!/bin/bash

# Wait until api.plotter started and listens on port 8080.
while [ -z "`netstat -tln | grep 8080`" ]; do
  echo 'Waiting for api service to start ...'
  sleep 1
done
echo 'api service started.'


echo "======== Prepare Config ========"
echo "  -- frpc config"
wget http://127.0.0.1:8080/config/frpc -O /opt/frp/frpc.ini
supervisorctl restart srv.frpc


if [ -d "/opt/plotter/bin" ]; then
	echo "======== Update Ploter API ========"
	wget http://127.0.0.1:8080/config/plotman -O /root/.config/plotman/plotman.yaml
	supervisorctl restart api.plot
fi

echo "  -- hpool config"
wget http://127.0.0.1:8080/config/hpool -O /opt/hpool/config.yaml
supervisorctl restart srv.hpool
