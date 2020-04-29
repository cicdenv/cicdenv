#!/bin/bash

set -eu -o pipefail

# Set working directory to project root
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../../../.." >/dev/null

target=${1?Please specify a target (instance:workspace).  Usage: $0 <instance-name>:<workspace>}
instance_name=${target%:*}
workspace=${target#*:}

bin/cicdctl creds aws-mfa "$workspace"

export AWS_PROFILE=admin-${workspace}
AWS_OPTS="--profile=${AWS_PROFILE} --region=us-west-2"

pushd "terraform/jenkins/instances/${instance_name}" >/dev/null

# Target the correct workspace
terraform workspace list | grep "$workspace"   >/dev/null || terraform workspace new    "$workspace"
terraform workspace list | grep "* $workspace" >/dev/null || terraform workspace select "$workspace"

asg_ids=$(terraform output -json 'autoscaling_groups' | jq -r '.[].id')

for asg in $asg_ids; do
    instance_ids=$(aws $AWS_OPTS autoscaling                    \
        describe-auto-scaling-groups                            \
        --auto-scaling-group-names "$asg"                       \
        --query 'AutoScalingGroups[*].Instances[*].InstanceId'  \
        --output text                                           \
    )
    aws $AWS_OPTS ec2 describe-instances                          \
        --instance-ids $instance_ids                              \
        --query 'Reservations[*].Instances[*].PrivateIpAddress'   \
        --output text
done
