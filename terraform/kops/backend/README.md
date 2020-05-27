## Purpose
Common state-store for all KOPS kubernetes clusters in all regions/accounts.

## Workspaces
N/A.  All accounts store kops state in the same bucket in main-acct/us-west-2.

## Init
Create KOPS CA.
```
cicdenv$ terraform/kops/backend/bin/create-ca.sh
...
2019/06/25 12:09:55 [INFO] signed certificate with serial number ....
```

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|output> kops/backend:main
...
```

NOTE:
```
The sub-account admin IAM role is similarly sourced to provide access to users/workspaced-terraform.
```

## Importing
```hcl
data "terraform_remote_state" "backend" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/kops_backend/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
etcd_kms_key = {
  "arn" = "arn:aws:kms:us-west-2:<account-id>:key/<guid>"
  "key_id" = "<guid>"
  "name" = "alias/kops-etcd"
}
iam = {
  "master" = {
    "instance_profile" = {
      "arn" = "arn:aws:iam::<account-id>:instance-profile/kops-master"
    }
    "role" = {
      "arn" = "arn:aws:iam::<account-id>:role/system/kops-master"
      "name" = "kops-master"
    }
  }
  "node" = {
    "instance_profile" = {
      "arn" = "arn:aws:iam::<account-id>:instance-profile/kops-node"
    }
    "role" = {
      "arn" = "arn:aws:iam::<account-id>:role/system/kops-node"
      "name" = "kops-node"
    }
  }
}
security_groups = {
  "external_apiserver" = {
    "id" = "sg-<0x*17>"
  }
  "internal_apiserver" = {
    "id" = "sg-<0x*17>"
  }
  "master" = {
    "id" = "sg-<0x*17>"
  }
  "node" = {
    "id" = "sg-<0x*17>"
  }
}
```
