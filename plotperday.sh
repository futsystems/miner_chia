#!/bin/bash

grep -i "total time" /opt/chia/logs/*.log |awk '{sum=sum+$4} {avg=sum/NR} {tday=86400/avg*8*101.366/1024} END {printf "%d K32 plots, avg %0.1f seconds, %0.2f TiB/day \n", NR, avg, tday}'
