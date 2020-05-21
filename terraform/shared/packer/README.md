## Purpose
Export info about packer created AWS resources (AMIs).

## Workspaces
N/A.

## Importing
imports.tf:
```hcl
data "terraform_remote_state" "amis" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared_packer/terraform.tfstate"
    region = var.region
  }
}
```

variables.tf:
```hcl
variable "base_ami_id" {} # amis.tfvars
```

locals.tf:
```hcl
locals {
  ami_id = var.base_ami_id != "" ? var.base_ami_id : data.terraform_remote_state.amis.outputs.base_ami.id
}
```

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> shared/packer:main
...
```
