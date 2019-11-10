#!/bin/bash

set -eu -o pipefail

# Set working directory to project root
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../../../.." >/dev/null

workspace=${1?Usage: $0 <workspace>}

bin/cicdctl creds aws-mfa "$workspace"

AWS_PROFILE=admin-${workspace}
AWS_OPTS="--profile=${AWS_PROFILE}"

domain_config="terraform/domain.tfvars"
domain=$(grep 'domain ' "$domain_config" | awk -F= '{print $2}' | sed 's/[" ]//g')

zone_id=$(\
     aws $AWS_OPTS route53 list-hosted-zones \
     | jq -r '.HostedZones[] | select(.Name == "'$domain'." and .Config.PrivateZone == true) | .Id' \
)

aws $AWS_OPTS \
    route53 list-resource-record-sets \
    --hosted-zone-id "$zone_id" \
| jq -c '.ResourceRecordSets[]' \
| while read -r rs; do
    read -r name type <<<$(echo $(jq -r '.Name, .Type' <<<"$rs"))
    if [ $type != "NS" -a $type != "SOA" ]; then
        aws $AWS_OPTS \
            route53 change-resource-record-sets \
            --hosted-zone-id "$zone_id" \
            --change-batch '{"Changes": [{"Action": "DELETE", "ResourceRecordSet": '"$rs"'}]}' \
            --output text \
            --query 'ChangeInfo.Id'
    fi
done
