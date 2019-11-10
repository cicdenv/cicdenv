#!/bin/bash

set -eu -o pipefail

# Set working directory to project root folder
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../../../.." >/dev/null

workspace=${1?Usage: $0 <workspace>}

# NOTE: this won't work inside the cicdenv container
if [[ -f /proc/self/cgroup ]] && [[ "$(head -n1 /proc/self/cgroup | awk -F/ '{print $NF}' | wc -c)" == "65" ]]; then
    echo "Sorry Atari: this needs to be run on your host machine directly (not from the cicdenv container)." >&2

    exit 1
fi

url=$(bin/cicdctl creds console-url "$workspace")

if [[ "$OSTYPE" == "darwin"* ]]; then
    open -n -a "Google Chrome" "$url"
else  # Linux
    google-chrome "$url"
fi

popd >/dev/null
