## Purpose
Manage terraform backend state items (post manual bootstrapping).

Items:
* remote state bucket and policy
* cloudtrail
* kms customer master key
* dynamodb tables for sub-account items

Creates sub-accounts.

NOTE: 
```
Terraform AWS Organizations support is currently limited.
Hence the shell scripts for creating OUs and associating sub-accounts to them.
```

## Workspaces
N/A.

## Init
```bash
# Interactive shell
cicdenv$ cicdctl console

# Create the initial aws resources manually
${USER}:~/cicdenv$ terraform/backend/bin/create-resources.sh
${USER}:~/cicdenv$ exit

# Intialize terraform
cicdenv$ cicdctl terraform init backend:main

# Interactive shell (again)
cicdenv$ cicdctl console

# Import manually created resources
${USER}:~/cicdenv$ terraform/backend/bin/import-resources.sh
${USER}:~/cicdenv$ exit

# Apply
cicdenv$ cicdctl terraform apply backend:main
```

## Usage
```bash
cicdenv$ cicdctl terraform <plan|apply> backend:main
```

## Organizations CLI Usage
NOTE: must target `us-east-1` API endpoint using main acct creds:
```bash
# Interactive shell
cicdenv$ console

${USER}:~/cicdenv$ aws --profile=admin-main --region=us-east-1 ...
${USER}:~/cicdenv$ exit
```

## Importing
```hcl
data "terraform_remote_state" "accounts" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/backend/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
all_roots = [
  "arn:aws:iam::<main-acct-id>:root",
  "arn:aws:iam::<account-id>:root",
  ...
]
console_urls = [
  "https://<main-acct-id>.signin.aws.amazon.com/console/",
  "https://<alias>.signin.aws.amazon.com/console/",
]
main_account = {
  "alias" = "<alias>"
  "id" = "<main-acct-id>"
  "root" = "arn:aws:iam::<main-acct-id>:root"
}
org_roots = [
  "arn:aws:iam::<account-id>:root",
  ...
]
organization = {
  "arn" = "arn:aws:organizations::<main-acct-id>:organization/o-<[a-z0-9]*10>"
  "id" = "o-<[a-z0-9]*10>"
}
organization_accounts = {
  "<account-name>" = {
    "id" = "<account-id>"
    "ou" = "<organizational-unit>"
    "role" = "arn:aws:iam::<account-id>:role/<account-name>-admin"
    "root" = "arn:aws:iam::<account-id>:root"
  }
  ...
}
```
