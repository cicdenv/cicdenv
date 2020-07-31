#!/bin/bash

set -eu -o pipefail

# Set working directory to packer/
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

source "bin/ami-names.inc"

# Bring up main account NAT gateways if needed
cicdenv$ cicdctl terraform apply network/routing:main -auto-approve

bin/build-ext4-rootfs-amis.sh $(ephemeral_filesystems)

cicdctl packer build --builder "ebssurrogate" --root-fs "zfs"
bin/build-zfs-rootfs-amis.sh $(ephemeral_filesystems)
