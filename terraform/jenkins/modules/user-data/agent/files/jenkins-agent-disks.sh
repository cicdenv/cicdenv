#!/bin/bash

set -eux -o pipefail

mount_dir="/mnt/ephemeral"

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
for bind_dir in               \
"/var/lib/jenkins/jar-cache"  \
"/var/lib/jenkins/workspace"  \
"/var/lib/jenkins/cache"      \
"/var/lib/jenkins/logs"       \
; do
    # Create a subfolder to mount under $mount_dir using the last path element
    real_dir="$mount_dir/$(basename $bind_dir)"

    if ! findmnt -rno TARGET "$bind_dir"; then
        mkdir -p "$real_dir"
        mkdir -p "$bind_dir"

        chown -R jenkins:jenkins "$real_dir"
        chown -R jenkins:jenkins "$bind_dir"

        mount -o bind "$real_dir" "$bind_dir"
    fi
done
