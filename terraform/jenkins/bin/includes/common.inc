#!/bin/bash

mkdir -p "instances/${instance_name}"

cat <<EOF > "instances/${instance_name}/backend.tf"
terraform {
  required_version = ">= ${TERRAFORM_VERSION}"
  backend "s3" {
    key = "jenkins-instances-${instance_name}/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
EOF

cat <<'EOF' > "instances/${instance_name}/providers.tf"
provider "aws" {
  region = var.target_region

  profile = "admin-${terraform.workspace}"
}
EOF

cat <<'EOF' > "instances/${instance_name}/variables.tf"
variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars

variable "target_region" {
  default = "us-west-2"
}
EOF

cat <<EOF > "instances/${instance_name}/README.md"
## Purpose
${instance_name} Jenkins service resources.

## Workspaces
This state is per-account.

## Usage
\`\`\`
${repo}\$ cicdctl <init|plan|apply|destroy|output> jenkins/instances/${instance_name}:\${WORKSPACE}
...
\`\`\`
EOF
