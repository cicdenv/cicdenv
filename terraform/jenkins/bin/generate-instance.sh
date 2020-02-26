#!/bin/bash

set -eu -o pipefail

# Set working directory to ./terraform/jenkins/
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

usage_message="

Usage $0 <instance-name> <instance-type>

Supported [instance-type] values:
colocated
distributed"

# Jenkins unique instance name
instance_name=${1?"<instance-name> required.""${usage_message}"}
instance_type=${2?"<instance-type> required.""${usage_message}"}

#
# New state defaults
#
source "../bin/new-state-defaults.inc"

#
# Jenkins instance state
#
source "bin/includes/common.inc"
source "bin/includes/${instance_type}-instance.inc"
