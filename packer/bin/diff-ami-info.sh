#!/bin/bash

set -eu -o pipefail

_PWD="$(pwd)"

# Set working directory to project top-level folder
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../.." >/dev/null

function usage () {
    cat <<EOF >&2
usage: $0 <ext4|zfs> [packer/ami-info/<file1>] [packer/ami-info/<file2>]
EOF
}

if [[ "$#" -lt 1 ]]; then  # file system type required
    usage
    exit 1
fi
fs_type=${1?usage}; shift

if [[ "$#" -gt 2 ]]; then  # Only [0-2] files to diff is supported
    usage
    exit 1
fi

_infos=("$@")  # Arguments if any
# Look up the last 1 or 2 info files by age if less than 2 arguments
if [[ "$#" -lt 2 ]]; then
    IFS=$'\n' read -r -d '' -a _latest \
        < <(find packer/ami-info/ -type f -name "*-${fs_type}-*.txt" -printf '%T+ %p\n' \
            | sort | tail -n $((2 - ${#_infos[@]})) | awk '{print $2}') || true
fi
diff_cmd=$(echo diff ${_infos[*]-} ${_latest[*]-})
diff_count=$(($($diff_cmd | grep -v '\-\-\-' | sed -e 's/^[^<>].*//' | sed -r '/^$/d' | wc -l) / 2))
echo $diff_cmd
echo "diff count: ${diff_count}"

# Output wihtout line numbers and groups removed
echo
$diff_cmd | grep -v '\-\-\-' | sed -e 's/^[^<>].*//'
