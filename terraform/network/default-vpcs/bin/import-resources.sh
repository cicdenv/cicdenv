#!/bin/bash

set -eu -o pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

# Account Name
workspace=${1?Usage: $0 <workspace>}

../../../bin/cicdctl creds aws-mfa "$workspace"

export AWS_PROFILE=admin-${workspace}

terraform workspace select ${workspace}

# Sorted list of regions
regions=$(\
    aws --profile=${AWS_PROFILE} --region=us-west-2 \
        ec2 describe-regions \
    | jq -r '.Regions[].RegionName' \
    | sort \
)

#set -x
for region in $regions; do
    # Import the VPC
    vpc_id=$(\
        aws --profile=${AWS_PROFILE} --region=${region} \
            ec2 describe-vpcs \
            --filters Name=isDefault,Values=true \
            --query 'Vpcs[].{id: VpcId}' \
            | jq -r '.[0] | .id' \
    )
    if [[ "$vpc_id" != "null" ]]; then
        # module.default_vpc-us-west-2.aws_vpc.default
        (terraform state list | grep "^module.default_vpc-${region}.aws_vpc.default\$") \
        || terraform import -var-file "${workspace}.tfvars" "module.default_vpc-${region}.aws_vpc.default" "${vpc_id}"
        
        # Import subnets
        subnet_ids=($(\
            aws --profile=${AWS_PROFILE} --region=${region} \
                ec2 describe-subnets \
                --filters "Name=vpc-id,Values=${vpc_id}" \
                --query 'Subnets[].{id: SubnetId}' \
            | jq -r '.[] | .id' \
        ))
        for ((i=0; i<${#subnet_ids[*]}; i++)); do
            (terraform state list | grep "^module.default_vpc-${region}.aws_subnet.default\\[$i\\]\$") \
            || terraform import -var-file "${workspace}.tfvars" "module.default_vpc-${region}.aws_subnet.default[$i]" "${subnet_ids[i]}"
        done
        
        # Import Internet Gateway
        igw_id=$(\
            aws --profile=${AWS_PROFILE} --region=${region} \
                ec2 describe-internet-gateways \
                --filters "Name=attachment.vpc-id,Values=${vpc_id}" \
                --query 'InternetGateways[].{id: InternetGatewayId}' \
            | jq -r '.[0] | .id' \
        )
        (terraform state list | grep "^module.default_vpc-${region}.aws_internet_gateway.default\$") \
        || terraform import -var-file "${workspace}.tfvars" "module.default_vpc-${region}.aws_internet_gateway.default" "${igw_id}"
    fi
done
#set +x

popd >/dev/null
