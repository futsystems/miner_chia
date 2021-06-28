#!/bin/bash

mkdir -p /opt/monero

wget "http://127.0.0.1:8080/config/monero/supervisor" -O /etc/supervisor/conf.d/srv.monero
supervisorctl reread
supervisorctl add srv.monero
