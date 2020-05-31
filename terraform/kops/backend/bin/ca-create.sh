#!/bin/bash

set -eu -o pipefail

# Set working directory to terraform/kops/backend/pki
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../pki" >/dev/null

if [[ ! -f ca.pem || -f ca-key.pem ]]; then
    cfssl gencert -initca -config=../conf/ca-config.json ../conf/ca-csr.json \
    | cfssljson -bare ca
    
    rm -f ca.csr
    rm -f ca-key.enc
fi

popd >/dev/null
