#!/bin/bash


#/bin/bash

#if [ $# -eq 0 ]; then
#    echo "No disk mode provided, normal|raid"
#    exit 1
#fi
mkdir -p /mnt/dst
device_list=$(ls /dev/)
counter=0
for device in $device_list
 do
   if [[ $device == sd* ]]; then
	    disksize=$(lsblk -b --output SIZE -n -d /dev/$device)
	  disksizeT=`expr $disksize / 1000 / 1000 / 1000 / 1000`
      if [ $disksizeT -gt 4 ]; then
         echo "======Disk"$counter":$device Size:"$disksizeT"T======"
		 #get disk information or format it as ext4
         blkid TYPE=ext4 /dev/$device || mkfs.ext4 -m 0 -T largefile4 -L plotdisk /dev/$device
		#mount disk
		mkdir -p /mnt/dst/0$counter
		mount /dev/$device /mnt/dst/0$counter
		#echo 'mkdir -p /mnt/dst/0'$counter
		
		echo "clean bad plot files"
		cd /mnt/dst/0$counter
		find . -name "*" -type f -size 0c | xargs -n 1 rm -f
		
		counter=$((counter+1))
      fi
   fi
done
