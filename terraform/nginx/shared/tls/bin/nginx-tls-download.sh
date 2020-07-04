#!/bin/bash

set -eu -o pipefail

workspace=${1?Usage: $0 <workspace>}

# Set working directory to terraform/nginx/shared/tls/keys<workspace>
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
mkdir -p "$DIR/../keys/${workspace}"
pushd "$DIR/../keys/${workspace}" >/dev/null

../../../../../../bin/cicdctl creds aws-mfa main

AWS_PROFILE="admin-${workspace}"
AWS_OPTS="--profile=${AWS_PROFILE} --region=us-west-2"

# TLS key
aws $AWS_OPTS                              \
    secretsmanager get-secret-value        \
    --secret-id 'nginx-tls'                \
    --version-stage 'AWSCURRENT'           \
    --query  'SecretString'                \
    | jq -r 'fromjson | .["private-key"]'  \
    | base64 -d > 'key.pem'

popd >/dev/null
