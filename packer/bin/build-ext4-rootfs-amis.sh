#!/usr/bin/parallel --shebang-wrap /bin/bash

cicdctl packer build --ephemeral-fs "$1"
