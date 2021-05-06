#/bin/bash

mkdir -p /opt/chia
mkdir -p /opt/chia/logs

if [ -d "/opt/chia/plotman" ]; then
  ### Take action if $DIR exists ###
  echo "****** Update plotman ******"
else
  if [ -d "/opt/chia/chia-blockchain" ]; then
    ###  Control will jump here if $DIR does NOT exists ###
    echo "****** Install plotman ******"
    cd /opt/chia
    git clone https://github.com/ericaltendorf/plotman.git
    . /opt/chia/chia-blockchain/venv/bin/activate
    cd /opt/chia/plotman
    python setup.py install
    
	# install supervisor conf
	ln -s /opt/src/supervisor/plot.conf /etc/supervisor/conf.d/plot.conf 
  else
    echo "please install chia first"
  fi
fi



#update plotman config
plotman_config(){
while true
do
#clear
cat << EOF
----------------------------------------
|****Please Enter Your Choice:[0-9]****|
----------------------------------------
(0) Do not update config
(1) 1nvme 2sata
(2) Dell730xd(2nvme 1sata)
(3) Dell730xd(2nvme 2sata)
EOF
read -p "Please enter your Choice[0-9]: " input2
case "$input2" in
  0)
  clear
  break 
  ;;
  1)
  echo "1 nvme SDD with 2 sata HDD"
  mkdir -p /root/.config/plotman/
  mv /root/.config/plotman/plotman.yaml root/.config/plotman/plotman.yaml.bak
  cp /opt/src/plotman/plotman.yaml.1nvme.2sata /root/.config/plotman/plotman.yaml
  break
  ;;
  2)
  echo "Config Dell730xd 2nvme 1sata"
  mkdir -p /root/.config/plotman/
  mv /root/.config/plotman/plotman.yaml root/.config/plotman/plotman.yaml.bak
  cp /opt/src/plotman/plotman.yaml.dell730xd.2nvme.1sata /root/.config/plotman/plotman.yaml
  break
  ;;
  3)
  echo "Config Dell730xd 2nvme 2sata"
  mkdir -p /root/.config/plotman/
  mv /root/.config/plotman/plotman.yaml root/.config/plotman/plotman.yaml.bak
  cp /opt/src/plotman/plotman.yaml.dell730xd.2nvme.2sata /root/.config/plotman/plotman.yaml
  break
  ;;
  2)
  echo "2 nvme SDD with 4 sata HDD"
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

plotman_config