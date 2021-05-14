#!/bin/bash

if [ $# -eq 0 ]; then
	echo "No arguments provided"
	exit 1
fi

echo "======== Install Frpc ========"
./install_frp.sh

echo "======== Install Components ========"
./install_component.sh $1

echo "======== Install Chia ========"
./install_chia.sh

if [ $1 == 'harvester' ]; then
	echo "======== Install Harvester ========"
	./install_api_harvester.sh
fi

if [ $1 == 'plotter' ]; then
	echo "======== Install Plotter ========"
	./install_nvme.sh
	./driver/plotter_driver.sh
	./install_plotman.sh
	./install_api_plotter.sh
	
fi


echo "======== Prepare Config ========"
sleep 5
echo "  -- frpc config"
wget http://127.0.0.1:8080/config/frpc -O /opt/frp/frpc.ini
supervisorctl restart srv.frpc

echo "  -- plotman config"
mkdir -p /root/.config/plotman/
wget http://127.0.0.1:8080/config/plotman -O /root/.config/plotman/plotman.yaml

echo "  -- hpool config"
wget http://127.0.0.1:8080/config/hpool -O /opt/hpool/config.yaml

echo "======== Install Hpool========"
./install_hpool.sh

echo "======== Install Icinga2 ========"
./install_icinga2.sh
echo "====== Stand By, Will Reboot========"
sleep 5
