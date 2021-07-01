


#install flax
mkdir -p /opt/flax
mkdir -p /opt/flax/logs

cd /opt/flax

if [ -d "/opt/flax/flax-blockchain" ]; then
  ### Take action if $DIR exists ###
  echo "****** Update flax ******"
else
  ###  Control will jump here if $DIR does NOT exists ###
  echo "****** Install flax ******"
  git config --global http.proxy http://miner:xyz123456@access.futsystems.com:8888
  git clone https://github.com/Flax-Network/flax-blockchain.git
  cd /opt/flax/flax-blockchain
  sh install.sh
  git config --global --unset http.proxy
  echo "****** Init flax ******"
  . ./activate
  flax init
fi

