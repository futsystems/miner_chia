#/bin/bash

path_list=$(ls /mnt/plots)
echo '----- umount old mount pints -----'
for path in $path_list
do
 mount_point='/mnt/plots/'$path
 umount $mount_point
done

rm -rf /mnt/plots

./driver/harvester_driver.sh

./hpool/restart_hpool.sh

