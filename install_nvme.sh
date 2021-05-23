#!/bin/bash

# loop nvme device format and mount
device_list=$(ls /dev/)
total_nvme_cnt=0
for device in $device_list
do
 if [[ $device == nvme*n* ]]; then
    total_nvme_cnt=$((total_nvme_cnt+1))
 fi
done

echo "======Found "$total_nvme_cnt" nvme devices======"

clear_nvme()
{
	if grep -q 'init-md' /etc/fstab ; then
		sed -i '/md/d' /etc/fstab
		sed -i '/md/d' /etc/mdadm/mdadm.conf 
		for device in $device_list
		do
 			if [[ $device == md* ]]; then
				umount /dev/$device
				mdadm -S /dev/$device
			fi
		done

		for device in $device_list
		do
 			if [[ $device == nvme*n* ]]; then
				mdadm --zero-superblock /dev/$device
  			fi
		done
		# clean mdadm config
		cat /dev/null > /etc/mdadm/mdadm.conf
	fi

	if grep -q 'init-nvme' /etc/fstab ; then
		sed -i '/nvme/d' /etc/fstab
		for device in $device_list
		do
 			if [[ $device == nvme*n* ]]; then
				umount /dev/$device
  			fi
		done
	fi
}

ssd_alone(){
	clear_nvme
	counter=0
	echo "======Format Device======"
	for device in $device_list
	do
 		if [[ $device == nvme*n* ]]; then
			echo '  - Found: '$device
    			sleep 1s
    			mkfs.xfs /dev/$device -f
    			if ! grep -q 'init-'$device /etc/fstab ; then
      			rm -rf /mnt/cache/0$counter
      			mkdir -p /mnt/cache/0$counter
      			echo '#init-'$device >> /etc/fstab
      			echo '/dev/'$device' /mnt/cache/0'$counter' xfs defaults,noatime,discard 0 0' >> /etc/fstab
    			fi
    			counter=$((counter+1))
  		fi
	done
}

ssd_raid(){
	clear_nvme
	echo "======Format Device======"
	index=$(($total_nvme_cnt-1))
	mdadm -C /dev/md0 /dev/nvme[0-$index]n1 -n 2 -l 0 -c 64
	sleep 1s
	mkfs.xfs /dev/md0 -f
	if ! grep -q 'init-md0' /etc/fstab ; then
      			rm -rf /mnt/cache/00
      			mkdir -p /mnt/cache/00
      			echo '#init-md0' >> /etc/fstab
				echo '/dev/md0 /mnt/cache/00 xfs defaults,noatime,discard 0 0' >> /etc/fstab
    	fi
	mdadm -Ds >> /etc/mdadm/mdadm.conf

}


multiple_ssd(){
while true
do
#clear
cat << EOF
----------------------------------------
|****Please Enter Your Choice:[0-9]****|
----------------------------------------
(0) use nvmes as raid0
(1) use nvmes as alone
EOF
read -p "Please enter your Choice[0-9]: " input2
case "$input2" in
  0)
  echo "use nvme SDD as radi0"
  ssd_raid
  break 
  ;;
  1)
  echo "use nvme SDD as alone"
  ssd_alone
  break
  ;;
  2)
  echo "Config Dell730xd 2nvme 1sata"
  mkdir -p /root/.config/plotman/
  #mv /root/.config/plotman/plotman.yaml /root/.config/plotman/plotman.yaml.bak
  cp /opt/src/plotman/plotman.yaml.dell730xd.2nvme.1sata /root/.config/plotman/plotman.yaml
  break
  ;;
  *) echo "----------------------------------"
     echo "|          Warning!!!            |"
     echo "|   Please Enter Right Choice!   |"
     echo "----------------------------------"
     for i in `seq -w 3 -1 1`
       do 
         echo -ne "\b\b$i";
  sleep 1;
     done
     clear
esac
done
}

if [[ $total_nvme_cnt > 1 ]]; then
	multiple_ssd
fi

update-initramfs -u



echo "====Mout Nvme Disk===="
mount -a


echo "====Chnage Linux Kernel Args===="
# https://gist.github.com/trungnt13/d6632130c43db424d56f0d30247033ec enable scsi_mod.use_blk_mq
sed -i 's/\(^GRUB_CMDLINE_LINUX_DEFAULT=\).*/\1"quiet splash nomodeset scsi_mod.use_blk_mq=1"/' /etc/default/grub
update-grub2

#enable trim script
echo "====Enabel SSD Trim Cron Job===="
ln -f /opt/src/fstrim.sh /etc/cron.weekly/fstrim.sh




