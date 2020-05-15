#!/bin/bash

set -eu -o pipefail

# Set working directory to the project root folder
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../.." >/dev/null

source "terraform/bin/new-state-defaults.inc"

new_state=${1?Use $0 <path> \# NOTE: path is the relative folder under terraform/}
state_dir="terraform/${new_state}"
mkdir -p "${state_dir}"

if [[ ! -f "${state_dir}/backend.tf" ]]; then
    cat <<EOF > "${state_dir}/backend.tf"
terraform {
  required_version = ">= ${TERRAFORM_VERSION}"
  backend "s3" {
    key = "state/main/${new_state//\//-}/terraform.tfstate"
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
  region = var.region
  
  profile = "admin-main"
}
EOF
fi

if [[ ! -f "${state_dir}/variables.tf" ]]; then
    cat <<EOF > "${state_dir}/variables.tf"
variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars
EOF
fi

if [[ ! -f "${state_dir}/README.md" ]]; then
    cat <<EOF > "${state_dir}/README.md"
## Purpose
...

## Workspaces
N/A.

## Usage
\`\`\`bash
${repo}\$ cicdctl terraform <init|plan|apply|destroy> ${new_state}:main
...
\`\`\`
EOF
fi

popd >/dev/null
