#!/bin/bash

set -eu -o pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

../../bin/cicdctl creds aws-mfa main

# Source config
backend_config="../../terraform/backend-config.tfvars"
region=$(hclq -i "$backend_config" get --raw 'region'    )
bucket=$(hclq -i "$backend_config" get --raw 'bucket'    )
key_id=$(hclq -i "$backend_config" get --raw 'kms_key_id')

kms_alias="alias/terraform-state"

AWS_PROFILE="admin-main"
AWS_OPTS="--profile=${AWS_PROFILE} --region=${region}"

# Create s3 bucket
if ! aws $AWS_OPTS s3 ls "s3://${bucket}" &>/dev/null; then
    aws $AWS_OPTS s3 mb "s3://${bucket}"
fi

# Create the KMS CMK
if ! aws $AWS_OPTS kms describe-key --key-id="$key_id" &>/dev/null; then
    key_id=$(aws $AWS_OPTS kms create-key --description "Used for terraform state" | jq -r '.KeyMetadata.Arn')
    echo "key_id=${key_id}"

    aws $AWS_OPTS kms create-alias --alias-name "$kms_alias" --target-key-id "$key_id"
fi

popd >/dev/null
