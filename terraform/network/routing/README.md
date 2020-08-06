## Purpose
Side-wide NAT gateways enable private subnets to access networks outside the VPC.
They are relatively expensive ~ $50 per month, per AZ.

Its useful to define them in a different component than the egress VPC so
they can be destroyed separately when no ec2 instances are running site-wide.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> network/routing:main
...
```
## Importing
```hcl
data "terraform_remote_state" "network_routing" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/network_routing/terraform.tfstate"
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
transit_gateway_vpc_attachment = {
  "internet" = {
    "id" = "tgw-attach-<0x*17>"
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
