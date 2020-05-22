#!/bin/bash

set -eu -o pipefail

AWS_PROFILE=admin-main

OrganizationalUnits="devops development staging production"

# Set current directory 2 levels up (terraform/iam)
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../.." >/dev/null

../../bin/cicdctl creds aws-mfa main

root_id=$(aws --profile=${AWS_PROFILE} organizations list-roots | jq -r '.Roots[].Id')

for ou in $OrganizationalUnits; do
    ou_id=$(\
        aws --profile=${AWS_PROFILE} organizations \
            list-organizational-units-for-parent \
            --parent-id "$root_id" \
            | jq -r ".OrganizationalUnits[] | select(.Name==\"$ou\") | .Id" \
    )
    if [[ -z "$ou_id" ]]; then
        aws --profile=${AWS_PROFILE} organizations \
            create-organizational-unit \
            --parent-id "$root_id" \
            --name "$ou"
    fi
done

popd >/dev/null
