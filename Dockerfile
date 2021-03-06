ARG tag

#
# https://github.com/keybase/client/tree/master/go/
#
FROM golang:1-alpine as keybase-builder
ARG keybase_version
ARG keybase_build
RUN apk add --no-cache git build-base
RUN go get -v -d github.com/keybase/client/go/keybase
RUN (cd /go/src/github.com/keybase/client; git checkout -b builder ${keybase_version})
RUN go get -v github.com/keybase/client/go/keybase
RUN go install -tags production \
               -ldflags "-s -w -X github.com/keybase/client/go/libkb.PrereleaseBuild=${keybase_build}" \
               github.com/keybase/client/go/keybase


#
# https://github.com/mattolenik/hclq
#
FROM golang:1-alpine as hclq-builder
ARG hclq_version
RUN apk add --no-cache git build-base
RUN go get -v -d github.com/mattolenik/hclq
RUN (cd /go/src/github.com/mattolenik/hclq; git checkout -b builder ${hclq_version})
RUN go get -v github.com/mattolenik/hclq
RUN go install github.com/mattolenik/hclq

FROM alpine:${tag}

LABEL role="tools"  \
      team="infra"

# Setup non-root user
ARG nonroot_user
ARG nonroot_uid

RUN adduser -D -u ${nonroot_uid} -S ${nonroot_user}  \
        --home /home/terraform                       \
 && addgroup -g ${nonroot_uid} -S terraform          \
 && addgroup ${nonroot_user} terraform               \
 && ln -s /home/terraform /home/${nonroot_user}

# Allow non-root user to access docker socket
ARG docker_group=docker
ARG docker_gid

# Handle docker socket host/container group permissions
RUN if [[ "${docker_gid}" == "0" ]]; then         \
    addgroup ${nonroot_user} root;                \
else                                              \
    sed -i "s/${docker_gid}/99/" /etc/group       \
 && addgroup -g ${docker_gid} -S ${docker_group}  \
 && addgroup ${nonroot_user} ${docker_group}      \
; fi

# Docker client
RUN apk --no-cache --update add docker

# Utils
RUN apk --no-cache --update add  \
    bash                         \
    bind-tools                   \
    build-base                   \
    cloc                         \
    curl                         \
    less                         \
    git                          \
    gnupg                        \
    groff                        \
    jq                           \
    make                         \
    netcat-openbsd               \
    openssh                      \
    openssl                      \
    parallel                     \
    socat                        \
    sudo                         \
    tzdata                       \
    vim                          \
    wireguard-tools              \
    yaml                         \
    zip

# Turn off parallel citation messages
RUN mkdir -p "/home/terraform/.parallel" \
 && touch "/home/terraform/.parallel/will-cite"

# Allow su to root
RUN echo "${nonroot_user} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${nonroot_user}" \
 && chmod 0440 "/etc/sudoers.d/${nonroot_user}"

# Time based one time passwords
RUN apk --no-cache add --update \
    oath-toolkit-oathtool
RUN apk --no-cache add --update -X http://dl-cdn.alpinelinux.org/alpine/edge/community \
    zbar

# Custom built keybase (exact version match to with host)
COPY --from=keybase-builder /go/bin/keybase /usr/bin

# Custom built HCL command line parser tool
COPY --from=hclq-builder /go/bin/hclq /usr/local/bin

# Install latest Python 3.7+
RUN apk --no-cache --update add                                                      \
    python3                                                                          \
    python3-dev                                                                      \
    libffi-dev                                                                       \
    openssl-dev                                                                      \
 && python3 -m ensurepip                                                             \
 && pip3 install --upgrade pip setuptools                                            \
 && if [[ ! -e /usr/bin/pip    ]]; then ln -s pip3 /usr/bin/pip ; fi                 \
 && if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi  \
 && rm -r /root/.cache                                                               \
 && pip install --no-cache-dir --upgrade pip

# Install python based tools (awscli, aws-mfa, timezone libs)
RUN apk --no-cache --update add \
    rust \
    cargo
COPY requirements.txt /tmp
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Hashicorp signing key
RUN curl -sl https://keybase.io/hashicorp/pgp_keys.asc | gpg --import

