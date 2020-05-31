#!/bin/bash

set -eu -o pipefail

# Set working directory to terraform/kops/backend/pki
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../irsa" >/dev/null

../../../../bin/cicdctl creds aws-mfa main

AWS_PROFILE=admin-main
AWS_OPTS="--profile=${AWS_PROFILE} --region=us-west-2"

if [[ ! -f irsa-key ]]; then
    aws $AWS_OPTS                                      \
        kms decrypt                                    \
        --encryption-context "file=irsa-key,app=kops"  \
        --ciphertext-blob fileb://irsa-key.enc         \
        --output text --query Plaintext                \
        | base64 -d                                    \
        > irsa-key
fi

popd >/dev/null
