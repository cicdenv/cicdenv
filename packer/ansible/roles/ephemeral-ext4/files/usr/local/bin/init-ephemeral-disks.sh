#!/bin/bash

set -eu -o pipefail

mount_dir="/mnt/ephemeral"

mkdir -p "$mount_dir"

#
# Configures NVMe instance stores as one raid0 multi-device volume.
#

# Determine NVMe devices
# Detect Single / Multiple disks
device_list=($(nvme list | grep "Instance Storage" | awk '{ print $1 }'))
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

    # Don't ask :(
    if [[ -b /dev/md127 ]]; then
        mdadm --stop /dev/md127
    fi

    if ! cat /proc/mdstat | grep "${raid0_device#/dev/*}"; then
        echo 'y' | mdadm --create --verbose "$raid0_device" --level=0 --raid-devices=${device_count} ${device_list[*]}
        mdadm --wait "$raid0_device" || true

        mkfs.ext4 -E nodiscard -F "$raid0_device"
    fi

    if ! mount | grep "$mount_dir"; then
        mount -t ext4 -o noatime,nobarrier,discard "$raid0_device" "$mount_dir"
    fi
fi

#
# Bind mounts.
#
# Example:
#   binds: [
#     /var/lib/docker
#   ]
#   results:
#     /var/lib/docker => /mnt/ephemral/docker
#
for bind_spec in           \
    "/var/lib/containerd"  \
    "/var/lib/docker"      \
; do
    # Create a subfolder to mount under $mount_dir using the last path element
    bind_dir="$bind_spec"
    real_dir="$mount_dir/$(basename $bind_dir)"

    if [[ ! -d "$real_dir" ]]; then
        mkdir -p "$real_dir"
        mkdir -p "$bind_dir"

        mount -o bind "$real_dir" "$bind_dir"
    fi
done
