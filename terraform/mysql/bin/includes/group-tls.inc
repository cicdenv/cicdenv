#!/bin/bash

mkdir -p "groups/${name}/tls"

cat <<EOF > "groups/${name}/tls/terraform.tf"
terraform {
  required_version = ">= ${TERRAFORM_VERSION}"
  backend "s3" {
    key = "mysql_groups_${name}_tls/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
EOF

cat <<'EOF' > "groups/${name}/tls/providers.tf"
provider "aws" {
  region = var.target_region

  profile = "admin-${terraform.workspace}"
}

provider "acme" {
  # https://letsencrypt.org/docs/acme-protocol-updates/
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}
EOF

cat <<EOF > "groups/${name}/tls/variables.tf"
variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars
variable "domain" {} # domain.tfvars

variable "target_region" {
  default = "us-west-2"
}
EOF

cat <<EOF > "groups/${name}/tls/README.md"
## Purpose
${name} MySQL service group resources.

## Workspaces
This state is per-account.

## Usage
\`\`\`
${repo}\$ cicdctl terraform <init|plan|apply|destroy|output> mysql/groups/${name}/tls:\${WORKSPACE}
...
\`\`\`
EOF

cat <<EOF > "groups/${name}/tls/mysql.tf"
module "mysql_group_tls" {
  source = "../../../modules/group/tls"

  terraform_state = {
    region = var.region
    bucket = var.bucket
  }
  
  name = "${name}"
}
EOF

cat <<EOF > "groups/${name}/tls/outputs.tf"
output "acme" {
  value = module.mysql_group_tls.acme
}
EOF
