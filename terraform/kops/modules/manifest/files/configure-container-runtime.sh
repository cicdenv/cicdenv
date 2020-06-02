#!/bin/bash

set -eu -o pipefail

#
# ContainerD settings
#
cat <<EOF > /etc/containerd/custom-config.toml
disabled_plugins = ["cri"]
EOF

#
# ContainerD systemd drop-in(s)
#
mkdir -p /etc/systemd/system/containerd.service.d
cat <<'EOF' > /etc/systemd/system/containerd.service.d/10-overrides.conf
[Unit]
After=network.target local-fs.target

[Service]
EnvironmentFile=/etc/environment
Environment=CONTAINERD_OPTS=--log-level=info
ExecStart=
ExecStart=/usr/bin/containerd -c /etc/containerd/custom-config.toml "$CONTAINERD_OPTS"
Restart=always
RestartSec=5
OOMScoreAdjust=-999
LimitNOFILE=infinity
EOF

#
# Docker systemd drop-in(s)
#
mkdir -p /etc/systemd/system/docker.service.d
cat <<'EOF' > /etc/systemd/system/docker.service.d/10-overrides.conf
[Service]
Environment='DOCKER_OPTS=\
--ip-masq=false            \
--iptables=false           \
--log-driver=json-file     \
--log-level=warn           \
--log-opt=max-file=5       \
--log-opt=max-size=10m     \
--storage-driver=overlay2  \
'
Environment=DOCKER_NOFILE=1000000
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock "$DOCKER_OPTS"

StartLimitInterval=0
EOF


# Apply changes
systemctl daemon-reload
systemctl restart containerd
systemctl restart docker

# Confirm drop-ins
systemd-delta --type=extended | egrep 'containerd|docker'
