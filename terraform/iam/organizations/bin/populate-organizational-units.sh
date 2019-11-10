#!/bin/bash

set -eu -o pipefail

AWS_PROFILE=admin-main

# Set current directory 2 levels up (terraform/iam)
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../.." >/dev/null

../../bin/cicdctl creds aws-mfa main

root_id=$(aws --profile=${AWS_PROFILE} organizations list-roots | jq -r '.Roots[].Id')

accounts=$(\
    cd organizations; \
    AWS_PROFILE=${AWS_PROFILE} terraform output -json "account_names" \
    | jq -r '.[]' \
)
for account in $accounts; do
    account_id=$(\
        cd organizations; \
        AWS_PROFILE=${AWS_PROFILE} terraform output -json "account_ids_by_name" \
        | jq -r ".[\"${account}\"]" | xargs \
    )
    ou=$(\
        cd organizations; \
        AWS_PROFILE=${AWS_PROFILE} terraform output -json "account_ous_by_name" \
        | jq -r ".[\"${account}\"]" \
    )
    ou_id=$(\
        aws --profile=${AWS_PROFILE} organizations \
            list-organizational-units-for-parent \
            --parent-id "$root_id" \
            | jq -r ".OrganizationalUnits[] | select(.Name==\"$ou\") | .Id" \
    )
    present=$(\
        aws --profile=${AWS_PROFILE} organizations \
            list-accounts-for-parent \
            --parent-id "$ou_id" \
            | jq -r ".Accounts[] | select(.Name==\"$account\") | .Id" \
    )
    if [[ -z "$present" ]]; then
    	aws --profile=${AWS_PROFILE} organizations \
            move-account \
            --account-id "$account_id" \
            --source-parent-id "$root_id" \
            --destination-parent-id "$ou_id"
    fi
done

popd >/dev/null
