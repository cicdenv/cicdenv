#!/bin/bash

set -eu -o pipefail

docker run --rm -it --network host --entrypoint /usr/local/bin/redis-cli redis "$@"
