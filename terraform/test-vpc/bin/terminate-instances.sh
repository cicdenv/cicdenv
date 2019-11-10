#!/bin/bash

set -eu -o pipefail

workspace=${1?Usage: $0 <workspace>}

AWS_PROFILE=admin-${workspace}
AWS_OPTS="--profile=${AWS_PROFILE} --region=us-west-2"

# Set working directory to networking/test-vpc
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

../../bin/cicdctl creds aws-mfa "$workspace"

cidr=$(grep '"network_cidr"' -A1 variables.tf | tail -n1 | sed -E 's/.*= "([^"]+)"/\1/')

vpc_id=$(aws ${AWS_OPTS}                  \
    ec2 describe-vpcs                     \
    --filters "Name=cidr,Values=${cidr}"  \
    --query 'Vpcs[*].VpcId'               \
    --output text
)

instance_ids=$(aws ${AWS_OPTS}                                                                  \
    ec2 describe-instances                                                                      \
    --filters "Name=vpc-id,Values=${vpc_id}"                                                    \
              "Name=instance-state-name,Values=pending,running,shutting-down,stopping,stopped"  \
    --query 'Reservations[*].Instances[*].InstanceId'                                           \
    --output text
)

if [[ ! -z "$instance_ids" ]]; then
    aws ${AWS_OPTS} ec2 terminate-instances --instance-ids $instance_ids
fi
