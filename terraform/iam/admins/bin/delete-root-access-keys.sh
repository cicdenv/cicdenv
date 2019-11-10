#!/bin/bash

set -eu -o pipefail

AWS_PROFILE=admin-root

key_ids=$(aws --profile=${AWS_PROFILE} iam list-access-keys | jq -r '.AccessKeyMetadata[].AccessKeyId')
echo "Removing root keys:"
echo "$key_ids"

if [[ ! -z "$key_ids" ]]; then
	for key_id in $key_ids; do
        aws --profile=${AWS_PROFILE} iam delete-access-key --access-key-id "$key_id"
    done
fi
