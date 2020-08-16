## Purpose
Common state-store, builds bucket for all KOPS kubernetes clusters in all regions/accounts.

## Workspaces
N/A.  All accounts store kops state in the same bucket in main-acct/us-west-2.

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
builds = {
  "bucket" = {
    "arn" = "arn:aws:s3:::kops-builds-<domain->"
    "id" = "kops-builds-<domain->"
    "name" = "kops-builds-<domain->"
  }
}
state_store = {
  "bucket" = {
    "arn" = "arn:aws:s3:::kops-state-<domain->"
    "id" = "kops-state-<domain->"
    "name" = "kops-state-<domain->"
  }
  "key" = {
    "alias" = "alias/kops-state"
    "arn" = "arn:aws:kms:<region>:<main-acct-id>:key/<guid>"
    "key_id" = "<guid>"
  }
}
```
