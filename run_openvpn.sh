#!/bin/bash

apt-get update

apt-get -y install openvpn

cd /opt/src

openvpn --config vpn-client-miner.ovpn
