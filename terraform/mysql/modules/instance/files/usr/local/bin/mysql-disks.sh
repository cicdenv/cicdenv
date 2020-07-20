#!/bin/bash

set -eux -o pipefail

#
# Configure primary MySQL server instance store disks
#
# The base AMI handles PCI-e NVMe instance stores automatically
#
mkdir -p /mnt/ephemeral/mysql-primary
mkdir -p /mnt/mysql-primary

# Bind mount /mnt/mysql-primary => /mnt/ephemeral (raid0'd instance stores)
if ! findmnt -rno TARGET '/mnt/mysql-primary'; then
    mount -o bind '/mnt/ephemeral/mysql-primary' '/mnt/mysql-primary'
fi

#
# Configure replica MySQL server EBS disks
#
# The base AMI handles symlinking the launch template block device name
# to EBS NVMe device name
#
mkdir -p /mnt/mysql-replica

# Format and Mount EBS devices
devices='/dev/xvdf'
for device in $devices; do
    if ! blkid "$device" | grep 'TYPE="ext4"'; then
        mkfs.ext4 -E nodiscard "$device" -L 'replica'
    fi
    if ! mount | grep '/mnt/mysql-replica'; then
        mount -t ext4 -o noatime,nobarrier,discard "$device" '/mnt/mysql-replica'
    fi
done

# Populate sub directories
mkdir -p /mnt/mysql-{primary,replica}/{conf,data,sql}