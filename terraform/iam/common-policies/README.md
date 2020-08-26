## Purpose
Policies cannot be shared between accounts.

This is used to define the custom IAM policies that all accounts should have.

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> iam/common-policies:${WORKSPACE}
...
```

## Importing
```hcl
data "terraform_remote_state" "iam_common_policies" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/iam_common-policies/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
iam = {
  "apt_repo" = {
    "policy" = {
      "arn" = "arn:aws:iam::<account-id>:policy/S3AptRepositoryReadOnly"
      "name" = "S3AptRepositoryReadOnly"
      "path" = "/"
    }
    "role" = {
      "arn" = "arn:aws:iam::<account-id>:role/apt-repo-access"
      "name" = "apt-repo-access"
    }
  }
}
```
