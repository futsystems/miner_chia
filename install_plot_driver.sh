#/bin/bash

#
echo "Auto format disk and mout"

device_list=$(ls /dev/)
counter=0
for device in $device_list
 do
   #echo $device
   if [[ $device == sd* ]]; then
	    disksize=$(lsblk -b --output SIZE -n -d /dev/$device)
	  disksizeT=`expr $disksize / 1000 / 1000 / 1000 / 1000`
      if [ $disksizeT -gt 5 ]; then
         echo "======Disk"$counter":$device======"
      	 echo 'disk size:' $disksizeT
		# get disk information or format it as ext4
         blkid TYPE=ext4 /dev/$device || mkfs.ext4 -m 0 -T largefile4 -L plotdisk /dev/$device
		
		#mount disk
		mkdir -p /mnt/plots/driver$counter
		counter=$((counter+1))
      fi
   fi
done

