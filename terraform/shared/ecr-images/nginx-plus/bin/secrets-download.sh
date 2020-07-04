#!/bin/bash

set -eu -o pipefail

# Set working directory to terraform/shared/ecr-images/nginx-plus
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

../../../../bin/cicdctl creds aws-mfa main

AWS_PROFILE=admin-main
AWS_OPTS="--profile=${AWS_PROFILE} --region=us-west-2"

declare -A secrets=(
    [cert]=nginx-repo.crt
    [key]=nginx-repo.key
    [mdb]=geoipupdate.conf
)
for item in "${!secrets[@]}"; do
    aws $AWS_OPTS                          \
        secretsmanager get-secret-value    \
        --secret-id 'nginx-plus'           \
        --version-stage 'AWSCURRENT'       \
        --query  'SecretString'            \
        | jq -r "fromjson | .\"${item}\""  \
        | base64 -d                        \
        > "${secrets[$item]}"
done

popd >/dev/null
