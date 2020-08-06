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
cloudwatch_log_groups = {
  "ssh_keys" = {
    "arn" = "arn:aws:logs:<region>:<account-id>:log-group:/aws/lambda/shared-ec2-keypair-generator:*"
    "name" = "/aws/lambda/shared-ec2-keypair-generator"
  }
}
iam = {
  "ssh_keys" = {
    "instance_profile" = {
      "arn" = "arn:aws:iam::<account-id>:instance-profile/shared-ec2-keypair-secret-generator"
    }
    "policy" = {
      "arn" = "arn:aws:iam::<account-id>:policy/SharedEC2KeyPairSecretGenerator"
      "name" = "SharedEC2KeyPairSecretGenerator"
      "path" = "/"
    }
    "role" = {
      "arn" = "arn:aws:iam::<account-id>:role/shared-ec2-keypair-secret-generator"
      "name" = "shared-ec2-keypair-secret-generator"
    }
  }
}
lambdas = {
  "ssh_keys" = {
    "function_name" = "shared-ec2-keypair-generator"
    "handler" = "lambda.lambda_handler"
    "runtime" = "python3.7"
  }
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
secrets = {
  "shared_ec2_keypair" = {
    "arn" = "arn:aws:secretsmanager:<region>:<main-acct-id>:secret:shared-ec2-keypair-<[a-z0-9]*6>"
    "name" = "shared-ec2-keypair"
  }
}
```
