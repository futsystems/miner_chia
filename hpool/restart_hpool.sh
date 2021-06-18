#!/bin/bash


##############################################################
## calc driver count, and calc group number and restart them

cnt1=$(lsblk | grep sd | wc -l)
cnt2=$((cnt1-4))
#cnt2=30

group=$[cnt2/15]
flag2=$[cnt2%15]

if [[ $flag2 -ne 0 ]]; then
	group=$((group+1))
fi

echo 'disk cnt:'$cnt2' hpool driver group:'$group

idxmax=$((group-1))
hpidx=0
while [[ $hpidx -le $idxmax ]]
do
   echo 'restart srv.hpool'$hpidx	 
   supervisorctl restart srv.hpool$hpidx
   hpidx=$((hpidx+1))
   sleep $[ ( $RANDOM % 20 )  + 10 ]
done
