#!/bin/bash

set -eu -o pipefail

#
# Usage: launch-instances.sh <workspace> <instance-type-1> [<instance-type-2> ...]
#

workspace=${1?Usage: $0 <workspace> <instance-type-1> [<instance-type-2> ...]}
instance_types="${@:2}"
if [[ -z "$instance_types" ]]; then
    >&2 echo "Usage: $0 <workspace> <instance-type-1> [<instance-type-2> ...]"
    exit 1
fi

# Set working directory to network/test-vpc
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

../../bin/cicdctl creds aws-mfa "$workspace"

export AWS_PROFILE=admin-${workspace}
AWS_OPTS="--profile=${AWS_PROFILE} --region=us-west-2"
account_id=$(aws --profile=admin-main sts get-caller-identity | jq -r '.Account')
subnet_id=$(terraform output -json subnets | jq -r '.public | .[].id')
security_group_id=$(terraform output -json security_group_id | jq -r)

instance_profile="$(terraform output -json instance_profile_arn | jq -r )"

ami_name_pattern='base/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*'
image_id=$(aws ${AWS_OPTS}                            \
    ec2 describe-images                               \
    --owners "${account_id}"                          \
    --filters "Name=name,Values=${ami_name_pattern}"  \
              'Name=state,Values=available'           \
    --output json                                     \
    | jq -r '.Images | sort_by(.CreationDate) | last(.[]).ImageId'
)

for instance_type in $instance_types; do
    instance_id=$(aws ${AWS_OPTS}                            \
        ec2 run-instances                                    \
        --image-id=${image_id}                               \
        --instance-type=${instance_type}                     \
        --key-name=manual-testing                            \
        --subnet-id=${subnet_id}                             \
        --security-group-ids=${security_group_id}            \
        --associate-public-ip-addres                         \
        --iam-instance-profile Name=${instance_profile##*/}  \
        | jq -r '.Instances[0].InstanceId'
    )
    sleep 5
    ip=$(aws ${AWS_OPTS}                                        \
        ec2 describe-instances                                  \
        --instance-ids "$instance_id"                           \
        --query 'Reservations[*].Instances[*].PublicIpAddress'  \
        --output text
    )
    echo ssh -i ~/.ssh/manual-testing.pem -o IdentitiesOnly=yes "ubuntu@${ip}"
done
