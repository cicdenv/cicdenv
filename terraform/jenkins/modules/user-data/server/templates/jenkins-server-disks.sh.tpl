#!/bin/bash

set -eux -o pipefail

pool_name="ephemeral"
ephemeral_dir="/mnt/$${pool_name}"
persistent_dir="/mnt/persistent"

#
# Ephemeral (fast storage) bind mounts.
#
# Example:
#   binds: [
#     /var/jenkins_workspace
#   ]
#   results:
#     /var/jenkins_workspace => /mnt/ephemral/jenkins_workspace
#
for bind_dir in                 \
"/var/jenkins_workspace"        \
"/var/jenkins_builds"           \
"/var/jenkins_home/userContent" \
"/var/jenkins_home/logs"        \
; do
    real_dir="$${ephemeral_dir}/$(basename $bind_dir)"

    # If we're using ZFS for the instance stores, create separate data sets
    if zpool list "$pool_name" &> /dev/null; then
        if ! zfs get "$${pool_name}/$(basename $bind_dir)" &> /dev/null; then
            zfs create "$${pool_name}/$(basename $bind_dir)"
        fi
    else  # Create a subfolder to mount under $ephemeral_dir using the last path element
        mkdir -p "$real_dir"
    fi

    if ! findmnt -rno TARGET "$bind_dir"; then
        mkdir -p "$bind_dir"

        chown -R jenkins:jenkins "$real_dir"
        chown -R jenkins:jenkins "$bind_dir"

        mount -o bind "$real_dir" "$bind_dir"
    fi
done

# mount the EFS persistent file system
mkdir -p "$persistent_dir"
chown jenkins:jenkins "$persistent_dir"
if ! findmnt -rno TARGET "$persistent_dir"; then
    mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 "${efs_dns_name}:/" "$persistent_dir"
fi

#
# Permenant (VERY slow storage) bind mounts.
#

# 
# Shared files
# Example:
#   binds: [
#     /var/jenkins_home/users
#   ]
#   results:
#     /var/jenkins_home/users => /mnt/persistent/users
#
for bind_dir in            \
"/var/jenkins_home/users"  \
; do
    # Create a subfolder to mount under $persistent_dir using the last path element
    real_dir="$${persistent_dir}/$(basename $bind_dir)"

    if ! findmnt -rno TARGET "$bind_dir"; then
        mkdir -p "$real_dir"
        mkdir -p "$bind_dir"

        chown -R jenkins:jenkins "$real_dir"
        chown -R jenkins:jenkins "$bind_dir"

        mount -o bind "$real_dir" "$bind_dir"
    fi
done

# 
# Unique files
# Example:
#   binds: [
#     /var/jenkins_home/jobs
#   ]
#   results:
#     /var/jenkins_home/jobs => /mnt/persistent/${jenkins_instance}/jobs
#
for bind_dir in            \
"/var/jenkins_home/jobs"   \
"/var/jenkins_home/nodes"  \
; do
    # Create a subfolder to mount under $persistent_dir using the last path element
    real_dir="$${persistent_dir}/${jenkins_instance}/$(basename $bind_dir)"

    if ! findmnt -rno TARGET "$bind_dir"; then
        mkdir -p "$real_dir"
        mkdir -p "$bind_dir"

        chown -R jenkins:jenkins "$real_dir"
        chown -R jenkins:jenkins "$bind_dir"

        mount -o bind "$real_dir" "$bind_dir"
    fi
done
