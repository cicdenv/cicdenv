#!/bin/bash

set -eu -o pipefail

function _sts_creds()
{
    if [[ -f "/root/.aws/credentials" ]]; then
        rm "/root/.aws/credentials"
    fi

    sts_creds=$(aws sts assume-role --role-arn "${IAM_ROLE}" --role-session-name=bastion-$RANDOM)
     
    mkdir -p "/root/.aws"
    cat <<EOFF > "/root/.aws/credentials"
[default]
aws_access_key_id     = $(echo "$sts_creds" | jq -r '.Credentials.AccessKeyId')
aws_secret_access_key = $(echo "$sts_creds" | jq -r '.Credentials.SecretAccessKey')
aws_session_token     = $(echo "$sts_creds" | jq -r '.Credentials.SessionToken')
expiration            = $(echo "$sts_creds" | jq -r '.Credentials.Expiration')
EOFF
}

_sts_creds

/usr/sbin/sshd -D &

while true; do
    sleep 55m
    _sts_creds
done
