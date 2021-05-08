#!/bin/bash

paths=$(ls /mnt/cache/)
for path in $paths
do
 echo $path
	echo 'clean cache path:'$path
	rm -rf /mnt/cache/$path/*
done