#!/bin/bash

set -eu -o pipefail

# Set working directory to project root
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../../../.." >/dev/null

target=${1?Please specify a target (cluster:workspace).  Usage: $0 <cluster>:<workspace>}
workspace=${target#*:}
cluster=${target%:*}

bin/cicdctl creds aws-mfa "$workspace"

export AWS_PROFILE=admin-${workspace}
AWS_OPTS="--profile=${AWS_PROFILE} --region=us-west-2"

pushd "terraform/kops/clusters/${cluster}/cluster/${workspace}" >/dev/null

# Target the correct workspace
terraform workspace list | grep "$workspace"   >/dev/null || terraform workspace new "$workspace"
terraform workspace list | grep "* $workspace" >/dev/null || terraform workspace select "$workspace"

master_asg_ids=$(terraform output -json 'master_autoscaling_group_ids' | jq -r '.[]')
node_asg_ids=$(  terraform output -json 'node_autoscaling_group_ids'   | jq -r '.[]')

for asg in $master_asg_ids $node_asg_ids; do
    echo "ASG [$asg]"
    echo -e "Max\tMin\tDesired"
    aws $AWS_OPTS autoscaling update-auto-scaling-group  \
        --auto-scaling-group-name "$asg"                 \
        --min-size 0 --max-size 0 --desired-capacity 0
    aws $AWS_OPTS autoscaling describe-auto-scaling-groups                  \
        --auto-scaling-group-names "$asg"                                   \
        --query 'AutoScalingGroups[*].[MaxSize, MinSize, DesiredCapacity]'  \
        --output text
    echo ""
done
