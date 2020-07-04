#!/bin/bash

set -eu -o pipefail

# Set working directory to terraform/nginx/shared
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

../../../bin/cicdctl creds aws-mfa main

AWS_PROFILE=admin-main
AWS_OPTS="--profile=${AWS_PROFILE} --region=us-west-2"

mkdir -p acme

declare -A secrets=(
    [private-key]=nginx-key
    [public-key]=nginx-key.pub
)
for item in "${!secrets[@]}"; do
    aws $AWS_OPTS                          \
        secretsmanager get-secret-value    \
        --secret-id 'nginx'                \
        --version-stage 'AWSCURRENT'       \
        --query  'SecretString'            \
        | jq -r "fromjson | .\"${item}\""  \
        | base64 -d                        \
        > "acme/${secrets[$item]}"
done

popd >/dev/null
