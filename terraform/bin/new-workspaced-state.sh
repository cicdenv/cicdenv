#!/bin/bash

set -eu -o pipefail

# Set working directory to the project root folder
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../.." >/dev/null

source "terraform/bin/new-state-defaults.inc"

new_state=${1?Use $0 <path> \# NOTE: path is the relative folder under terraform/}
state_dir="terraform/${new_state}"
mkdir -p "${state_dir}"

if [[ ! -f "${state_dir}/terraform.tf" ]]; then
    cat <<EOF > "${state_dir}/terraform.tf"
terraform {
  required_version = ">= ${TERRAFORM_VERSION}"
  backend "s3" {
    key = "${new_state//\//_}/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
EOF
fi

if [[ ! -f "${state_dir}/locals.tf" ]]; then
    cat <<'EOF' > "${state_dir}/locals.tf"
locals {
}
EOF
fi

for optional_file in imports.tf includes.tf outputs.tf; do
    if [[ ! -f "${state_dir}/${optional_file}" ]]; then
        > "${state_dir}/${optional_file}"
    fi
done

if [[ ! -f "${state_dir}/providers.tf" ]]; then
    cat <<'EOF' > "${state_dir}/providers.tf"
provider "aws" {
  region = var.target_region

  profile = "admin-${terraform.workspace}"
}
EOF
fi

if [[ ! -f "${state_dir}/variables.tf" ]]; then
    cat <<EOF > "${state_dir}/variables.tf"
variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars

variable "target_region" {
  default = "us-west-2"
}
EOF
fi

if [[ ! -f "${state_dir}/README.md" ]]; then
    cat <<EOF > "${state_dir}/README.md"
## Purpose
...

## Workspaces
This state is per-account.

## Usage
\`\`\`bash
${repo}\$ cicdctl terraform <init|plan|apply|destroy> ${new_state}:\${WORKSPACE}
...
\`\`\`
EOF
fi

popd >/dev/null
