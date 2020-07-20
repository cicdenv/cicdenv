#!/bin/bash

set -eu -o pipefail

# Set working directory to ./terraform/mysql/
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

usage_message="

Usage $0 <name> <id> [terraform variable bindings]

Terraform variable bindings:  <var>=<value>
instance_type:
"

# MySQL unique group name, instance id
name=${1?"<name> required.${usage_message}"}; shift
id=${1?"<id> required.${usage_message}"}; shift

# Terraform variable bindings
declare -A tf_vars=(
    [instance_type]=i3en.xlarge
)
for binding in "$@"; do
    if [[ "$binding" != -* ]]; then
        var="${binding%%=*}"
        val="${binding#*=}"

        tf_vars["${var}"]="${val}"
    fi
done

#
# New state defaults
#
source "../bin/new-state-defaults.inc"

#
# MySQL instance state
#
source "bin/includes/instance.inc"
