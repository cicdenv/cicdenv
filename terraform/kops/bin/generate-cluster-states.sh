#!/bin/bash

set -eu -o pipefail

# Set working directory to kops/
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

# Should be named after the kops version
#   example: 1-12-0-ga
cluster_name=${1?Usage $0 <cluster-short-name> [kube-version]}
kubernetes_version=${2-1.12.9}  # https://github.com/kubernetes/kubernetes/releases

#
# New state defaults
#
source "../bin/new-state-defaults.inc"

#
# Cluster Config state
#
source "bin/includes/cluster-config.inc"

#
# External Access state
#
source "bin/includes/external-access.inc"
