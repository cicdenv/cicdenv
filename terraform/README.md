# Terraform States

## Accounts
The main account hosts serveral resources that are used by sub-accounts

* terraform state bucket
* IAM users
* kops state bucket
* custom AMIs

## States
Can be categorized by target AWS account:
* `non workspace` master (main) account only
* `workspace` master (main) account AND organization account (sub-account)

```
NOTE:  Some state may use more than one AWS provider to create resources in
       both the main account and sub-account.
```

## Global Variables
[backend-config.tfvars](backend-config.tfvars) applies to all states in the repo

States my ask for automatic [backend-config.tfvars](backend-config.tfvars) `-var name=value`
bindings from this file by adding empty variable definitions in `variables.tf`:
```
variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars
```

Global variables other than those defined in [backend-config.tfvars](backend-config.tfvars)
will be bound by `-var-file ...` arguments.

```
NOTE: If more than one variable is defined in a `.tfvar` file states using it must define
      empty variables for all vars defined in the file.
      Where possible define only global var per global .tfvar file.
```
