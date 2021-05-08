#!/bin/bash

# This Script: https://gist.github.com/justsml/6e1f69b3e3afa5a10455438dd7322e66

# Description: Automated setup of NVMe SSD disk(s) (supports a single drive or 2 in RAID0 or RAID1)
# Tested on Packet.net's MASSIVE Type3 Servers w/ Ububtu/Debian (check packet.net out, those guys are amazing)
# Author: Dan Levy github.com/justsml
# Credit/Original Ref: https://www.packet.net/help/kb/how-do-i-configure-an-nvme-flash-drive/



# OPTIONS
NVME_DEVICE_EXISTS="$(lsblk | grep 'nvme0' 2>/dev/null)"
NVME_ALREADY_SETUP="$(blkid 2>/dev/null | grep --count 'dev/nvme0n1')"

# All RAID_* vars are optional - 2 disks are required
RAID_LEVEL=${RAID_LEVEL-"1"}
RAID_DEVICE_NAME=${RAID_DEVICE_NAME-"md0"}
RAID_DEVICE_EXISTS=$(df | grep "/dev/$RAID_DEVICE_NAME")


function init_drivers () {
  printf '\n*** Init NVMe HDDs ***\n'
  if [ "$(lsblk | grep 'nvme0')" != "" ]; then
    echo '  - Found: nvme0'
    sleep 4s
    mkfs.xfs /dev/nvme0n1
    TARGET_MOUNT_DEVICE="/dev/nvme0n1"
    echo '  - Formeted:' $TARGET_MOUNT_DEVICE
    if ! grep -q 'inti-nvme0n1' /etc/fstab ; then
      rm -rf /mnt/cache/00
      mkdir -p /mnt/cache/00
      echo '#inti-nvme0n1' >> /etc/fstab
      echo '/dev/nvme0n1 /mnt/cache/00 xfs defaults,noatime,discard 0 0' >> /etc/fstab
    fi
  else
    echo '\n[NVMe disk 1 could be found]\n'
  fi
  if [ "$(lsblk | grep 'nvme1')" != "" ]; then
    echo '  - Found: nvme1'
    sleep 4s
    mkfs.xfs /dev/nvme1n1
    if ! grep -q 'inti-nvme1n1' /etc/fstab ; then
      rm -rf /mnt/cache/00
      mkdir -p /mnt/cache/00
      echo '#inti-nvme1n1' >> /etc/fstab
      echo '/dev/nvme1n1 /mnt/cache/01 xfs defaults,noatime,discard 0 0' >> /etc/fstab
    fi
  fi
  echo 'mount nvme to /mnt/cache'
  mount -a
  ### Disks initialized
}

function safety_first () {
  if [ "$UID" != "0" ]; then
    echo '*** ERROR: Must be root. Prefix command w/ sudo. Exiting...'
    exit -1
  else
    echo "[ Detected Required Permissions (root) ]"
  fi

  echo "$NVME_DEVICE_EXISTS"
  if [ "$(echo $NVME_DEVICE_EXISTS | egrep '^0')" != "" ]; then
    echo "INFO: No NVMe Devices Found"
    exit 0
  fi
  if [ $NVME_ALREADY_SETUP == 0 ]; then
      init_drivers
  else
    printf '\n*** Note: NVMe DRIVES ALREADY SETUP ***\n'
    exit 0
  fi
}

function mount_data () {
  mkdir -p $TARGET_MOUNT_PATH
  mount $TARGET_MOUNT_DEVICE $TARGET_MOUNT_PATH -t ext4
}

function add_to_startup () {  # NOT USED CURRENTLY
  mount | grep nvme >> /etc/fstab
}

safety_first
update-grub2

# https://gist.github.com/trungnt13/d6632130c43db424d56f0d30247033ec enable scsi_mod.use_blk_mq
sed -i 's/\(^GRUB_CMDLINE_LINUX_DEFAULT=\).*/\1"quiet splash nomodeset scsi_mod.use_blk_mq=1"/' grub
update-grub2

#enable trim script
ln /opt/src/fstrim.sh /etc/cron.weekly/fstrim.sh




