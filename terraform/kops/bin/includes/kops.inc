#!/bin/bash

# Relative to the kops/ folder
kops_component="clusters/${cluster_name}/kops"
mkdir -p "$kops_component"

cat <<EOF > "${kops_component}/terraform.tf"
terraform {
  required_version = ">= ${TERRAFORM_VERSION}"
  backend "s3" {
    key = "kops_clusters_${cluster_name}_kops/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
EOF

cat <<EOF > "${kops_component}/locals.tf"
locals {
  cluster_name         = "${cluster_name}"
  kubernetes_version   = "${tf_vars[kubernetes_version]}"
  master_instance_type = "${tf_vars[master_instance_type]}"
  master_volume_size   = "${tf_vars[master_volume_size]}"
  node_instance_type   = "${tf_vars[node_instance_type]}"
  node_volume_size     = "${tf_vars[node_volume_size]}"
  nodes_per_az         = ${tf_vars[nodes_per_az]}
}
EOF

cat <<'EOF' > "${kops_component}/kops_driver.tf"
module "kops_driver" {
  source = "../../../modules/driver"

  terraform_state = {
    region = var.region
    bucket = var.bucket
  }

  cluster_name = local.cluster_name

  cluster_settings = {
    kubernetes_version   = local.kubernetes_version
    master_instance_type = local.master_instance_type
    master_volume_size   = local.master_volume_size
    node_instance_type   = local.node_instance_type
    node_volume_size     = local.node_volume_size
    nodes_per_az         = local.nodes_per_az
  }

  ami_id = var.base_ami_id

  folders = {
    home_folder = "${path.module}/.."
    pki_folder  = "${path.module}/../../../backend/pki"
  }
}
EOF

cat <<'EOF' > "${kops_component}/outputs.tf"
output "cluster_name" {
  value = local.cluster_name
}

output "cluster_instance" {
  value = module.kops_driver.cluster_instance
}

output "cluster_fqdn" {
  value = module.kops_driver.cluster_fqdn
}

output "ami_id" {
    value = module.kops_driver.ami_id
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

cat <<'EOF' > "${kops_component}/providers.tf"
provider "aws" {
  region = var.target_region

  profile = "admin-${terraform.workspace}"
}
EOF

cat <<'EOF' > "${kops_component}/variables.tf"
variable "region"      {} # backend-config.tfvars
variable "bucket"      {} # backend-config.tfvars
variable "domain"      {} # domain.tfvars
variable "base_ami_id" {} # amis.tfvars

variable "target_region" {
  default = "us-west-2"
}
EOF

cat <<EOF > "${kops_component}/README.md"
## Purpose
One time bootstrap for a single account (workspace) KOPS kubernetes cluster.

## Workspaces
This state is per-account.

## Usage
\`\`\`
${repo}\$ cicdctl terraform <init|plan|apply|destroy|output> kops/${kops_component}:\${WORKSPACE}
...
\`\`\`
EOF
