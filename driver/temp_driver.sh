#/bin/bash


echo "-----  Auto test disk -----"


device_list=$(ls /dev/)
counter=0


for device in $device_list
 do
   if [[ $device == sd* ]]; then
	    disksize=$(lsblk -b --output SIZE -n -d /dev/$device)
	  	disksizeT=`expr $disksize / 1000 / 1000 / 1000 / 1000`
		
      if [ $disksizeT -gt 5 ]; then
         echo "======Disk"$counter":$device======"
		 hddtemp /dev/$device    
		counter=$((counter+1))
      fi
   fi
done

