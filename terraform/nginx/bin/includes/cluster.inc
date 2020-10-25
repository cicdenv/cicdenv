#!/bin/bash

mkdir -p "clusters/${name}"

cat <<EOF > "clusters/${name}/terraform.tf"
terraform {
  required_version = ">= ${TERRAFORM_VERSION}"
  backend "s3" {
    key = "nginx_clusters_${name}/terraform.tfstate"

    workspace_key_prefix = "state"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
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

variable "instance_type" {
  default = "${tf_vars[instance_type]}"
}
EOF

cat <<EOF > "clusters/${name}/README.md"
## Purpose
${name} nginx service resources.

## Workspaces
This state is per-account.

## Usage
\`\`\`
${repo}\$ cicdctl terraform <init|plan|apply|destroy|output> nginx/clusters/${name}:\${WORKSPACE}
...
\`\`\`
EOF

cat <<EOF > "clusters/${name}/nginx.tf"
module "nginx_cluster" {
  source = "../../modules/cluster"

  terraform_state = {
    region = var.region
    bucket = var.bucket
  }
  
  ami_id = local.ami_id
  
  name = "${name}"

  instance_type = var.instance_type
}
EOF

cat <<EOF > "clusters/${name}/outputs.tf"
output "url" {
  value = module.nginx_cluster.url
}

output "autoscaling_group" {
  value = module.nginx_cluster.autoscaling_group
}

output "ami" {
  value = {
    id = local.ami_id
  }
}
EOF
