#!/bin/bash

set -eu -o pipefail

# Set working directory to terraform/kops/backend/pki
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../pki" >/dev/null

../../../../bin/cicdctl creds aws-mfa main

AWS_PROFILE=admin-main
AWS_OPTS="--profile=${AWS_PROFILE} --region=us-west-2"

if [[ ! -f ca.pem || -f ca-key.pem ]]; then
    cfssl gencert -initca -config=../conf/ca-config.json ../conf/ca-csr.json \
    | cfssljson -bare ca
    
    rm -f ca.csr
    rm -f ca-key.enc
fi
if [[ ! -f ca-key.enc || -s ca-key.enc ]]; then
    aws $AWS_OPTS                                        \
        kms encrypt                                      \
        --key-id 'alias/kops-state'                      \
        --encryption-context "file=ca-key.pem,app=kops"  \
        --plaintext 'fileb://ca-key.pem'                 \
        --output text                                    \
        --query CiphertextBlob                           \
        | base64 -d                                      \
        > ca-key.enc
fi

popd >/dev/null
