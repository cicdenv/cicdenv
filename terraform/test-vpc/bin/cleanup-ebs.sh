#!/bin/bash

set -eu -o pipefail

workspace=${1?Usage: $0 <workspace>}

../../../bin/cicdctl creds aws-mfa "$workspace"

AWS_PROFILE=admin-${workspace}
AWS_OPTS="--profile=${AWS_PROFILE} --region=us-west-2"

account_id=$(aws $AWS_OPTS sts get-caller-identity | jq -r '.Account')
image_ids=$(aws ${AWS_OPTS}      \
    ec2 describe-images          \
    --owners "${account_id}"     \
    --query 'Images[*].ImageId'  \
    --output text
)
for image_id in $image_ids; do
    snapshot_ids=$(aws ${AWS_OPTS}                                 \
        ec2 describe-images                                        \
        --image-ids "$image_id"                                    \
        --query 'Images[*].BlockDeviceMappings[*].Ebs.SnapshotId'  \
        --output text
    )
    aws ${AWS_OPTS} ec2 deregister-image --image-id "$image_id" 
    for snapshot_id in $snapshot_ids; do
        aws ${AWS_OPTS} ec2 delete-snapshot --snapshot-id "$snapshot_id"
    done
done
