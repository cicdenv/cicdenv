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
base_amis = {
  "ext4" = {
    "architecture" = "x86_64"
    "creation_date" = "<yyyy-mm-ddTHH-MM-SSZ>"
    "description" = "<github-repo>/packer/ubuntu-20.04-ext4.pkr.hcl"
    "hypervisor" = "xen"
    "id" = "ami-<0x*17>"
    "image_location" = "<account-id>/base/ubuntu-20.04-amd64-ext4-<yyyy-mm-ddTHH-MM-SSZ>"
    "most_recent" = true
    "name" = "base/ubuntu-20.04-amd64-ext4-<yyyy-mm-ddTHH-MM-SSZ>"
    "owner_id" = "<account-id>"
    "root_snapshot_id" = "snap-<0x*17>"
  }
  "zfs" = {
    "architecture" = "x86_64"
    "creation_date" = "<yyyy-mm-ddTHH-MM-SSZ>"
    "description" = "<github-repo>/packer/ubuntu-20.04-zfs.pkr.hcl"
    "hypervisor" = "xen"
    "id" = "ami-<0x*17>"
    "image_location" = "<account-id>/base/ubuntu-20.04-amd64-zfs-<yyyy-mm-ddTHH-MM-SSZ>"
    "most_recent" = true
    "name" = "base/ubuntu-20.04-amd64-zfs-<yyyy-mm-ddTHH-MM-SSZ>"
    "owner_id" = "<account-id>"
    "root_snapshot_id" = "snap-<0x*17>"
  }
}
```
