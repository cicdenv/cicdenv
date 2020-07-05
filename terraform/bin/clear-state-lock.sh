#!/bin/bash

set -eu -o pipefail

# Set working directory to the project root folder
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../.." >/dev/null

target=${1?Please specify a target (state:workspace).  Usage: $0 <state>:<workspace>}
workspace=${target#*:}
state=${target%:*}

AWS_PROFILE=admin-${workspace}
AWS_OPTS="--profile=${AWS_PROFILE} --region=us-west-2"

bin/cicdctl creds aws-mfa "$workspace"

backend_config="terraform/backend-config.tfvars"
state_bucket=$(  hclq -i "$backend_config" get --raw 'bucket'        )
dynamodb_table=$(hclq -i "$backend_config" get --raw 'dynamodb_table')

for item in terraform.tfstate terraform.tfstate-md5; do
    key=$(cat <<EOF
{
  "LockID": {
  	"S": "${state_bucket}/state/${workspace}/${state//\//_}/${item}"
  }
}
EOF
)
    aws $AWS_OPTS dynamodb delete-item --table-name "$dynamodb_table" --key "$key"
done
