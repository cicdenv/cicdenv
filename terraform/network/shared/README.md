## Purpose
Common networking resources for all compute resources.

NOTE: per hour resources (nat gateways, VPC-endpoints) reside in [network/routing](../routing).

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> network/shared:${WORKSPACE}
...
```

## Importing
```hcl
data "terraform_remote_state" "shared" {
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
availability_zones = [
  "<region>a",
  "<region>b",
  "<region>c",
]
bastion_events = {
  "security_group" = {
    "id" = "sg-<0x*17>"
  }
}
bastion_service = {
  "security_group" = {
    "id" = "sg-<0x*17>"
  }
}
private_dns_zone = {
  "domain" = "<domain>"
  "name" = "<domain>."
  "name_servers" = [
    "ns-<N*>.awsdns-00.com.",
    "ns-<N*>.awsdns-00.org.",
    "ns-<N*>.awsdns-00.co.uk.",
    "ns-<N*>.awsdns-00.net.",
  ]
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
subnet_tags = {
  "private" = {
    "SubnetType" = "Private"
    "kubernetes.io/role/internal-elb" = "1"
  }
  "public" = {
    "SubnetType" = "Utility"
    "kubernetes.io/role/elb" = "1"
  }
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
vpc = {
  "arn" = "arn:aws:ec2:<region>:<account-id>:vpc/vpc-<0x*17>"
  "cidr_block" = "10.16.0.0/16"
  "id" = "vpc-<0x*17>"
}
```
