#!/usr/bin/parallel --shebang-wrap /bin/bash

cicdctl packer build --root-fs "zfs" --ephemeral-fs "$1"
