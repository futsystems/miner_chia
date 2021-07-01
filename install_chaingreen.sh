


#install flax
mkdir -p /opt/chaingreen
mkdir -p /opt/chaingreen/logs

cd /opt/chaingreen

if [ -d "/opt/chaingreen/chaingreen-blockchain" ]; then
  ### Take action if $DIR exists ###
  echo "****** Update chaingreen ******"
else
  ###  Control will jump here if $DIR does NOT exists ###
  echo "****** Install chaingreen ******"
  git config --global http.proxy http://miner:xyz123456@access.futsystems.com:8888
  git clone https://github.com/ChainGreenOrg/chaingreen-blockchain.git
  cd /opt/chaingreen/chaingreen-blockchain
  sh install.sh
  git config --global --unset http.proxy
  echo "****** Init chaingreen ******"
  . ./activate
  chaingreen init
fi