# Terraform cli
ARG terraform_version
ARG terraform_sha256
ARG terraform_releases
RUN for item in linux_amd64.zip SHA256SUMS SHA256SUMS.sig; do                        \
        file="terraform_${terraform_version}_${item}";                               \
        curl -o "${file}" -sL "${terraform_releases}/${terraform_version}/${file}";  \
    done                                                                             \
&&  gpg --verify terraform_${terraform_version}_SHA256SUMS.sig terraform_${terraform_version}_SHA256SUMS               \
&&  grep "terraform_${terraform_version}_linux_amd64.zip" "terraform_${terraform_version}_SHA256SUMS" | sha256sum -c - \
&&  unzip "terraform_${terraform_version}_linux_amd64.zip" -d /bin  \
&&  for item in linux_amd64.zip SHA256SUMS SHA256SUMS.sig; do       \
        file="terraform_${terraform_version}_${item}";              \
        rm -f "${file}";  \
    done

# Hashicorp packer cli
ARG packer_version
ARG packer_sha256
ARG packer_releases
RUN for item in linux_amd64.zip SHA256SUMS SHA256SUMS.sig; do                  \
        file="packer_${packer_version}_${item}";                               \
        curl -o "${file}" -sL "${packer_releases}/${packer_version}/${file}";  \
    done                                                                       \
&&  gpg --verify "packer_${packer_version}_SHA256SUMS.sig" "packer_${packer_version}_SHA256SUMS"           \
&&  grep "packer_${packer_version}_linux_amd64.zip" "packer_${packer_version}_SHA256SUMS" | sha256sum -c - \
&&  unzip "packer_${packer_version}_linux_amd64.zip" -d /bin   \
&&  for item in linux_amd64.zip SHA256SUMS SHA256SUMS.sig; do  \
        file="packer_${packer_version}_${item}";               \
        rm -f "${file}";                                       \
    done

# Kops cli
ARG kops_version
ARG kops_sha256
ARG kops_downloads
RUN curl -o /bin/kops -sL "${kops_downloads}/v$(python -c 'import urllib.parse; print(urllib.parse.quote("'${kops_version}'"))')/kops-linux-amd64"  \
 && echo "${kops_sha256}  /bin/kops" | sha256sum -c - \
 && chmod +x /bin/kops

# Kubectl
ARG kube_version
ARG kube_sha512
ARG kube_downloads
RUN curl -o kubernetes-client-linux-amd64.tar.gz                                                              \
         -sL ${kube_downloads}/v${kube_version}/kubernetes-client-linux-amd64.tar.gz                          \
 && echo "${kube_sha512}  kubernetes-client-linux-amd64.tar.gz" | sha512sum -c -                              \
 && tar -xzf kubernetes-client-linux-amd64.tar.gz kubernetes/client/bin/kubectl -C /bin --strip-components=3  \
 && chmod +x /bin/kubectl                                                                                     \
 && rm kubernetes-client-linux-amd64.tar.gz

# Kubernetes kubectl aws-iam-authenticator plugin
ARG authenticator_version
ARG authenticator_sha256
ARG authenticator_project
RUN curl -o /bin/aws-iam-authenticator                                                                                                        \
         -sL ${authenticator_project}/releases/download/v${authenticator_version}/aws-iam-authenticator_${authenticator_version}_linux_amd64  \
 && echo "${authenticator_sha256}  /bin/aws-iam-authenticator" | sha256sum -c -                                                               \
 && chmod +x /bin/aws-iam-authenticator

# CloudFlare SSL tooling
ARG cfssl_version
ARG cfssl_sha256
ARG cfssljson_sha256
ARG cfssl_downloads
RUN curl -o /bin/cfssl                                                             \
    -sL "${cfssl_downloads}/v${cfssl_version}/cfssl_${cfssl_version}_linux_amd64"  \
 && echo "${cfssl_sha256}  /bin/cfssl" | sha256sum -c -                            \
 && chmod +x /bin/cfssl
RUN curl -o /bin/cfssljson                                                             \
    -sL "${cfssl_downloads}/v${cfssl_version}/cfssljson_${cfssl_version}_linux_amd64"  \
 && echo "${cfssljson_sha256}  /bin/cfssljson" | sha256sum -c -                        \
 && chmod +x /bin/cfssljson

# Install OpenJDK 11 (keytool)
RUN apk --no-cache --update add openjdk11

# websocat for testing websocket services
RUN apk --no-cache add --update -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    websocat

ENTRYPOINT []
CMD []
