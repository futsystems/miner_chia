#!/bin/bash

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
else
	echo "/opt/src do not exist, please install first"
fi






