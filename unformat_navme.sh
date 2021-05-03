#!/bin/bash



dd if=/dev/zero of=/dev/nvme0n1  bs=512  count=1
dd if=/dev/zero of=/dev/nvme1n1  bs=512  count=1
#dd if=/dev/zero of=/dev/nvme2n1  bs=512  count=1



