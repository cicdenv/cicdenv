#!/bin/bash

set -eu -o pipefail

# Cross check this with `lsblk | grep -v loop`

# Pleebs can't run 'ebsnvme-id.py'
if [[ $EUID -ne 0 ]]; then
   >&2 echo  "WARNING: This script must be run as root, relaunching with sudo ..." 
   sudo "$0"; exit $?
fi

#
# NOTE: these instance families are not covered
#    x1
#    x1e
#    g2
#    f1
#    p3dn
#

# NOTE: expects dbsnvme-id.py to be installed to the same directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

devices=()

#
# Enumerate system NVMe devices
#
function sniff_nvme_devices {
    local devices=()  
    
    for device in /dev/nvme*n1; do
        if ! "${DIR}/ebsnvme-id.py" "$device" > /dev/null 2>&1; then
            devices+=(${device})
        fi
    done

    echo "${devices[*]}"
}

# Determine instance-store NVMe device list
instance_type=$(curl -s http://instance-data/latest/meta-data/instance-type) # 169.254.169.254
case "$instance_type" in
i2.xlarge)                                            devices+=(/dev/xvdc)             ;; # 1
i2.2xlarge)                                           devices+=(/dev/xvd[c-d])         ;; # 2
i2.4xlarge)                                           devices+=(/dev/xvd[c-f])         ;; # 4
i2.8xlarge)                                           devices+=(/dev/xvd[c-j])         ;; # 8
c3.large|c3.xlarge|c3.2xlarge|c3.4xlarge|c3.8xlarge)  devices+=(/dev/xvd[c-d])         ;; # 2 <- see unmount-ephemeral-devices.sh
m3.medium|m3.large)                                   devices+=(/dev/xvdb)             ;; # 1 <- see unmount-ephemeral-devices.sh
m3.xlarge|m3.2xlarge)                                 devices+=(/dev/xvd[b-c])         ;; # 2 <- see unmount-ephemeral-devices.sh
r3.large|r3.xlarge|r3.2xlarge|r3.4xlarge)             devices+=(/dev/xvdb)             ;; # 1
r3.8xlarge)                                           devices+=(/dev/xvd[b-c])         ;; # 2
*)                                                    devices+=($(sniff_nvme_devices)) ;;
esac

echo "${devices[*]}"
