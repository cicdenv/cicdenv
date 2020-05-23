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
}
EOF

cat <<'EOF' > "${external_access_state}/external-access.tf"
module "kops_external_access" {
  source = "../../../modules/kops-external-access"

  region = var.region
  bucket = var.bucket

  target_region = var.target_region

  cluster_short_name = var.cluster_short_name

  providers = {
    aws.main = aws.main
  }
}
EOF

cat <<'EOF' > "${external_access_state}/outputs.tf"
output "lb_dns_name" {
  value = module.kops_external_access.lb_dns_name
}

output "lb_zone_id" {
  value = module.kops_external_access.lb_zone_id
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

variable "whitelisted_cidr_blocks" {  # whitelisted-networks.tfvars
  type = list
}

variable "target_region" {
  default = "us-west-2"
}

variable "cluster_short_name" {
  default = "${cluster_name}"
}
EOF

cat <<EOF > "${external_access_state}/README.md"
## Purpose
Creates external API server access for a single account (workspace) KOPS kubernetes external-access.

## Workspaces
This state is per-account.

## Usage
\`\`\`
${repo}\$ cicdctl terraform <init|plan|apply|destroy|output> kops/${external_access_state}:\${WORKSPACE}
...
\`\`\`
EOF
