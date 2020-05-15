## Purpose
Removing default VPC resources from all regions in an org accounts.

## Workspaces
This state is per-account.

## Init
Build region list: (one time only)
```bash
cicdenv$ terraform/networking/default-vpc/bin/populate-regions.sh
```

## Usage
One time only per workspace.
```bash
# creates ${WORKSPACE}.tfvars from existing ids
cicdenv$ terraform/networking/default-vpcs/bin/populate-vpcs-vars.sh ${WORKSPACE}

# Intialize terraform
cicdenv$ cicdctl init networking/default-vpcs:${WORKSPACE}

# Import default resources
cicdenv$ terraform/networking/default-vpcs/bin/import-resources.sh ${WORKSPACE}
```

Normal workflow
```bash
cicdenv$ cicdctl terraform <plan|apply|destroy> networking/default-vpcs:${WORKSPACE} -var-file ${WORKSPACE}.tfvars
```

## Items
```
1 vpc
4 subnets
1 network ACL
1 route table
1 internet gateway
1 security groups
```

## Regions
```bash
AWS_PROFILE=admin-${WORKSPACE} aws --region=us-west-2 ec2 describe-regions | jq -r '.Regions[].RegionName'
eu-north-1
ap-south-1
eu-west-3
eu-west-2
eu-west-1
ap-northeast-2
ap-northeast-1
sa-east-1
ca-central-1
ap-southeast-1
ap-southeast-2
eu-central-1
us-east-1
us-east-2
us-west-1
us-west-2
```
