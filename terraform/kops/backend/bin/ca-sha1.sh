#!/bin/bash

set -eu -o pipefail

#
# Shell script method of obtaining a root ca sha1 fingerprint
#
# https://github.com/hashicorp/terraform-provider-tls/issues/52
# https://www.terraform.io/docs/providers/external/data_source.html
#

# Set working directory to terraform/kops/backend/irsa
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../irsa" >/dev/null

uri=oidc-irsa-cicdenv-com.s3.amazonaws.com

root_ca_cert="/etc/ssl/certs/ca-cert-$(echo  \
| openssl s_client -servername "$uri"        \
    -showcerts -connect "${uri}:443" 2>&1    \
| grep 'depth='                              \
| head -n 1                                  \
| sed -e 's/.*CN = //'                       \
| tr ' ' '_'                                 \
).pem" || true

cat "$root_ca_cert"                 \
| openssl x509 -fingerprint -noout  \
| grep 'SHA1 Fingerprint='          \
| awk -F'=' '{print $2}'            \
| sed -e 's/://g'                   \
| tr 'A-Z' 'a-z'                    \
| tee oidc-ca.sha1

popd >/dev/null
