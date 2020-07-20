#!/bin/bash

set -eu -o pipefail

# Set working directory to terraform/mysql/shared
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

../../../bin/cicdctl creds aws-mfa main

AWS_PROFILE=admin-main
AWS_OPTS="--profile=${AWS_PROFILE} --region=us-west-2"

aws $AWS_OPTS                        \
    secretsmanager put-secret-value  \
    --secret-id 'mysql'              \
    --secret-string "$(cat <<EOF
{
  "private-key": "$(base64 ./acme/mysql-key     | tr -d '\n')",
  "public-key":  "$(base64 ./acme/mysql-key.pub | tr -d '\n')"
}
EOF
)"

popd >/dev/null
