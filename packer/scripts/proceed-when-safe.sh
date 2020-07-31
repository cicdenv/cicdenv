#!/bin/bash

set -eu -o pipefail

#
# Waits for cloud-init and initial apt updates to complete.
#

#
# Wait for cloudinit to complete before continuing
#
while [[ ! -f /var/lib/cloud/instance/boot-finished ]]; do
    echo 'Waiting for cloud-init...'
    sleep 1
done

#
# Wait for the dpkg/apt lock(s) to be available for at least 15 secs.
#
# /etc/systemd/system/apt-daily.timer.d/apt-daily.timer.conf
#   [Timer]
#   Persistent=false
# 
quiet_period=15  # seconds
countdown="$quiet_period"
while [[ "$countdown" -gt 0 ]]; do
    echo "apt/dpkg lock - quiet period countdown: ${countdown} ..."
    for lock_file in                    \
        /var/lib/dpkg/lock              \
        /var/lib/dpkg/lock-frontend     \
        /var/lib/apt/lists/lock         \
        /var/cache/apt/archives/lock; do
        # echo "Checking lock: ${lock_file} ..."
        if [[ $(fuser "$lock_file") ]]; then
            echo "Waiting for lock: ${lock_file} ..."
            countdown="$quiet_period"  # Reset quiet period countdown
        fi
    done
    sleep 1
    countdown=$(($countdown - 1))
done
