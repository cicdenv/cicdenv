#!/bin/bash

set -eu -o pipefail

# Set working directory to terraform/kops/backend/irsa
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../irsa" >/dev/null

../../../../bin/cicdctl creds aws-mfa main

AWS_PROFILE=admin-main
AWS_OPTS="--profile=${AWS_PROFILE} --region=us-west-2"

aws $AWS_OPTS                                   \
    secretsmanager get-secret-value             \
    --secret-id 'kops-service-accounts'         \
    --version-stage 'AWSCURRENT'                \
    --query  'SecretString'                     \
    | jq -r 'fromjson | ."account-signing-key"' \
    | base64 -d

popd >/dev/null
