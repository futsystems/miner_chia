#/bin/bash

#
echo "nvme io_poll (1=polling on),io_poll_delay(1 = always poll, 0 = hybrid mode)"

files=$(ls /dev/)
for device in $files
do
 #echo $device
 if [[ $device == nvme*n* ]]; then
	echo "======$device======"
    cmd1="/sys/block/$device/queue/io_poll"
    cmd2="/sys/block/$device/queue/io_poll_delay "
  	echo "$device" io_pool:$(cat $cmd1), io_poll_delay:$(cat $cmd2)
	echo $(lsblk | grep $device)
   nvme smart-log /dev/$device
  fi
done

