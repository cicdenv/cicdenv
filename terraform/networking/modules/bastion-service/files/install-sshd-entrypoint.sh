#!/bin/bash

set -eu -o pipefail

mkdir -p /opt/sshd-service

ssh_entrypoint=/opt/sshd-service/sshd-entrypoint.sh

cat << 'EOF' > "$ssh_entrypoint"
#!/bin/bash

set -eu -o pipefail

sts_creds=$(aws sts assume-role --role-arn "{{assume_role_arn}}" --role-session-name=$RANDOM)

mkdir -p "/root/.aws"
cat <<EOFF > "/root/.aws/credentials"
[default]
aws_access_key_id     = $(echo "$sts_creds" | jq -r '.Credentials.AccessKeyId')
aws_secret_access_key = $(echo "$sts_creds" | jq -r '.Credentials.SecretAccessKey')
aws_session_token     = $(echo "$sts_creds" | jq -r '.Credentials.SessionToken')
expiration            = $(echo "$sts_creds" | jq -r '.Credentials.Expiration')
EOFF

/usr/sbin/sshd -i
EOF

chmod 0700 "$ssh_entrypoint"
