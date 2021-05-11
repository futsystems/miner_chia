#!/bin/bash

if [ $# -eq 0 ]; then
	echo "No arguments provided"
	exit 1
fi

./install_component.sh $1

./install_nvme.sh

./install_chia.sh

./install_plotman.sh


