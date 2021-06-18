#!/bin/bash


hpidx=0
while [[ $hpidx -le $1 ]]
do
   echo 'restart srv.hpool'$hpidx	 
   supervisorctl restart srv.hpool$hpidx
   hpidx=$((hpidx+1))
done
