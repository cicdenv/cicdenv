#!/bin/bash

# Unmount any mounted ephemeral devices first mounted by cloud-init
# This is needed for {c|m}3* instances, don't use them please

#
# NOTE: these instance families are not covered
#    x1
#    x1e
#    g2
#    f1
#    p3dn
#

instance_type=$(curl -s http://instance-data/latest/meta-data/instance-type) # 169.254.169.254
case "$instance_type" in
c3.*|r3.*)
    grep '/dev/xvdb.*/mnt.*,comment=cloudconfig.*' /etc/fstab && umount /mnt;
    sed -i '/\/dev\/xvdb.*\/mnt.*,comment=cloudconfig.*/d' /etc/fstab; 
    ;;
esac
