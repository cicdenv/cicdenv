#!/bin/bash

set -eu -o pipefail

mount_dir=/mnt/ephemeral

#
# Configures NVMe instance stores.
# This runs before docker/k8s are installed.
#

# Use script from our custom base AMI
/usr/local/bin/mount-all-ephemeral-devices.sh "$mount_dir"

#
# Bind mounts for docker+kubernetes
#
for target_dir in        \
    /var/lib/containerd  \
    /var/lib/docker      \
    /var/lib/kubelet     \
    ; do
    real_dir="$mount_dir/$(basename $target_dir)"

    if [[ ! -d "$target_dir" ]]; then
        mkdir -p "$real_dir"
        mkdir -p "$target_dir"

        mount -o bind "$real_dir" "$target_dir"
    fi
done
