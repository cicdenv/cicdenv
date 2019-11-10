#!/bin/bash

set -eu -o pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

../../bin/cicdctl creds aws-mfa main

# Source backend-config variables
backend_config="../../terraform/backend-config.tfvars"
region=$(hclq -i "$backend_config" get --raw 'region'    )
bucket=$(hclq -i "$backend_config" get --raw 'bucket'    )
key_id=$(hclq -i "$backend_config" get --raw 'kms_key_id')

export AWS_PROFILE=${1-admin-main}
AWS_OPTS="--profile=${AWS_PROFILE} --region=${region}"

vars="-var region=${region} -var bucket=${bucket}"

# Import s3 bucket
if ! terraform state list | grep 'aws_s3_bucket.terraform_state' >/dev/null; then
    terraform import $vars aws_s3_bucket.terraform_state "$bucket"
fi

# Import KMS CMK
if ! terraform state list | grep 'aws_kms_key.terraform' >/dev/null; then
    key_id=$(aws $AWS_OPTS kms describe-key --key-id="$key_id" | jq -r '.KeyMetadata.Arn')
    kms_key_id=${key_id#*/}
    terraform import $vars aws_kms_key.terraform "$kms_key_id"
fi

popd >/dev/null
