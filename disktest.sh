#! /bin/bash
  
SEQIODEPTH=8
SEQIOSIZE=1m
SEQJOBS=10
RUNTIME=60

fio -filename=/dev/nvme0n1 -direct=1 -iodepth=$SEQIODEPTH -thread -rw=read -ioengine=libaio -bs=$SEQIOSIZE -numjobs=$SEQJOBS -name="SSD Seq Read Test" -group_reporting -runtime=$RUNTIME

fio -filename=/dev/nvme0n1 -direct=1 -iodepth=$SEQIODEPTH -thread -rw=write -ioengine=libaio -bs=$SEQIOSIZE -numjobs=$SEQJOBS -name="SD Seq Write Test" -group_reporting -runtime=$RUNTIME

#fio -filename=/dev/md0 -direct=1 -iodepth=$SEQIODEPTH -thread -rw=read -ioengine=libaio -bs=$SEQIOSIZE -numjobs=$SEQJOBS -name="SSD Seq Read Test" -group_reporting -runtime=$RUNTIME

#fio -filename=/dev/md0 -direct=1 -iodepth=$SEQIODEPTH -thread -rw=write -ioengine=libaio -bs=$SEQIOSIZE -numjobs=$SEQJOBS -name="SD Seq Write Test" -group_reporting -runtime=$RUNTIME
