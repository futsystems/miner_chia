#!/bin/bash

if [ $# -eq 0 ]; then
	echo "No arguments provided"
	exit 1
fi

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
	./install_plotman.sh
	./install_api_plotter.sh
	
fi


echo "======== Prepare Config ========"
sleep 5
echo "  -- frpc config"
wget http://127.0.0.1:8080/config/frpc -O /opt/frpc/frpc.ini