#!/bin/bash

set -eu -o pipefail

#
# Fixed CoreDNS on nodes.
#   Needed on ubuntu 18.04
#

# Stop systemd-resolved
if systemctl is-active --quiet systemd-resolved; then
    systemctl disable systemd-resolved
    systemctl stop systemd-resolved
fi

# Link /etc/resolv.conf to /run/systemd/resolve/resolv.conf
if [[ "$(readlink -- /etc/resolv.conf)" == "../run/systemd/resolve/stub-resolv.conf" ]]; then
    rm -f "/etc/resolv.conf"
    ln -s "/run/systemd/resolve/resolv.conf" "/etc/resolv.conf"
fi
