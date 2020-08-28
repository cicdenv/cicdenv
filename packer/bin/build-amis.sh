#!/bin/bash

set -eu -o pipefail

# Set working directory to packer/
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

source "bin/ami-names.inc"

# Bring up main account NAT gateways if needed
cicdctl terraform apply network/routing:main -auto-approve
cicdctl terraform apply network/routing/attachments:main -auto-approve

parallel --verbose --tagstring ext4-{} --linebuffer --joblog - cicdctl packer build --ephemeral-fs ::: $(ephemeral_filesystems)

cicdctl packer build --builder "ebssurrogate" --root-fs "zfs"
parallel --verbose --tagstring zfs-{} --linebuffer --joblog - cicdctl packer build --root-fs "zfs" --ephemeral-fs ::: $(ephemeral_filesystems)
