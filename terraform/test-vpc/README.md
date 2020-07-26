## Purpose
Resources for testing AMIs.

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> test-vpc:${WORKSPACE}
...
```

## Scripts
```bash
# Launch an ec2 instance in the target account
cicdenv$ cicdctl console
📦 $USER:~/cicdenv$ terraform/test-vpc/bin/launch-instances.sh ${ROOTFS}/${EPHEMERALFS}:${WORKSPACE} <instance-type>
```

## NOTES
```bash
ssh-keygen -f ~/.ssh/manual-testing.pem -y > ~/.ssh/manual-testing.pub
chmod go-rw ~/.ssh/manual-testing.pub
```

## Importing
N/A.

## Outputs
```hcl
availability_zones = [
  "<region>a",
]
iam = {
  "instance_profile" = {
    "arn" = "arn:aws:iam::<account-id>:instance-profile/test"
  }
  "role" = {
    "arn" = "arn:aws:iam::<account-id>:role/test"
    "name" = "test"
  }
}
nat_gateways = {
  "<region>a" = {
    "id" = "nat-<0x*17>"
    "ip" = "52.40.71.174"
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
  }
  "public" = [
    "rtb-<0x*17>",
  ]
}
security_group = {
  "id" = "sg-<0x*17>"
}
subnets = {
  "private" = {
    "<region>a" = {
      "arn" = "arn:aws:ec2:<region>:<account-id>:subnet/subnet-<0x*17>"
      "cidr_block" = "10.0.32.0/19"
      "id" = "subnet-<0x*17>"
    }
  }
  "public" = {
    "<region>a" = {
      "arn" = "arn:aws:ec2:<region>:<account-id>:subnet/subnet-<0x*17>"
      "cidr_block" = "10.0.0.0/22"
      "id" = "subnet-<0x*17>"
    }
  }
}
vpc = {
  "arn" = "arn:aws:ec2:<region>:<account-id>:vpc/vpc-<0x*17>"
  "cidr_block" = "10.0.0.0/16"
  "id" = "vpc-<0x*17>"
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
