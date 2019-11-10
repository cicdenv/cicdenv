#!/bin/bash

set -eu -o pipefail

# Set working directory to packer/
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

../bin/cicdctl creds aws-mfa main

#
# Only handles 1 snapshot
#

ami_name_pattern=${1-'base/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*'}

AWS_PROFILE=${AWS_PROFILE-admin-main}
AWS_REGION=${AWS_REGION-us-west-2}
AWS_OPTS="--profile=${AWS_PROFILE} --region=${AWS_REGION}"

account_id=$(aws ${AWS_OPTS} sts get-caller-identity | jq -r '.Account')
current_image_id=$(aws ${AWS_OPTS}                    \
    ec2 describe-images                               \
    --owners "${account_id}"                          \
    --filters "Name=name,Values=${ami_name_pattern}"  \
              'Name=state,Values=available'           \
    --output json                                     \
    | jq -r '.Images | sort_by(.CreationDate) | last(.[]).ImageId'
)

images=$(aws ${AWS_OPTS}                                                  \
    ec2 describe-images                                                   \
    --owners "${account_id}"                                              \
    --filters "Name=name,Values=${ami_name_pattern}"                      \
              'Name=state,Values=available'                               \
    --query 'Images[*].[ImageId, BlockDeviceMappings[*].Ebs.SnapshotId]'  \
    --output json \
    | jq -r '.[] | .[0] + "/" + .[1][0]'
)
for image in $images; do
    fields=($(echo $image | tr '/' ' '))

    image_id=${fields[0]}
    snap_id=${fields[1]}

    if [[ "$image_id" == "$current_image_id" ]]; then
    	continue
    fi

    aws ${AWS_OPTS} ec2 deregister-image --image-id "$image_id"
    aws ${AWS_OPTS} ec2 delete-snapshot --snapshot-id "$snap_id"
done
