#!/bin/bash

mkdir -p "groups/${name}/${id}"

cat <<EOF > "groups/${name}/${id}/terraform.tf"
terraform {
  required_version = ">= ${TERRAFORM_VERSION}"
  backend "s3" {
    key = "mysql_groups_${name}_${id}/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
EOF

cat <<'EOF' > "groups/${name}/${id}/providers.tf"
provider "aws" {
  region = var.target_region

  profile = "admin-${terraform.workspace}"
}
EOF

cat <<'EOF' > "groups/${name}/${id}/imports.tf"
data "terraform_remote_state" "amis" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared_packer/terraform.tfstate"
    region = var.region
  }
}
EOF

cat <<'EOF' > "groups/${name}/${id}/locals.tf"
locals {
  ami_id = var.base_ami_id != "" ? var.base_ami_id : data.terraform_remote_state.amis.outputs.base_ami.id
}
EOF

cat <<EOF > "groups/${name}/${id}/variables.tf"
variable "region"      {} # backend-config.tfvars
variable "bucket"      {} # backend-config.tfvars
variable "base_ami_id" {} # amis.tfvars

variable "target_region" {
  default = "us-west-2"
}

variable "instance_type" {
  default = "${tf_vars[instance_type]}"
}
EOF

cat <<EOF > "groups/${name}/${id}/README.md"
## Purpose
${name} MySQL service instance resources.

## Workspaces
This state is per-account.

## Usage
\`\`\`
${repo}\$ cicdctl terraform <init|plan|apply|destroy|output> mysql/groups/${name}/${id}:\${WORKSPACE}
...
\`\`\`
EOF

cat <<EOF > "groups/${name}/${id}/mysql.tf"
module "mysql_instance" {
  source = "../../../modules/instance"

  terraform_state = {
    region = var.region
    bucket = var.bucket
  }
  
  ami_id = local.ami_id
  
  name = "${name}"
  id   = "${id}"

  instance_type = var.instance_type
}
EOF

cat <<EOF > "groups/${name}/${id}/outputs.tf"
output "dns" {
  value = module.mysql_instance.dns
}

output "autoscaling_group" {
  value = module.mysql_instance.autoscaling_group
}

output "ami" {
  value = {
    id = local.ami_id
  }
}
EOF
