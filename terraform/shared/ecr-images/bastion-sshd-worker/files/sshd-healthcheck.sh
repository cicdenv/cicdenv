#!/bin/bash

set -eu -o pipefail

function _sts_creds()
{
    sts_creds=$(aws sts assume-role --role-arn "${IAM_ROLE}" --role-session-name=bastion-service-$(hostname))

    mkdir -p "/root/.aws"
    cat <<EOFF > "/root/.aws/credentials"
[default]
aws_access_key_id     = $(echo "$sts_creds" | jq -r '.Credentials.AccessKeyId')
aws_secret_access_key = $(echo "$sts_creds" | jq -r '.Credentials.SecretAccessKey')
aws_session_token     = $(echo "$sts_creds" | jq -r '.Credentials.SessionToken')
expiration            = $(echo "$sts_creds" | jq -r '.Credentials.Expiration')
EOFF
}

while true; do 
    _sts_creds
    sleep 55m
done &

/usr/sbin/sshd -D
