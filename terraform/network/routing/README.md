## Purpose
NAT gateways enable private subnets to access networks outside the VPC.
They are relatively expensive ~ $50 per month, per AZ, per sub-account.

Similarly VPC-endpoints cost $15 per endpoint per VPC.

Its useful to define them in a different component than the parent VPC so
they can be destroyed separately when no ec2 instances are running.

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> network/routing:${WORKSPACE}
...
```

## Importing
```hcl
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/network_shared/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
nat_gateways = {
  "<region>a" = {
    "id" = "nat-<0x*17>"
    "ip" = "<ipv4-public-ip>"
  }
  "<region>b" = {
    "id" = "nat-<0x*17>"
    "ip" = "<ipv4-public-ip>"
  }
  "<region>c" = {
    "id" = "nat-<0x*17>"
    "ip" = "<ipv4-public-ip>"
  }
}
vpc_endpoints = {
  "ecr" = {
    "id" = "vpce-<0x*17>"
  }
  "s3" = {
    "id" = "vpce-<0x*17>"
  }
}
```
