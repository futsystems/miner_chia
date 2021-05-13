#!/bin/bash

wget http://127.0.0.1:8080/config/plotman -O /root/.config/plotman/plotman.yaml

supervisorctl restart srv.plot
