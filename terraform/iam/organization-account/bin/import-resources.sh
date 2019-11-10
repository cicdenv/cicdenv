#!/bin/bash

set -eu -o pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

workspace=${1?Usage: $0 <workspace>}

../../../bin/cicdctl creds aws-mfa "$workspace"

# Source backend-config variables
backend_config="../../../terraform/backend-config.tfvars"
region=$(hclq -i "$backend_config" get --raw 'region')
bucket=$(hclq -i "$backend_config" get --raw 'bucket')

export AWS_PROFILE="admin-${workspace}"

vars="-var region=${region} -var bucket=${bucket}"

# Import Role
if ! terraform state list | grep aws_iam_role\.assumed_admin >/dev/null 2>&1; then
    terraform import $vars aws_iam_role.assumed_admin "${workspace}-admin"
fi

# Import Inline Policy
if ! terraform state list | grep aws_iam_role_policy\.assumed_admin_inline_policy >/dev/null 2>&1; then
    terraform import $vars aws_iam_role_policy.assumed_admin_inline_policy "${workspace}-admin:AdministratorAccess"
fi

popd >/dev/null
