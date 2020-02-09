#!/bin/bash

set -eu -o pipefail

PATH="${PATH}:/usr/sbin"

for blkdev in $(nvme list | awk '/^\/dev/ { print $1 }'); do  # /dev/nvme*n*
    # Mapping info from disk headers
    mapping=$(nvme id-ctrl --raw-binary "${blkdev}" | cut -c3073-3104 | tr -s ' ' | sed 's/ $//g' | sed 's!/dev/!!')

    # Create /dev/xvd* device symlink
    if [[ ! -z "$mapping" ]] && [[ -b "${blkdev}" ]] && [[ ! -L "/dev/${mapping}" ]]; then
        ln -s "${blkdev}" "/dev/${mapping}"
    fi
done
