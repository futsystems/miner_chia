#!/bin/bash

is_plotting_run=$(curl http://127.0.0.1:8080/config/plotman/is_plotting_run)

if [ $is_plotting_run == 1 ];then
	echo 'run'
else
	echo 'not run'
fi
