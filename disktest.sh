#! /bin/bash

if [ $# -eq 0 ]; then
    echo "No disk device provided"
    exit 1
fi

apt-get -y install fio

SEQIODEPTH=8
SEQIOSIZE=1m
SEQJOBS=10
RUNTIME=60
FILESIZE=10G

fio -filename=$1/test.img -size=$FILESIZE -direct=1 -iodepth=$SEQIODEPTH -thread -rw=read -ioengine=libaio -bs=$SEQIOSIZE -numjobs=$SEQJOBS -name="SSD Seq Read Test" -group_reporting -runtime=$RUNTIME

fio -filename=$1/test.img -size=$FILESIZE -direct=1 -iodepth=$SEQIODEPTH -thread -rw=write -ioengine=libaio -bs=$SEQIOSIZE -numjobs=$SEQJOBS -name="SD Seq Write Test" -group_reporting -runtime=$RUNTIME

rm -rf $1/test.img
