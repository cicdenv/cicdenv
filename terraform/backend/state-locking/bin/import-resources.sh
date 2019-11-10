#!/bin/bash

set -eu -o pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

workspace=${1?Usage: $0 <workspace>}

../../../bin/cicdctl creds aws-mfa "$workspace"

# Source backend-config variables
backend_config="../../../terraform/backend-config.tfvars"
region=$(        hclq -i "$backend_config" get --raw 'region'        )
bucket=$(        hclq -i "$backend_config" get --raw 'bucket'        )
dynamodb_table=$(hclq -i "$backend_config" get --raw 'dynamodb_table')

export AWS_PROFILE="admin-${workspace}"

vars="-var region=${region} -var bucket=${bucket} -var dynamodb_table=${dynamodb_table}"

# Import DynamoDB lock table
if ! terraform state list | grep aws_dynamodb_table\.terraform_lock >/dev/null 2>&1; then
    terraform import $vars aws_dynamodb_table.terraform_lock "$dynamodb_table"
fi

popd >/dev/null
