#!/bin/bash

mkdir -p "groups/${name}"

cat <<EOF > "groups/${name}/terraform.tf"
terraform {
  required_version = ">= ${TERRAFORM_VERSION}"
  backend "s3" {
    key = "mysql_groups_${name}/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
EOF

cat <<'EOF' > "groups/${name}/providers.tf"
provider "aws" {
  region = var.target_region

  profile = "admin-${terraform.workspace}"
}
EOF

cat <<EOF > "groups/${name}/variables.tf"
variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars

variable "target_region" {
  default = "us-west-2"
}
EOF

cat <<EOF > "groups/${name}/README.md"
## Purpose
${name} MySQL service group resources.

## Workspaces
This state is per-account.

## Usage
\`\`\`
${repo}\$ cicdctl terraform <init|plan|apply|destroy|output> mysql/groups/${name}:\${WORKSPACE}
...
\`\`\`
EOF

cat <<EOF > "groups/${name}/mysql.tf"
module "mysql_group" {
  source = "../../modules/group"

  terraform_state = {
    region = var.region
    bucket = var.bucket
  }
  
  name = "${name}"
}
EOF

cat <<EOF > "groups/${name}/outputs.tf"
output "iam" {
  value = module.mysql_group.iam
}

output "security_groups" {
  value = module.mysql_group.security_groups
}

output "secrets" {
  value = module.mysql_group.secrets
}
EOF
