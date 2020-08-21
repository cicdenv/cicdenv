## Purpose
Attaches the workload VCP(s) to the main account transit gateway.

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
