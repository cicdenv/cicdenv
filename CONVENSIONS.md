## Conventions
## Terraform Variables
Terraform 0.12.0+ is particular about variable bindings on the command line
matching defined `variables` in the state.

The `cicdctl` CLI automatically binds variables from the default tfvar directory `terraform/*.tfvars`
to the terraform command line used for various sub-commands.

For example, to locate the terraform backend statefile location for
importing another states outputs, you want to source the `region/bucket` being used:

variables.tf
```
variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars
```
The comment informs `cicdctl` CLI as to which tfvar file to obtain the values from.
