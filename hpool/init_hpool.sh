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
last_add_index=9999
while [[ $hpidx -le $idxmax ]]
do
   echo '------ Int srv.hpool'$hpidx' ------'

   hpool_d=/opt/hpool/$hpidx
   if [ ! -d  "$hpool_d" ];then
      echo 'create hpool dir,and genereate hpool config'
      mkdir -p /opt/hpool/$hpidx   
      cd /opt/hpool/$hpidx
      url1='http://'$serverid'.harvester.marvelsystem.net:8080/config/hpool?size=15&index='$hpidx
      wget "$url1" -O config.yaml

      last_add_index=$hpidx
   else
      echo 'hpool dir already exist'
   fi
   
   conf_target='/etc/supervisor/conf.d/hpool'$hpidx'.conf'
   add_supervisor=0
   if [ -f "$conf_target" ];then
      echo 'superviosr:hpool'$hpidx' exist'
   else
      add_supervisor=1
   fi

   if [ $add_supervisor -eq 1 ];then
      echo 'add service srv.hpool'$hpidx
      url2='http://'$serverid'.harvester.marvelsystem.net:8080/config/hpool/supervisor?index='$hpidx
      conf_target='/etc/supervisor/conf.d/hpool'$hpidx'.conf'
      #echo 'url to get supervisor config:'$url2' taget:'$conf_target
      wget "$url2" -O $conf_target

      supervisorctl reread
      supervisorctl add srv.hpool$hpidx
   fi
   hpidx=$((hpidx+1))

done

echo 'last_add_index:'$last_add_index

if [ $last_add_index -eq 9999 ];then
   echo 'have not add any new hpool group, just restart the last group'
   supervisorctl restart srv.hpool$idxmax
else
   echo 'last add group id:'$last_add_index
   if [ $last_add_index > 0 ];then
      old_group=$((last_add_index-1))	   
      echo 'restart old group service: srv.hpool'$old_group
      supervisorctl restart srv.hpool$old_group
   fi
fi



