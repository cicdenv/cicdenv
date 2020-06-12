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
# 2   -    -      -    :::           no
# 3   -    -      -    :::           no
#
hyper_threads=$(lscpu --extended | tail -n+2 | awk '{print $1}')
hardware_thread_count=$(echo "$hyper_threads" | wc -w)

# The first 1/2 are the primary hardware thread per core
nproc
lscpu --extended

# Enable all hyperthreads if some are disabled
if [[ $(nproc) -lt "$hardware_thread_count" ]]; then
    # For each hyperthread
    for ht_num in $(seq $(("$hardware_thread_count" - 1))); do
        if [[ "0" == $(cat "/sys/devices/system/cpu/cpu${ht_num}/online") ]]; then
            # Start the disabled hardware thread
            echo "Starting vCPU ${ht_num} ..." 1>&2
            echo 1 > "/sys/devices/system/cpu/cpu${ht_num}/online"
        fi
    done
    nproc
    lscpu --extended
fi
