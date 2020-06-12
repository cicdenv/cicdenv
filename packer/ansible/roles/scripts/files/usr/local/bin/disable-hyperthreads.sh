#!/bin/bash

set -eu -o pipefail

#
# Linux numbers hardware threads (vCPUs 0 - N-1)
#
# This assumes standard Xeon cores - 2 hyperthreads (hardware threads) per core.
#
# lscpu --extended
# CPU NODE SOCKET CORE L1d:L1i:L2:L3 ONLINE
# 0   0    0      0    0:0:0:0       yes
# 1   0    0      1    1:1:1:0       yes
# 2   0    0      2    2:2:2:0       yes
# 3   0    0      3    3:3:3:0       yes
# 4   0    0      0    0:0:0:0       yes
# 5   0    0      1    1:1:1:0       yes
# 6   0    0      2    2:2:2:0       yes
# 7   0    0      3    3:3:3:0       yes
#
hyper_threads=$(lscpu --extended | tail -n+2 | awk '{print $1}')
hardware_thread_count=$(echo "$hyper_threads" | wc -w)

# The first 1/2 are the primary hardware thread per core
nproc
lscpu --extended

# Disable hyperthreads if they are enabled
if [[ $(nproc) -gt $(($hardware_thread_count / 2 )) ]]; then
    sibling_mappings=$(cat /sys/devices/system/cpu/cpu[0-$(($hardware_thread_count / 2 -1))]/topology/thread_siblings_list)
    # For each "main" hardware thread, disable its sibling
    for sibling_num in $(echo "$sibling_mappings" | cut -d',' -f2); do
        # Stop the "sibling" hardware thread
        echo "Stopping vCPU ${sibling_num} ..." 1>&2
        echo 0 > "/sys/devices/system/cpu/cpu${sibling_num}/online"
    done
    nproc
    lscpu --extended
fi
