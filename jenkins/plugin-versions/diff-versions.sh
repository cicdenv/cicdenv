#!/bin/bash

set -eu -o pipefail

_PWD="$(pwd)"

# Set working directory to project top-level folder
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../.." >/dev/null

function usage () {
    cat <<EOF >&2
usage: $0 [jenkins/plugin-versions/<file1>] [jenkins/plugin-versions/<file2>]
EOF
}

if [[ "$#" -gt 2 ]]; then  # Only [0-2] files to diff is supported
    usage
    exit 1
fi

_versions=("$@")  # Arguments if any
# Look up the last 1 or 2 info files by age if less than 2 arguments
if [[ "$#" -lt 2 ]]; then
    IFS=$'\n' read -r -d '' -a _latest \
        < <(find jenkins/plugin-versions/ -type f -name '*.txt' -printf '%T+ %p\n' \
            | sort | tail -n $((2 - ${#_versions[@]})) | awk '{print $2}') || true
fi

diff_cmd=$(echo diff ${_versions[*]-} ${_latest[*]-})
echo $diff_cmd

diff_count=$(($($diff_cmd | grep -v '\-\-\-' | sed -e 's/^[^<>].*//' | sed -r '/^$/d' | wc -l) / 2)) || true
echo "diff count: ${diff_count}"

# Output wihtout line numbers and groups removed
echo
$diff_cmd | grep -v '\-\-\-' | sed -e 's/^[^<>].*//'
