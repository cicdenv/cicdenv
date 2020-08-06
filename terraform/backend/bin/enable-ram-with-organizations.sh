#!/bin/bash

set -eu -o pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

../../bin/cicdctl creds aws-mfa main

# Source config
backend_config="../../terraform/backend-config.tfvars"
region=$(hclq -i "$backend_config" get --raw 'region')

AWS_PROFILE="admin-main"
AWS_OPTS="--profile=${AWS_PROFILE} --region=${region}"

aws $AWS_OPTS ram enable-sharing-with-aws-organization

popd >/dev/null
