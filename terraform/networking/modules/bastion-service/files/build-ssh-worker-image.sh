#!/bin/bash

set -eu -o pipefail

# Need this to access our internal s3 apt-repo
cp /usr/lib/apt/methods/s3 /root
cat <<'EOF' > /root/.dockerignore
*
!s3
EOF

docker build -t sshd-worker -f /root/Dockerfile /root
