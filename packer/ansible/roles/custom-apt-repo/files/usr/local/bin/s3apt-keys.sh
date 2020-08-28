#!/bin/bash

set -eu -o pipefail

curl -sL https://apt-repo-cicdenv-com.s3-us-west-2.amazonaws.com/repo/dists/key.asc | apt-key add -
