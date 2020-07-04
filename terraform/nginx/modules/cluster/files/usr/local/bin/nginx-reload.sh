#!/bin/bash

set -eux -o pipefail

# docker kill -s HUP nginx
docker exec "nginx" nginx -s reload
