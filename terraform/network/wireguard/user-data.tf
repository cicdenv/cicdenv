data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = <<EOF
#!/bin/bash

set -eu -o pipefail

set -x

#
# Wait for the dpkg/apt lock(s) to be available for at least 3 secs.
# 
quiet_period=3  # seconds
countdown="$quiet_period"
while [[ "$countdown" -gt 0 ]]; do
    echo "apt/dpkg lock - quiet period countdown: $${countdown} ..."
    for lock_file in                    \
        /var/lib/dpkg/lock              \
        /var/lib/dpkg/lock-frontend     \
        /var/lib/apt/lists/lock         \
        /var/cache/apt/archives/lock; do
        # echo "Checking lock: $${lock_file} ..."
        if [[ $(fuser "$lock_file") ]]; then
            echo "Waiting for lock: $${lock_file} ..."
            countdown="$quiet_period"  # Reset quiet period countdown
        fi
    done
    sleep 1
    countdown=$(($countdown - 1))
done

#
# Required packages
#
apt-get update
apt-get install wireguard -y

IMDSv2_TOKEN=$(curl -X PUT -H "X-aws-ec2-metadata-token-ttl-seconds: 3000" -sL "http://169.254.169.254/latest/api/token")
export AVAILABILITY_ZONE=$(curl -H "X-aws-ec2-metadata-token:$IMDSv2_TOKEN" -m5 -sS http://169.254.169.254/latest/meta-data/placement/availability-zone)
export AWS_DEFAULT_REGION=$(echo "$AVAILABILITY_ZONE" | sed 's/.$//')

# Set 'host' hostname to match dns
hostnamectl set-hostname "${local.host_name}-$(echo $AVAILABILITY_ZONE | sed -r 's/.*(.)$/\1/')"

mkdir -p /etc/wireguard

#
# Install server keys
#
(
    umask 077;
    aws secretsmanager get-secret-value            \
        --secret-id "${local.wireguard_keys.arn}"  \
        --version-stage 'AWSCURRENT'               \
        --query  'SecretString'                    \
    | jq -r 'fromjson | .["private.key"]'          \
    > "/etc/wireguard/private.key"
    aws secretsmanager get-secret-value            \
        --secret-id "${local.wireguard_keys.arn}"  \
        --version-stage 'AWSCURRENT'               \
        --query  'SecretString'                    \
    | jq -r 'fromjson | .["public.key"]'           \
    > "/etc/wireguard/public.key"
)

#
# Wireguard config
#
(
    umask 077;
    cat <<EOFF > /etc/wireguard/wg0.conf
[Interface]
Address    = 172.18.1.5/16
PrivateKey = $(cat /etc/wireguard/private.key)
ListenPort = 51820
EOFF
)

#
# Start wireguard
#
systemctl enable wg-quick@wg0.service
systemctl start wg-quick@wg0.service
EOF
  }
}
