## Purpose
Attache workload VCP(s) to the main account (egress) transit gateway.

Tranist Gateway attachments enable private subnets to access networks outside the VPC.
TG attachments are relatively expensive ~ $28 per VPC.

Its useful to define them in a different component than the shared account VPC so
they can be destroyed separately when no ec2 instances are running in the account.

NOTE: `network/routing` creates the `backend` (transit) VPC to shared TG attachment.

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> network/routing/attachments:${WORKSPACE}
...
```

## Importing
N/A.

## Outputs
```hcl
transit_gateway_vpc_attachment = {
  "id" = "tgw-attach-<0x*17>"
  "subnet_ids" = [
    "subnet-<0x*17>",
    "subnet-<0x*17>",
    "subnet-<0x*17>",
  ]
  "transit_gateway_id" = "tgw-<0x*17>"
  "vpc_id" = "vpc-<0x*17>"
  "vpc_owner_id" = "<account-id>"
}
```
