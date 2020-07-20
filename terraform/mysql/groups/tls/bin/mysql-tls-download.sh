#!/bin/bash

set -eu -o pipefail

target=${1?Please specify a target (group:workspace).  Usage: $0 <group>:<workspace>}
workspace=${target#*:}
group=${target%:*}

# Set working directory to terraform/mysql/groups/tls/keys/<workspace>
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
mkdir -p "$DIR/../keys/${group}/${workspace}"
pushd "$DIR/../keys/${group}/${workspace}" >/dev/null

../../../../../../../bin/cicdctl creds aws-mfa main

export AWS_PROFILE="admin-${workspace}"
AWS_OPTS="--profile=${AWS_PROFILE} --region=us-west-2"

# terraform/mysql/groups/${group}
pushd "$DIR/../../${group}" >/dev/null

# Target the correct workspace
terraform workspace list | grep "$workspace"   >/dev/null || terraform workspace new    "$workspace"
terraform workspace list | grep "* $workspace" >/dev/null || terraform workspace select "$workspace"

# Get secret full name
secret_id=$(terraform output -json 'secrets' | jq -r '.mysql_group_tls.name')

popd >/dev/null

# TLS keys
for key in client server; do
	# Give the lambda rotation time to complete the current version
	timeout 30 \
	bash -c "until [[ \"$(aws $AWS_OPTS                 \
                secretsmanager list-secret-version-ids  \
                --secret-id $secret_id                  \
            | jq -r '.Versions[] | select(.VersionStages[] | contains("AWSCURRENT")) | .VersionId')\" ]]; do
        sleep 1;
    done"
    
    aws $AWS_OPTS                                   \
        secretsmanager get-secret-value             \
        --secret-id "$secret_id"                  \
        --version-stage 'AWSCURRENT'                \
        --query  'SecretString'                     \
    | jq -r "fromjson | .[\"${key}-private-key\"]"  \
    | base64 -d > "${key}-key.pem"
done

popd >/dev/null
