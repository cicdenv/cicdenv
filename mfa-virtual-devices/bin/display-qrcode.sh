#!/bin/bash

set -eu -o pipefail

# Set working directory to mfa-virtual-devices
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

# NOTE: this won't work inside the cicdenv container
if [[ -f /proc/self/cgroup ]] && [[ "$(head -n1 /proc/self/cgroup | awk -F/ '{print $NF}' | wc -c)" == "65" ]]; then
    echo "Sorry Atari: this needs to be run on your host machine directly (not from the cicdenv container)." >&2

    exit 1
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    keybase decrypt --infile "${USER}-QRCode.png.gpg" | open -n -a "Google Chrome" --args "data:image/png;base64,$(base64 <&0)"
else  # Linux
    keybase decrypt --infile "${USER}-QRCode.png.gpg" | google-chrome "data:image/png;base64,$(base64 <&0)"
fi
