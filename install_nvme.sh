#!/bin/bash

# loop nvme device format and mount
device_list=$(ls /dev/)
counter=0
echo "======Format Device======"
for device in $device_list
do
 if [[ $device == nvme*n* ]]; then
	echo '  - Found: '$device
    sleep 2s
    umount /dev/$device
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

echo "====Mout Nvme Disk===="
mount -a

echo "====Chnage Linux Kernel Args===="
# https://gist.github.com/trungnt13/d6632130c43db424d56f0d30247033ec enable scsi_mod.use_blk_mq
sed -i 's/\(^GRUB_CMDLINE_LINUX_DEFAULT=\).*/\1"quiet splash nomodeset scsi_mod.use_blk_mq=1"/' /etc/default/grub
update-grub2

#enable trim script
echo "====Enabel SSD Trim Cron Job===="
ln -f /opt/src/fstrim.sh /etc/cron.weekly/fstrim.sh




