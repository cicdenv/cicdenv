#!/bin/bash

function ami_names () {
    echo zfs/ubuntu-20.04-amd64 \
         base/ubuntu-20.04-amd64-{ext4,zfs}-{none,ext4,zfs}
}

function ephemeral_filesystems () {
    echo {none,ext4,zfs}
}
