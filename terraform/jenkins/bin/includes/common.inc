#!/bin/bash

mkdir -p "instances/${name}"

cat <<EOF > "instances/${name}/terraform.tf"
terraform {
  required_version = ">= ${TERRAFORM_VERSION}"
  backend "s3" {
    key = "jenkins_instances_${name}/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
EOF

cat <<'EOF' > "instances/${name}/providers.tf"
provider "aws" {
  region = var.target_region

  profile = "admin-${terraform.workspace}"
}
EOF

cat <<'EOF' > "instances/${name}/imports.tf"
data "terraform_remote_state" "amis" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared_packer/terraform.tfstate"
    region = var.region
  }
}
EOF

cat <<'EOF' > "instances/${name}/locals.tf"
locals {
  ami_id = var.base_ami_id != "" ? var.base_ami_id : data.terraform_remote_state.amis.outputs.base_amis["zfs"].id
}
EOF

cat <<'EOF' > "instances/${name}/variables.tf"
variable "region"      {} # backend-config.tfvars
variable "bucket"      {} # backend-config.tfvars
variable "base_ami_id" {} # amis.tfvars

variable "target_region" {
  default = "us-west-2"
}
EOF

cat <<EOF > "instances/${name}/README.md"
## Purpose
${name} Jenkins service resources.

## Workspaces
This state is per-account.

## Usage
\`\`\`
${repo}\$ cicdctl terraform <init|plan|apply|destroy|output> jenkins/instances/${name}:\${WORKSPACE}
...
\`\`\`
EOF
