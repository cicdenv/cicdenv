## Purpose
Manage terraform backend state items (post manual bootstrapping).

Items:
* remote state bucket and policy
* cloudtrail
* kms customer master key
* dynamodb tables for sub-account items

## Workspaces
N/A.

## Init
```bash
# Interactive shell
cicdenv$ make

# Create the initial aws resources manually
${USER}:~/cicdenv$ terraform/backend/bin/create-resources.sh
${USER}:~/cicdenv$ exit

# Intialize terraform
# NOTE: comment out any actual resources to produce a remote state file: kms.tf, s3.tf
#       comment out imports.tf [iam/organizations], and references to it locals.tf
cicdenv$ cicdctl terraform init backend:main

# Interactive shell (again)
cicdenv$ make

# Import manually created resources
${USER}:~/cicdenv$ terraform/backend/bin/import-resources.sh
${USER}:~/cicdenv$ exit

# Next apply iam/organizations
cicdenv$ cicdctl terraform apply iam/organizations:main

# Apply again
# - kms.tf, s3.tf, imports.tf, locals.tf
cicdenv$ cicdctl terraform apply backend:main
```

## Usage
```bash
cicdenv$ cicdctl terraform <plan|apply> backend:main
```
