#!/bin/bash

set -eu -o pipefail

# Set working directory to ./terraform/jenkins/
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/.." >/dev/null

usage_message="

Usage $0 <name> <type> [terraform variable bindings]

Supported <type> values:
colocated
distributed

Terraform variable bindings:  <var>:<value>
instance_type:
executors:

server_instance_type:
agent_instance_type:
agent_count:
executors:
"

# Jenkins unique instance name / agent type
name=${1?"<name> required.${usage_message}"}; shift
type=${1?"<type> required.${usage_message}"}; shift

# Terraform variable bindings
case "${type}" in
colocated)
    declare -A tf_vars=(
        [instance_type]=m5dn.xlarge
        [executors]=2
    )
    ;;
distributed)
    declare -A tf_vars=(
        [server_instance_type]=m5dn.large
        [agent_instance_type]=z1d.large
        [agent_count]=3
        [executors]=2
    )
    ;;
*)
    echo "unsupported [type] value: '${type}'"
    echo
    echo "$usage_message" >&2
    exit 1
    ;;
esac
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
# Jenkins instance state
#
source "bin/includes/common.inc"
source "bin/includes/${type}-instance.inc"
