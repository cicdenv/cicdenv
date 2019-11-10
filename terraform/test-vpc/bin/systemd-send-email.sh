#!/bin/bash

set -eu -o pipefail

# ExecStopPost=/usr/local/bin/systemd-email-alert.sh "%n" "systemd@sretest.io" "fred.vogt@gmail.com"
# SERVICE_RESULT=a EXIT_CODE=1 EXIT_STATUS=2 /usr/local/bin/systemd-email-alert.sh ssh "systemd@sretest.io" "fred.vogt@gmail.com"
usage="Usage: $0 <unit> <from-email> <to-email>"
unit=${1?Error: 'unit'       required.  $usage}
from=${2?Error: 'from-email' required.  $usage}
  to=${3?Error: 'to-email'   required.  $usage}

text=$(cat <<EOF
unit=${unit}
SERVICE_RESULT=$SERVICE_RESULT
EXIT_CODE=$EXIT_CODE
EXIT_STATUS=$EXIT_STATUS

Logs:
$(journalctl -u $unit -n 100)
EOF
)

region=$(curl -s http://instance-data/latest/dynamic/instance-identity/document | jq .region -r)

aws="/snap/bin/aws"

sts_creds=$("$aws" sts assume-role --role-arn "arn:aws:iam::014719181291:role/ses-sender" --role-session-name=$$)
export AWS_ACCESS_KEY_ID=$(    echo "$sts_creds" | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo "$sts_creds" | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(    echo "$sts_creds" | jq -r '.Credentials.SessionToken')

"$aws" --region=${region} \
  ses send-email \
  --from "$from" \
  --to "$to" \
  --subject "${unit} stopped on $(hostname)" \
  --text "$text"
