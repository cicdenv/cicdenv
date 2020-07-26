#!/bin/bash

cat <<EOF > "clusters/${name}/terraform.tf"
terraform {
  required_version = ">= ${TERRAFORM_VERSION}"
  backend "s3" {
    key = "redis_clusters_${name}/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
EOF

cat <<'EOF' > "clusters/${name}/providers.tf"
provider "aws" {
  region = var.target_region

  profile = "admin-${terraform.workspace}"
}
EOF

cat <<'EOF' > "clusters/${name}/imports.tf"
data "terraform_remote_state" "amis" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared_packer/terraform.tfstate"
    region = var.region
  }
}
EOF

cat <<'EOF' > "clusters/${name}/locals.tf"
locals {
  ami_id = var.base_ami_id != "" ? var.base_ami_id : data.terraform_remote_state.amis.outputs.base_amis["ext4-ext4"].id
}
EOF

cat <<EOF > "clusters/${name}/variables.tf"
variable "region"      {} # backend-config.tfvars
variable "bucket"      {} # backend-config.tfvars
variable "base_ami_id" {} # amis.tfvars

variable "target_region" {
  default = "us-west-2"
}

variable "name" {
  default = "${name}"
}

variable "instance_type" {
  default = "${tf_vars[instance_type]}"
}
EOF

cat <<EOF > "clusters/${name}/redis-cluster.tf"
module "redis_cluster" {
  source = "../../modules/cluster"

  terraform_state = {
    region = var.region
    bucket = var.bucket
  }

  name          = var.name
  instance_type = var.instance_type
  ami_id        = local.ami_id
}
EOF

cat <<EOF > "clusters/${name}/outputs.tf"
output "autoscaling_groups" {
  value = module.redis_cluster.autoscaling_groups
}

output "instance_type" {
  value = var.instance_type
}

output "ami" {
  value = {
    id = local.ami_id
  }
}
EOF

cat <<EOF > "clusters/${name}/README.md"
## Purpose
${name} redis cluster.

## Workspaces
This state is per-account.

## Usage
\`\`\`
${repo}\$ cicdctl terraform <init|plan|apply|destroy|output> redis/clusters/${name}:\${WORKSPACE}
...
\`\`\`
EOF
