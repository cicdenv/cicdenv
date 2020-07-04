#!/bin/bash

set -eu -o pipefail

# Set working directory to terraform/shared/ecr-images/nginx-plus
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

../../../../bin/cicdctl creds aws-mfa main

AWS_PROFILE=admin-main
AWS_OPTS="--profile=${AWS_PROFILE} --region=us-west-2"

aws $AWS_OPTS                        \
    secretsmanager put-secret-value  \
    --secret-id 'nginx-plus'         \
    --secret-string "$(cat <<EOF
{
  "cert": "$(base64 ./nginx-repo.crt   | tr -d '\n')",
  "key":  "$(base64 ./nginx-repo.key   | tr -d '\n')",
  "mdb":  "$(base64 ./geoipupdate.conf | tr -d '\n')"
}
EOF
)"

popd >/dev/null
