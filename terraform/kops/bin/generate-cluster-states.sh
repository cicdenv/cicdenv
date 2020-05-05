#!/bin/bash

set -eu -o pipefail

# Set working directory to kops/
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

# Should be named after the kops version
#   example: 1-12-0-ga
cluster_name=${1?Usage $0 <cluster-short-name> [kube-version]}; shift

# Terraform variable bindings
declare -A tf_vars=(
	[kubernetes_version]=1.17.5
	[master_instance_type]=c5d.large
	[node_instance_type]=r5dn.xlarge
	[node_count]=-1
)
for binding in "$@"; do
    if [[ "$binding" != -* ]]; then
        var="${binding%%=*}"
        val="${binding#*=}"

        tf_vars["${var}"]="${val}"
    fi
done

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
