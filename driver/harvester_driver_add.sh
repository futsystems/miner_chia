#/bin/bash


path_list=$(ls /mnt/plots)
old_driver_num=0

# count driver count which is mounted
for path in $path_list
do
	if mount | grep -q $path; then
		old_driver_num=$((old_driver_num+1))
    fi
done


echo 'there are '$old_driver_num' drivers before'



#list device mount whcih is not mounted
device_list=$(ls /dev/)
counter=0

for device in $device_list
 do
   if [[ $device == sd* ]]; then
	    disksize=$(lsblk -b --output SIZE -n -d /dev/$device)
	  disksizeT=`expr $disksize / 1000 / 1000 / 1000 / 1000`
      if [ $disksizeT -gt 5 ]; then
               	 		
		if mount | grep -q /dev/$device;
		then
        	echo "======Disk"$counter":$device [O]======"

		else
			echo "======Disk"$counter":$device [X]======"
        		echo 'disk size:' $disksizeT
			# get disk information or format it as ext4
         	blkid TYPE=ext4 /dev/$device || mkfs.ext4 -m 0 -T largefile4 -L plotdisk /dev/$device

			#mount disk
			mkdir -p /mnt/plots/driver$old_driver_num
			mount /dev/$device /mnt/plots/driver$old_driver_num
			echo 'mount /dev/'$device.' /mnt/plots/driver'$old_driver_num

			echo "clean bad plot files"
			cd /mnt/plots/driver$counter
			find . -name "*" -type f -size -101G | xargs -n 1 rm -f
			touch readme

			old_driver_num=$((old_driver_num+1))

		fi

		counter=$((counter+1))
      fi
   fi
done

