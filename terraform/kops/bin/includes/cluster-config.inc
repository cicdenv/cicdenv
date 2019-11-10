#!/bin/bash

# Relative to the kops/ folder
cluster_config_state="clusters/${cluster_name}/cluster-config"
mkdir -p "$cluster_config_state"

cat <<EOF > "${cluster_config_state}/backend.tf"
terraform {
  required_version = ">= ${TERRAFORM_VERSION}"
  backend "s3" {
    key = "kops-clusters-${cluster_name}-cluster-config/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
EOF

cat <<EOF > "${cluster_config_state}/locals.tf"
locals {
  kubernetes_version = "${kubernetes_version}"

  cluster_short_name = "${cluster_name}-\${terraform.workspace}"
}
EOF

cat <<'EOF' > "${cluster_config_state}/kops_driver.tf"
module "kops_driver" {
  source = "../../../modules/kops-driver"

  region = var.region
  bucket = var.bucket
  domain = var.domain

  cluster_short_name = local.cluster_short_name
  kubernetes_version = local.kubernetes_version

  cluster_home = "${path.module}/.."
  
  pki_folder = "${path.module}/../../../backend/pki"
}
EOF

cat <<'EOF' > "${cluster_config_state}/outputs.tf"
output "cluster_short_name" {
  value = local.cluster_short_name
}

output "cluster_name" {
  value = module.kops_driver.cluster_name
}

output "image_id" {
    value = module.kops_driver.ami
}

output "kops_export_kubecfg_command" {
  value = module.kops_driver.export_kubecfg_command
}

output "kops_update_command" {
  value = module.kops_driver.update_command
}

output "kops_rolling_update_command" {
  value = module.kops_driver.rolling_update_command
}

output "kops_replace_command" {
  value = module.kops_driver.replace_command
}

output "kops_validate_command" {
  value = module.kops_driver.validate_command
}

output "kops_delete_command" {
  value = module.kops_driver.delete_command
}
EOF

cat <<'EOF' > "${cluster_config_state}/providers.tf"
provider "aws" {
  region = var.target_region

  profile = "admin-${terraform.workspace}"
}
EOF

cat <<'EOF' > "${cluster_config_state}/variables.tf"
variable "region"      {} # backend-config.tfvars
variable "bucket"      {} # backend-config.tfvars
variable "domain"      {} # domain.tfvars

variable "target_region" {
  default = "us-west-2"
}
EOF

cat <<EOF > "${cluster_config_state}/README.md"
## Purpose
One time bootstrap for a single account (workspace) KOPS kubernetes cluster.

## Workspaces
This state is per-account.

## Usage
\`\`\`
${repo}\$ cicdctl <init|plan|apply|destroy|output> kops/${cluster_config_state}:\${WORKSPACE}
...
\`\`\`
EOF
