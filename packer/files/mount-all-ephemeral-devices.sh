#!/bin/bash

set -eu -o pipefail

mount_dir=${1-/mnt/ephemeral}
mkdir -p "$mount_dir"

#
# Configures NVMe instance stores as one raid0 multi-device volume.
#

# NOTE: list-ephemeral-devices.sh to be installed to the same directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Determine NVMe devices
# Detect Single / Multiple disks
device_list=($("${DIR}/list-ephemeral-devices.sh"))
device_count=${#device_list[@]}

# Single disk device: no raid0 required
if [ "$device_count" == 1 ]; then
    device=${device_list[0]}

    if ! blkid "$device" | grep 'TYPE="ext4"'; then
        mkfs.ext4 -E nodiscard "$device"
    fi

    if ! mount | grep "$mount_dir"; then
        mount -t ext4 -o noatime,nobarrier,discard "$device" "$mount_dir"
    fi
elif (( device_count > 1 )); then # raid0 required to utlize multiple disk devices
    raid0_device=/dev/md0

    if ! cat /proc/mdstat | grep "${raid0_device#/dev/*}"; then
        echo 'y' | mdadm --create --verbose "$raid0_device" --level=0 --raid-devices=${device_count} ${device_list[*]}
        mdadm --wait "$raid0_device" || true

        mkfs.ext4 -E nodiscard -F "$raid0_device"
    fi

    if ! mount | grep "$mount_dir"; then
        mount -t ext4 -o noatime,nobarrier,discard "$raid0_device" "$mount_dir"
    fi
fi
