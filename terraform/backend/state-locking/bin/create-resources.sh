#!/bin/bash

set -eu -o pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

workspace=${1?Usage: $0 <workspace>}

../../../bin/cicdctl creds aws-mfa "$workspace"

AWS_PROFILE="admin-${workspace}"
AWS_OPTS="--profile=${AWS_PROFILE} --region=us-west-2"

# Create DynamoDB lock table if needed
tables=$(aws $AWS_OPTS dynamodb list-tables | jq -r '.TableNames[]')
if ! echo "$tables" | grep 'terraform-state-lock' >/dev/null 2>&1; then
    aws $AWS_OPTS                                                       \
        dynamodb create-table                                           \
        --table-name 'terraform-state-lock'                             \
        --attribute-definitions 'AttributeName=LockID,AttributeType=S'  \
        --key-schema 'AttributeName=LockID,KeyType=HASH'                \
        --billing-mode PAY_PER_REQUEST
fi

popd >/dev/null
