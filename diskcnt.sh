#!/bin/bash

cnt1=$(lsblk | grep sd | wc -l)
cnt2=$((cnt1-4))

echo "ext disk cnt:"$cnt2
