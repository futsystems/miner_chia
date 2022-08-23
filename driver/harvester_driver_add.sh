#/bin/bash


echo '----- 2. stop all hpool process -----'

path_list=$(ls /mnt/plots)
old_driver_num=0
for path in $path_list
do
 old_driver_num=$((old_driver_num+1))
done

group=$[old_driver_num/15]
flag2=$[old_driver_num%15]

if [[ $flag2 -ne 0 ]]; then
        group=$((group+1))
fi

echo 'there are '$old_driver_num' drivers before'


for path in $path_list
do
 mount_point='/mnt/plots/'$path
 #echo 'mount point: '$mount_point
 #umount $mount_point
done


#list device
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
			cd /mnt/plots/driver$counter
			rm -rf readme
			touch readme
		else
			echo "======Disk"$counter":$device [X]======"
        		echo 'disk size:' $disksizeT
			# get disk information or format it as ext4
         	blkid TYPE=ext4 /dev/$device || mkfs.ext4 -m 0 -T largefile4 -L plotdisk /dev/$device

			#mount disk
			mkdir -p /mnt/plots/driver$counter
			#mount /dev/$device /mnt/plots/driver$counter
			echo 'mount /dev/'$device.' /mnt/plots/driver'$counter

			echo "clean bad plot files"
			cd /mnt/plots/driver$counter
			find . -name "*" -type f -size -101G | xargs -n 1 rm -f
			touch readme
		fi

		counter=$((counter+1))
      fi
   fi
done

