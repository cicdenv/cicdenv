#!/bin/bash

set -eu -o pipefail

# project root folder
pushd "$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)/../.." >/dev/null

TERRAFORM_VERSION=$(grep 'TERRAFORM_VERSION' "tool-versions.mk" | awk '{print $NF}')

repo=$(git config --get remote.origin.url | sed -E 's!.*/([^.]+).git$!\1!')

popd >/dev/null
