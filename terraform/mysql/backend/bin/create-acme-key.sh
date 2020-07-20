#!/bin/bash

set -eu -o pipefail

# Set working directory to terraform/mysql/shared
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

KEY=acme/mysql-key
COMMENT="$(grep 'email_address' ../../acme.tfvars | cut -d= -f2 | awk '{$1=$1; print}')"

mkdir -p acme

if [[ ! -f "$KEY" ]]; then
    ssh-keygen -t rsa -b 2048 -f "$KEY" -m pem -q -N "" -C "$COMMENT" 0>&-
fi

popd >/dev/null
