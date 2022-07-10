#!/bin/bash


echo "stop srv.plot"
supervisorctl stop srv.plot

echo "kill plotman process"
/usr/bin/killall -9 plotman

echo "kill all chia process"
/usr/bin/killall -9 chia

echo "clean cache file"
rm -rf /mnt/cache/00/*.tmp



