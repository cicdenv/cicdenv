#!/bin/bash

set -eu -o pipefail

workspace=${1?Usage: $0 <workspace>}

# Set working directory to terraform/kops/backend/irsa
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
mkdir -p "$DIR/../pki/${workspace}"
pushd "$DIR/../pki/${workspace}" >/dev/null

../../../../../bin/cicdctl creds aws-mfa main

AWS_PROFILE="admin-${workspace}"
AWS_OPTS="--profile=${AWS_PROFILE} --region=us-west-2"

# CA certificate
aws $AWS_OPTS                        \
    secretsmanager get-secret-value  \
    --secret-id 'kops-CA'            \
    --version-stage 'AWSCURRENT'     \
    --query  'SecretString'          \
    | jq -r 'fromjson | ."cert"'     \
    | base64 -d > 'ca.pem'

# CA private key
aws $AWS_OPTS                        \
    secretsmanager get-secret-value  \
    --secret-id 'kops-CA'            \
    --version-stage 'AWSCURRENT'     \
    --query  'SecretString'          \
    | jq -r 'fromjson | ."key"'      \
    | base64 -d > 'ca-key.pem'

popd >/dev/null
