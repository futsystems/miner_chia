#!/bin/sh

if [ $# -eq 0 ]; then
	echo "please privider hpool index"
	exit 1
fi


hpidx=$1

tmp1=$((hpidx+1))

driveridx=`expr $hpidx \* 15`
driverend=`expr $tmp1 \* 15 - 1`


echo 'hpool idx:'$hpidx' driver start: '$driveridx' end: '$driverend



while [ $driveridx -le $driverend ]
do

	cd /mnt/plots/driver$driveridx
	find . -name "*" -type f -size -101G | xargs -n 1 rm -f
	
	fcnt=$(ls /mnt/plots/driver$driveridx -l | grep "^-" | wc -l)

	ss=$(df )

	
	echo '/mnt/plots/driver'$driveridx' plots cnt: '$fcnt

	driveridx=$((driveridx+1))

done


