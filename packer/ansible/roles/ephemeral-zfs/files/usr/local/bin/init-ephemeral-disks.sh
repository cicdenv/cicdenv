#!/bin/bash

set -eu -o pipefail

mount_dir="/mnt/ephemeral"

mkdir -p "$mount_dir"

#
# Configures NVMe instance stores as one ZFS pool.
#

# Determine NVMe devices
device_list=($(nvme list | grep "Instance Storage" | awk '{ print $1 }'))

# Create ZFS pool from all devices
if ! zpool list ephemeral &> /dev/null; then
    zpool create -o ashift=12 \
        -O recordsize=4k -O compression=off -O checksum=off \
        ephemeral -m "$mount_dir" ${device_list[*]}
    zfs set atime=off ephemeral
fi
zpool list

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
