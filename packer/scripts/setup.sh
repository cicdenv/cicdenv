#!/bin/bash

set -eu -o pipefail

sudo apt-get update
sudo apt-get clean
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
sudo apt-get update

xargs -a <(awk '! /^ *(#|$)/' "/tmp/packages.txt") -r -- \
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y

sudo snap install aws-cli --classic
sudo snap remove amazon-ssm-agent
