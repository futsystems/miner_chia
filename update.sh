#!/bin/bash

###############################################
# Update System script, Plotter, NAS service 
#
###############################################

if [ -d "/opt/src" ]; then
	echo "======== Update System ========"
	cd /opt/src
	git reset --hard
	git pull

	if [ -d "/opt/plotter/bin" ]; then
		echo "======== Update Ploter API ========"
		cd /opt/plotter/bin
		git reset --hard
		git pull
		source venv/bin/activate
		pip install -r requirement.txt
		supervisorctl restart api.plotter
	fi

	if [ -d "/opt/harvester/bin" ]; then
		echo "======== Update NAS API ========"
		cd /opt/harvester/bin
		git reset --hard
		git pull
		supervisorctl restart api.harvester
	fi
	exit 0

	if [ -d "/opt/hpool" ]; then
                echo "======== Update Hpool ========"
		cp -rf /opt/src/hpool/hpool-miner-chia /opt/hpool/hpool-miner-chia
		supervisorctl update srv.hpool
        fi
        exit 0

else
	echo "/opt/src do not exist, please install first"
	exit 1
fi






