#!/bin/bash

set -eu -o pipefail

# Set working directory to project root
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../../../.." >/dev/null

# clusters full names: <cluster>-<workspace>.kops.<domain>
cluster_fqdns=$(cat terraform/kops/shared/data/*/clusters.txt)

# List <cluster>:<workspace> for all "realized kops clusters"
for cluster_fqdn in $cluster_fqdns; do
    echo "$cluster_fqdn" | awk -F. '{print $1}' | sed 's/\(.\+\)-\([^-]\+\)$/\1:\2/'
done
