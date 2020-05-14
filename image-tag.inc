#!/bin/bash

set -eu -o pipefail

# project root folder
pushd "$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)" >/dev/null

# Ugh, macs
if [[ "$OSTYPE" == "darwin"* ]]; then
    md5sum=md5
fi

# Project files that define the cicdenv environment container
# NOTE: we ignore comment lines, blank lines, trailing comments
image_tag=$(cat              \
      Dockerfile             \
      requirements.txt       \
      tool-versions.mk       \
      <(keybase version -S)  \
| sed -e '/^\s*#.*$/d'       \
      -e '/^$/d'             \
      -e 's/\s*#.*$//'       \
| ${md5sum-md5sum} | awk '{print $1}' | cut -c1-7)

popd >/dev/null
