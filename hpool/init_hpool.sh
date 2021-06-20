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

# Set space as the delimiter
IFS='-'

#Read the split words into an array based on space delimiter
read -a strarr <<< "$HOSTNAME"
echo 'harvester server id:'${strarr[1]}
serverid=${strarr[1]}

echo 'disk cnt:'$cnt2' hpool driver group:'$group

idxmax=$((group-1))
hpidx=0
while [[ $hpidx -le $idxmax ]]
do
   echo '------ Int srv.hpool'$hpidx' ------'
   url1='http://'$serverid'.harvester.marvelsystem.net:8080/config/hpool?size=15&index='$hpidx
   hpool_d=/opt/hpool/$hpidx
   if [ ! -d  "$hpool_d" ];then
      echo 'create hpool dir,and genereate hpool config'
      mkdir -p /opt/hpool/$hpidx   
      cd /opt/hpool/$hpidx
      wget "$url1" -O config.yaml
   else
      echo 'hpool dir already exist'
      cd /opt/hpool/$hpidx
      wget "$url1" -O config.yaml
   fi
   
   conf_target='/etc/supervisor/conf.d/hpool'$hpidx'.conf'
   url2='http://'$serverid'.harvester.marvelsystem.net:8080/config/hpool/supervisor?index='$hpidx
   if [ ! -f "$conf_target" ];then
      echo 'add supervisor srv.hpool'$hpidx
      wget "$url2" -O $conf_target
      supervisorctl reread
      supervisorctl add srv.hpool$hpidx
   else
      echo 'superviosr:hpool'$hpidx' exist'	   
      wget "$url2" -O $conf_target
      supervisorctl restart srv.hpool$hpidx 
   fi
   hpidx=$((hpidx+1))
done

