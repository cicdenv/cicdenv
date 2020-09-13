#!/bin/bash

# Relative to the kops/ folder
external_access_state="clusters/${cluster_name}/external-access"
mkdir -p "$external_access_state"

cat <<EOF > "${external_access_state}/terraform.tf"
terraform {
  required_version = ">= ${TERRAFORM_VERSION}"
  backend "s3" {
    key = "kops_clusters_${cluster_name}_external-access/terraform.tfstate"

    workspace_key_prefix = "state"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
EOF

cat <<EOF > "${external_access_state}/locals.tf"
locals {
  cluster_name = "${cluster_name}"
}
EOF

cat <<'EOF' > "${external_access_state}/external-access.tf"
module "kops_external_access" {
  source = "../../../modules/external-access"

  terraform_state = {
    region = var.region
    bucket = var.bucket
  }

  cluster_name = local.cluster_name
}
EOF

cat <<'EOF' > "${external_access_state}/outputs.tf"
output "external_lb" {
  value = module.kops_external_access.external_lb
}
EOF

cat <<'EOF' > "${external_access_state}/providers.tf"
provider "aws" {
  region = var.region
  
  alias = "main"
  profile = "admin-main"
}

provider "aws" {
  region = var.target_region

  profile = "admin-${terraform.workspace}"
}
EOF

cat <<EOF > "${external_access_state}/variables.tf"
variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars

variable "target_region" {
  default = "us-west-2"
}
EOF

cat <<EOF > "${external_access_state}/README.md"
## Purpose
Creates external API server access for a single account (workspace) KOPS kubernetes.

## Workspaces
This state is per-account.

## Usage
\`\`\`
${repo}\$ cicdctl terraform <init|plan|apply|destroy|output> kops/${external_access_state}:\${WORKSPACE}
...
\`\`\`
EOF
