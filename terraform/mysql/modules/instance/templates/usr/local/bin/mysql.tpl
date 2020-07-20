#!/bin/bash

set -eu -o pipefail

docker run --rm --init                      \
    --network=mysql                         \
    --volume "/root/.my.cnf:/root/.my.cnf"  \
    mysql:${image_tag}                      \
    mysql "$@"
