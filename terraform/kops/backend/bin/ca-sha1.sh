#!/bin/bash

set -eu -o pipefail

# Set working directory to terraform/kops/backend/pki
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../irsa" >/dev/null

uri=oidc-irsa-cicdenv-com.s3.amazonaws.com

echo \
| openssl s_client -servername "${uri}" -showcerts -connect "${uri}:443" \
| openssl x509 -fingerprint -noout \
| grep 'SHA1 Fingerprint=' \
| awk -F'=' '{print $2}' \
| sed -e 's/://g' \
| tr 'A-Z' 'a-z' \
> oidc-ca.sha1

popd >/dev/null
