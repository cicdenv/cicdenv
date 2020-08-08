## Purpose
Main account site-wide egress VPC and Transit Gateways.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> network/backend:main
...
```

## Importing
```hcl
data "terraform_remote_state" "network_backend" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/network_backend/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
availability_zones = {
  "us-west-2" = {
    "usw2-az1" = "us-west-2?"
    "usw2-az2" = "us-west-2?"
    "usw2-az3" = "us-west-2?"
  }
}
private_dns_zone = {
  "domain" = "<domain>"
  "name" = "<domain>."
  "zone_id" = "Z<[A-Z0-9]*20>"
}
private_dns_zone_ecr_vpce = {
  "domain" = "api.ecr.<region>.amazonws.com"
  "name" = "api.ecr.<region>.amazonws.com."
  "zone_id" = "Z<[A-Z0-9]*20>"
}
route_tables = {
  "private" = {
    "<region>a" = {
      "id" = "rtb-<0x*17>"
    }
    "<region>b" = {
      "id" = "rtb-<0x*17>"
    }
    "<region>c" = {
      "id" = "rtb-<0x*17>"
    }
  }
  "public" = [
    "rtb-<0x*17>",
  ]
}
subnets = {
  "private" = {
    "<region>a" = {
      "arn" = "arn:aws:ec2:<region>:<account-id>:subnet/subnet-<0x*17>"
      "cidr_block" = "10.16.32.0/19"
      "id" = "subnet-<0x*17>"
    }
    "<region>b" = {
      "arn" = "arn:aws:ec2:<region>:<account-id>:subnet/subnet-<0x*17>"
      "cidr_block" = "10.16.64.0/19"
      "id" = "subnet-<0x*17>"
    }
    "<region>c" = {
      "arn" = "arn:aws:ec2:<region>:<account-id>:subnet/subnet-<0x*17>"
      "cidr_block" = "10.16.96.0/19"
      "id" = "subnet-<0x*17>"
    }
  }
  "public" = {
    "<region>a" = {
      "arn" = "arn:aws:ec2:<region>:<account-id>:subnet/subnet-<0x*17>"
      "cidr_block" = "10.16.0.0/22"
      "id" = "subnet-<0x*17>"
    }
    "<region>b" = {
      "arn" = "arn:aws:ec2:<region>:<account-id>:subnet/subnet-<0x*17>"
      "cidr_block" = "10.16.4.0/22"
      "id" = "subnet-<0x*17>"
    }
    "<region>c" = {
      "arn" = "arn:aws:ec2:<region>:<account-id>:subnet/subnet-<0x*17>"
      "cidr_block" = "10.16.8.0/22"
      "id" = "subnet-<0x*17>"
    }
  }
}
transit_gateways = {
  "internet" = {
    "arn" = "arn:aws:ec2:<region>:<main-acct-id>:transit-gateway/tgw-<0x*17>"
    "default" = {
      "route_tables" = {
        "association" = {
          "id" = "tgw-rtb-<0x*17>"
        }
        "propagation" = {
          "id" = "tgw-rtb-<0x*17>"
        }
      }
    }
    "id" = "tgw-<0x*17>"
  }
}
vpc = {
  "arn" = "arn:aws:ec2:<region>:<account-id>:vpc/vpc-<0x*17>"
  "cidr_block" = "10.16.0.0/16"
  "id" = "vpc-<0x*17>"
}
```
