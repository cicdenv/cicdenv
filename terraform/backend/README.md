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
