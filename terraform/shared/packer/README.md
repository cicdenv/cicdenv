## Purpose
Export info about packer created AWS resources (AMIs).

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> shared/packer:main
...
```

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

## Outputs
```hcl
base_ami = {
  "architecture" = "x86_64"
  "creation_date" = "2020-05-26T22:18:32.000Z"
  "description" = "<github-repo>/terraform/packer/ubuntu-20.04.pkr.hcl"
  "hypervisor" = "xen"
  "id" = "ami-<0x*17>"
  "image_location" = "<account-id>/base/hvm-ssd/ubuntu-focal-20.04-amd64-server-<yyyy-mm-ddTHH-MM-SSZ>"
  "most_recent" = true
  "name" = "base/hvm-ssd/ubuntu-focal-20.04-amd64-server-<yyyy-mm-ddTHH-MM-SSZ>"
  "owner_id" = "<account-id>"
  "root_snapshot_id" = "snap-<0x*17>"
}
```
