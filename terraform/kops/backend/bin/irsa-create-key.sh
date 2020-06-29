#!/bin/bash

set -eu -o pipefail

# Set working directory to terraform/kops/backend/irsa
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../irsa" >/dev/null

# https://github.com/aws/amazon-eks-pod-identity-webhook/blob/master/hack/self-hosted/main.go
jwks_driver="${DIR}/../../../shared/ecr-images/pod-identity-webhook/amazon-eks-pod-identity-webhook/hack/self-hosted/main.go"

if [[ ! -f irsa-key.pub || -f irsa-key ]]; then
    ssh-keygen -t rsa -b 2048 -f irsa-key -m pem -q -N "" 0>&-
    ssh-keygen -e -m PKCS8 -f irsa-key.pub > irsa-pkcs8.pub
    
    docker run -it                                      \
        -v "${jwks_driver}:/main.go:ro"                 \
        -v "${PWD}/irsa-pkcs8.pub:/irsa-pkcs8.pub:ro"   \
        golang                                          \
            bash -c '\
            go get "github.com/pkg/errors"; \
            go get "gopkg.in/square/go-jose.v2"; \
            go run /main.go -key /irsa-pkcs8.pub'       \
        | jq '.keys += [.keys[0]] | .keys[1].kid = ""'  \
        > jwks.json
    
    rm -f irsa-key.enc
fi

popd >/dev/null
