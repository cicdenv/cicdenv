#!/bin/bash

set -eu -o pipefail

# Set working directory to packer/
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

../bin/cicdctl creds aws-mfa main

AWS_PROFILE=${AWS_PROFILE-admin-main}
AWS_REGION=${AWS_REGION-us-west-2}
AWS_OPTS="--profile=${AWS_PROFILE} --region=${AWS_REGION}"

account_id=$(aws ${AWS_OPTS} sts get-caller-identity | jq -r '.Account')

function remove_amis () {
    ami_name_pattern=$1
    
    images=$(aws ${AWS_OPTS}                                                  \
        ec2 describe-images                                                   \
        --owners "${account_id}"                                              \
        --filters "Name=name,Values=${ami_name_pattern}"                      \
                  'Name=state,Values=available'                               \
        --query 'Images[*].[ImageId, BlockDeviceMappings[*].Ebs.SnapshotId]'  \
        --output json \
        | jq -r '.[] | .[0] + "/" + (.[1] | join("/"))'
    )
    for image in $images; do
        fields=($(echo $image | tr '/' ' '))
    
        image_id=${fields[0]}
        snap_ids=${fields[@]:1}
    
        aws ${AWS_OPTS} ec2 deregister-image --image-id "$image_id"
        for snap_id in $snap_ids; do
            aws ${AWS_OPTS} ec2 delete-snapshot --snapshot-id "$snap_id"
        done
    done
}

source "bin/ami-names.inc"
for ami_name_prefix in $(ami_names); do
    remove_amis "${ami_name_prefix}-*"
done
