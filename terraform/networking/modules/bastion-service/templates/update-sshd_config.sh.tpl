#!/bin/bash

set -eu -o pipefail

# Configure host sshd to run on port a non-standard port
sed -i 's/^#Port 22/Port ${host_ssh_port}/' /etc/ssh/sshd_config
systemctl restart sshd.service
systemctl enable sshd-worker.socket
systemctl start sshd-worker.socket
systemctl daemon-reload

# Set 'host' hostname to match dns
hostnamectl set-hostname ${host_name}
