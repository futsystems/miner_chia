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
		supervisorctl restart api.plotter
	fi

	if [ -d "/opt/nas/bin" ]; then
		echo "======== Update NAS API ========"
		cd /opt/nas/bin
		git reset --hard
		git pull
		supervisorctl restart api.nas
	fi
	exit 0
else
	echo "/opt/src do not exist, please install first"
	exit 1
fi






