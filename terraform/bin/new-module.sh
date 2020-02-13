#!/bin/bash

set -eu -o pipefail

# Set working directory to the project root folder
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../.." >/dev/null

new_module=${1?Use $0 <path> \# NOTE: path is the relative folder under terraform/}
module_dir="terraform/${new_module}"
mkdir -p "${module_dir}"

if [[ ! -f "${module_dir}/locals.tf" ]]; then
    cat <<'EOF' > "${module_dir}/locals.tf"
locals {
}
EOF
fi

for optional_file in imports.tf includes.tf outputs.tf; do
    if [[ ! -f "${module_dir}/${optional_file}" ]]; then
        > "${module_dir}/${optional_file}"
    fi
done

if [[ ! -f "${module_dir}/variables.tf" ]]; then
    cat <<EOF > "${module_dir}/variables.tf"
EOF
fi

if [[ ! -f "${module_dir}/README.md" ]]; then
    cat <<EOF > "${module_dir}/README.md"
## Purpose
...
EOF
fi

popd >/dev/null
