## Purpose
Master (main) account assumable roles.

These roles are use by the other accounts to access resources in the main account.

Roles:
* `identity-resolver` - for reading IAM users and ssh public keys
* `ses-sender` - for sending email via SES

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|output> iam/assumed-roles:main
```

## Importing
```hcl
data "terraform_remote_state" "iam_assumed_roles" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/iam_assumed-roles/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
iam = {
  "identity_resolver" = {
    "policy" = {
      "arn" = "arn:aws:iam::<main-acct-id>:policy/GetIamSSHAuthorizedKeys"
      "name" = "GetIamSSHAuthorizedKeys"
      "path" = "/"
    }
    "role" = {
      "arn" = "arn:aws:iam::<main-acct-id>:role/identity-resolver"
      "name" = "identity-resolver"
      "path" = "/"
    }
  }
  "ses_sender" = {
    "policy" = {
      "arn" = "arn:aws:iam::<main-acct-id>:policy/SendSESEmails"
      "name" = "SendSESEmails"
      "path" = "/"
    }
    "role" = {
      "arn" = "arn:aws:iam::<main-acct-id>:role/ses-sender"
      "name" = "ses-sender"
      "path" = "/"
    }
  }
}
```
