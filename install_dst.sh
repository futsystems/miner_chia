#!/bin/bash

#reset disk
# dd if=/dev/zero of=/dev/sdb bs=1M



DISKFORMATED1="$(blkid 2>/dev/null | grep --count '/dev/sdb')"
DISKFORMATED2="$(blkid 2>/dev/null | grep --count '/dev/sdc')"


if [ $DISKFORMATED1 == 0 ]; then
  echo '  - Format:/dev/sdb'
  mkfs.ext4 -m 0 -T largefile4 -L plotdisk /dev/sdb
fi


if [ $DISKFORMATED2 == 0 ]; then
  echo '  - Formart:/dev/sdc'
  mkfs.ext4 -m 0 -T largefile4 -L plotdisk /dev/sdc
fi


if [ $(cat /proc/mounts 2>/dev/null | grep --count '/dev/sdb') == 0 ]; then
  echo '  - Mount:/dev/sdb'
  mkdir -p /mnt/dst/00
  mount /dev/sdb /mnt/dst/00
fi

if [ $(cat /proc/mounts 2>/dev/null | grep --count '/dev/sdc') == 0 ]; then
  echo '  - Mount:/dev/sdc'
  mkdir -p /mnt/dst/01
  mount /dev/sdc /mnt/dst/01
fi

