#!/bin/bash

set -eu -o pipefail

# Set working directory to the project root folder
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../.." >/dev/null

bin/cicdctl creds aws-mfa main

AWS_PROFILE=${AWS_PROFILE-admin-main}
AWS_REGION=${AWS_REGION-us-west-2}
AWS_OPTS="--profile=${AWS_PROFILE} --region=${AWS_REGION}"

account_id=$(aws ${AWS_OPTS} sts get-caller-identity | jq -r '.Account')

accounts=$(cd terraform/backend; AWS_PROFILE=${AWS_PROFILE} terraform output -json organization_accounts | jq -r '..|.id' | xargs)

function ami_permissions () {
    ami_name_pattern=$1
    
    current_image=$(aws ${AWS_OPTS}                       \
        ec2 describe-images                               \
        --owners "${account_id}"                          \
        --filters "Name=name,Values=${ami_name_pattern}"  \
                  'Name=state,Values=available'           \
        --output json                                     \
        | jq -r '.Images | sort_by(.CreationDate) | last(.[]) | .ImageId + "/" + .BlockDeviceMappings[0].Ebs.SnapshotId'
    )
    fields=($(echo $current_image | tr '/' ' '))
    image_id=${fields[0]}
    snap_id=${fields[1]}
    
    # Image permissions
    for account in $accounts; do
        aws ${AWS_OPTS} ec2         \
            modify-image-attribute  \
            --image-id "$image_id"  \
            --launch-permission     \
            "Add=[{UserId=${account}}]"
    done
    
    # Snapshot permissions
    aws ${AWS_OPTS} ec2                     \
        modify-snapshot-attribute           \
        --snapshot-id "$snap_id"            \
        --attribute createVolumePermission  \
        --operation-type add                \
        --user-ids $accounts
}

source "packer/bin/ami-names.inc"
for ami_name_prefix in $(ami_names); do
    ami_permissions "${ami_name_prefix}-*"
done
