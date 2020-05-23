#!/bin/bash

set -eu -o pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

# Account Name
workspace=${1?Usage: $0 <workspace>}

../../../bin/cicdctl creds aws-mfa "$workspace"

AWS_PROFILE=admin-${workspace}

# Sorted list of regions
regions=$(\
    aws --profile=${AWS_PROFILE} --region=us-west-2 \
        ec2 describe-regions \
    | jq -r '.Regions[].RegionName' \
    | sort \
)

# Truncate workspace specific variable overrides
> "${workspace}.tfvars"

# Default VPC Cidr block, usually "172.31.0.0/16"
cat <<EOF | tee -a "${workspace}.tfvars"
default_vpc_cidr = {
EOF
for region in $regions; do
    cidr_block=$(\
        aws --profile=${AWS_PROFILE} --region=${region} \
            ec2 describe-vpcs \
            --filters Name=isDefault,Values=true \
            --query 'Vpcs[].{cidr: CidrBlock}' \
        | jq -r '.[0] | .cidr' \
    )
  
    if [[ "$cidr_block" != "null" ]]; then 
        cat <<EOF | tee -a "${workspace}.tfvars"
  "${region}" = "${cidr_block}"
EOF
  fi
done
cat <<EOF | tee -a "${workspace}.tfvars"
}
EOF

# Default VPC subnet cidrs
cat <<EOF | tee -a "${workspace}.tfvars"
default_vpc_subnet_cidrs = {
EOF
for region in $regions; do
    vpc_id=$(\
        aws --profile=${AWS_PROFILE} --region=${region} \
            ec2 describe-vpcs \
            --filters Name=isDefault,Values=true \
            --query 'Vpcs[].{id: VpcId}' \
            | jq -r '.[0] | .id' \
    )
    subnet_cidrs=$(\
        aws --profile=${AWS_PROFILE} --region=${region} \
            ec2 describe-subnets \
            --filters Name=vpc-id,Values=${vpc_id} \
            --query 'Subnets[].{cidr: CidrBlock}' \
        | jq -r '.[] | .cidr'\
    )

    if [[ ! -z "$subnet_cidrs" ]]; then
        cat <<EOF | tee -a "${workspace}.tfvars"
  "${region}" = [$(echo "$subnet_cidrs" | xargs | sed 's/^/"/;s/$/"/;s/ /", "/g')]
EOF
    fi
done
cat <<EOF | tee -a "${workspace}.tfvars"
}
EOF

# DefaultVPC subnet availability zones
cat <<EOF | tee -a "${workspace}.tfvars"
default_vpc_subnet_azs = {
EOF
for region in $regions; do
    vpc_id=$(\
        aws --profile=${AWS_PROFILE} --region=${region} \
            ec2 describe-vpcs \
            --filters Name=isDefault,Values=true \
            --query 'Vpcs[].{id: VpcId}' \
            | jq -r '.[0] | .id' \
    )
    subnet_azs=$(\
        aws --profile=${AWS_PROFILE} --region=${region} \
            ec2 describe-subnets \
            --filters Name=vpc-id,Values=${vpc_id} \
            --query 'Subnets[].{az: AvailabilityZone}' \
        | jq -r '.[] | .az'\
    )

    if [[ ! -z "$subnet_azs" ]]; then
        cat <<EOF | tee -a "${workspace}.tfvars"
  "${region}" = [$(echo "$subnet_azs" | xargs | sed 's/^/"/;s/$/"/;s/ /", "/g')]
EOF
    fi
done
cat <<EOF | tee -a "${workspace}.tfvars"
}
EOF

popd >/dev/null
