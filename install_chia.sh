


#install chia
mkdir -p /opt/chia
mkdir -p /opt/chia/logs

cd /opt/chia

if [ -d "/opt/chia/chia-blockchain" ]; then
  ### Take action if $DIR exists ###
  echo "****** Update chia ******"
else
  ###  Control will jump here if $DIR does NOT exists ###
  echo "****** Install chia ******"
  git clone https://github.com/Chia-Network/chia-blockchain.git -b latest
  cd /opt/chia/chia-blockchain
  sh install.sh
  echo "****** Init chia ******"
  . ./activate
  chia init
fi

