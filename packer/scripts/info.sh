#!/bin/bash

set -eu -o pipefail

#
# Distro Info
#
echo "-- /etc/os-release --"
cat /etc/os-release
echo

#
# Kernel
#
echo "-- kernel --"
uname -r
echo

#
# Python info
#
echo "-- system python --"
python --version
if [[ -x "/usr/bin/pip" ]]; then pip freeze; fi
echo

#
# AWS CLI
#
echo "-- aws cli --"
aws --version
echo

#
# Installed package names | versions
#
echo "-- packages --"
dpkg-query --show | awk '{printf "%-30s | %s\n", $1, $2}'
echo

#
# Kernel settings
#
echo "-- kernel modules --"
lsmod
echo "-- sysctl --"
sysctl -a 2>/dev/null | awk -F= '{printf "%-60s=%s\n", $1, $2}'
