#!/bin/bash

set -eux -o pipefail

export DEBIAN_FRONTEND=noninteractive

# Update apt and install required packages
apt-get update
apt-get install -y \
	gdisk \
	zfsutils-linux \
	debootstrap \
	nvme-cli

# NVMe EBS launch device mappings (symlinks): /dev/nvme*n* to /dev/xvd*
declare -A blkdev_mappings
for blkdev in $(nvme list | awk '/^\/dev/ { print $1 }'); do  # /dev/nvme*n*
    # Mapping info from disk headers
    header=$(nvme id-ctrl --raw-binary "${blkdev}" | cut -c3073-3104 | tr -s ' ' | sed 's/ $//g' | sed 's!/dev/!!')
    mapping="/dev/${header%%[0-9]}"  # normalize sda1 => sda

    # Create /dev/xvd* device symlink
    if [[ ! -z "$mapping" ]] && [[ -b "${blkdev}" ]] && [[ ! -L "${mapping}" ]]; then
        ln -s "$blkdev" "$mapping"
        
        blkdev_mappings["$blkdev"]="$mapping"
    fi
done

# Partition the new root EBS volume
sgdisk -Zg -n1:0:4095 -t1:EF02 -c1:GRUB -n2:0:0 -t2:BF01 -c2:ZFS /dev/xvdf

# NVMe EBS launch device partition mappings (symlinks): /dev/nvme*n*p* to /dev/xvd*[0-9]+
declare -A partdev_mappings
for blkdev in "${!blkdev_mappings[@]}"; do  # /dev/nvme*n*
    mapping="${blkdev_mappings[$blkdev]}"

    # Create /dev/xvd*[0-9]+ partition device symlink
    for partdev in "${blkdev}"p*; do
    	partnum=${partdev##*p}
        if [[ ! -L "${mapping}${partnum}" ]]; then
            ln -s "${blkdev}p${partnum}" "${mapping}${partnum}"

            partdev_mappings["${blkdev}p${partnum}"]="${mapping}${partnum}"
        fi
    done
done

# Create zpool and filesystems on the new EBS volume
zpool create \
	-o altroot=/ami \
	-o ashift=12 \
	-o cachefile=/etc/zfs/zpool.cache \
	-O canmount=off \
	-O compression=lz4 \
	-O atime=off \
	-O normalization=formD \
	-m none \
	rpool \
	/dev/xvdf2

# Root file system
zfs create \
	-o canmount=off \
	-o mountpoint=none \
	rpool/ROOT

zfs create \
	-o canmount=noauto \
	-o mountpoint=/ \
	rpool/ROOT/ubuntu

zfs mount rpool/ROOT/ubuntu

# /home
zfs create \
	-o setuid=off \
	-o mountpoint=/home \
	rpool/home

zfs create \
	-o mountpoint=/root \
	rpool/home/root

# /var
zfs create \
	-o setuid=off \
	-o overlay=on \
	-o mountpoint=/var \
	rpool/var

zfs create \
	-o com.sun:auto-snapshot=false \
	-o mountpoint=/var/cache \
	rpool/var/cache

zfs create \
	-o com.sun:auto-snapshot=false \
	-o mountpoint=/var/tmp \
	rpool/var/tmp

zfs create \
	-o mountpoint=/var/spool \
	rpool/var/spool

zfs create \
	-o exec=on \
	-o mountpoint=/var/lib \
	rpool/var/lib

zfs create \
	-o mountpoint=/var/log \
	rpool/var/log

# Display ZFS output for debugging purposes
zpool status
zfs list

# Bootstrap Ubuntu into /ami
debootstrap --arch amd64 focal /ami
cp /tmp/sources.list /ami/etc/apt/sources.list

# Copy the zpool cache
mkdir -p /ami/etc/zfs
cp -p /etc/zfs/zpool.cache /ami/etc/zfs/zpool.cache

# Create mount points and mount the filesystem
mkdir -p /ami/{dev,proc,sys}
mount --rbind /dev /ami/dev
mount --rbind /proc /ami/proc
mount --rbind /sys /ami/sys

# Copy the compat. package list
cp /tmp/packages.txt /ami/tmp/packages.txt

# Copy the bootstrap script into place and execute inside chroot
cp /tmp/chroot-bootstrap.sh /ami/tmp/chroot-bootstrap.sh
chmod +x /ami/tmp/chroot-bootstrap.sh
chroot /ami /tmp/chroot-bootstrap.sh
rm -f /ami/tmp/chroot-bootstrap.sh

# Copy the ZFS-compatible growpart configuration for cloud-init into the chroot
mkdir -p /ami/etc/cloud/cloud.cfg.d
cp /tmp/growpart-root.cfg \
    /ami/etc/cloud/cloud.cfg.d/zfs-growpart-root.cfg

# Remove temporary sources list - CloudInit regenerates it
rm -f /ami/etc/apt/sources.list

# This could perhaps be replaced (more reliably) with an `lsof | grep -v /ami` loop,
# however in approximately 20 runs, the bind mounts have not failed to unmount.
sleep 10 

# Unmount bind mounts
umount -l /ami/dev
umount -l /ami/proc
umount -l /ami/sys

# Export the zpool
zpool export rpool

# Reset device mappings
for dev_link in "${blkdev_mappings[@]}" "${partdev_mappings[@]}"; do
    if [[ -L "$dev_link" ]]; then
        rm -f "$dev_link"
    fi
done 
