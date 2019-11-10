#!/bin/bash

set -eu -o pipefail

export DEBIAN_FRONTEND=noninteractive

# https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# ubuntu/bionic
vendor=$(. /etc/os-release; echo "$ID")
release=$(lsb_release -cs)

# https://download.docker.com/linux/ubuntu/gpg
curl -fsSL https://download.docker.com/linux/${vendor}/gpg | apt-key add -
apt-key fingerprint "0EBFCD88"
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/${vendor} ${release} stable"
apt-get update

apt-get install -y docker-ce docker-ce-cli containerd.io
systemctl start docker
