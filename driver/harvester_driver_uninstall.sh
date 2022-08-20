#/bin/bash

echo '----- 1. kill all nc process -----'
/usr/bin/killall -9 nc

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

echo 'there are '$old_driver_num' drivers, hpgroup:'$group
idxmax=$((group-1))
hpidx=0
while [[ $hpidx -le $idxmax ]]
do
  supervisorctl stop srv.hpool$hpidx
  supervisorctl remove srv.hpool$hpidx
   hpidx=$((hpidx+1))
done

echo '----- 3. umount old mount pints -----'
for path in $path_list
do
 mount_point='/mnt/plots/'$path
 umount $mount_point
done


echo '----- 4. remove hpool supervisor config -----'
rm -rf /etc/supervisor/conf.d/hpool*


echo '----- 5. remove mount points-----'
rm -rf /mnt/plots
