# https://wiki.alpinelinux.org/wiki/Alpine_Linux:Releases
# https://hub.docker.com/_/alpine?tab=tags
# https://alpinelinux.org/posts/Alpine-3.12.0-released.html
ALPINE_TAG = 3.12

# Keybase is very rigid about versioning and server compat
# We'll checkout/build the same version you have installed on the host
_KEYBASE_FULL_VERSION = $(shell keybase version -S)
KEYBASE_TAG   = v$(shell echo "$(_KEYBASE_FULL_VERSION)" | awk -F- '{print $$1}')
KEYBASE_BUILD =  $(shell echo "$(_KEYBASE_FULL_VERSION)" | awk -F- '{print $$2}')

# https://www.terraform.io/downloads.html
TERRAFORM_VERSION  = 0.13.3
TERRAFORM_RELEASES = https://releases.hashicorp.com/terraform

# https://github.com/kubernetes/kops/releases
# NOTE: node local dns is broken in '1.18.0-beta.1', so avoid
KOPS_VERSION   = 1.19.0-alpha.3
KOPS_SHA256    = b7364623c58c64f488e48ce9ea8f19f480f508987ae24f659b873c9a7d2bb4ff
KOPS_DOWNLOADS = https://github.com/kubernetes/kops/releases/download
#KOPS_DOWNLOADS = https://github.com/fred-vogt/kops/releases/download

# https://www.packer.io/downloads.html
PACKER_VERSION  = 1.6.2
PACKER_RELEASES = https://releases.hashicorp.com/packer

# https://github.com/kubernetes/kubernetes/releases
# https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-<version>.md (checksums)
KUBE_VERSION   = 1.19.2
KUBE_SHA512    = fe1aa1fa3d0c1a311d26159cb6b8acdc13d9201b647cc65b7bf2ac6e13400c07a0947fea479d1abd2da499809116dc64a1ee973ac33c81514d6d418f8bc6f5ac
KUBE_DOWNLOADS = https://dl.k8s.io

# https://github.com/kubernetes-sigs/aws-iam-authenticator/releases
AUTHENTICATOR_VERSION = 0.5.1
AUTHENTICATOR_SHA256  = afb16f35071c977554f1097cbb84ca4f38f9ce42142c8a0612716ae66bb9fdb9
AUTHENTICATOR_PROJECT = https://github.com/kubernetes-sigs/aws-iam-authenticator

# https://github.com/cloudflare/cfssl/releases/ (cfssl_*-checksums.txt)
CFSSL_VERSION    = 1.4.1
CFSSL_SHA256     = d01a26bc88851aab4c986e820e7b3885cedf1316a9c26a98fbba83105cfd7b87
CFSSLJSON_SHA256 = 05d67e05cacb8b2e78e737637acdcf9127b0732f0c4104403e9e9b74032fd685
CFSSL_DOWNLOADS  = https://github.com/cloudflare/cfssl/releases/download
