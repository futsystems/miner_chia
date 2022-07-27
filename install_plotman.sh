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
	git config --global http.proxy http://miner:xyz123456@access.futsystems.com:8888
    #git clone https://github.com/ericaltendorf/plotman.git
    . /opt/chia/chia-blockchain/venv/bin/activate
    #cd /opt/chia/plotman
    #python setup.py install
	pip install --force-reinstall git+https://github.com/ericaltendorf/plotman@main
    git config --global --unset http.proxy
	# install supervisor conf
	ln -f -s /opt/src/supervisor/plot.conf /etc/supervisor/conf.d/plot.conf 
  else
    echo "please install chia first"
  fi
fi


