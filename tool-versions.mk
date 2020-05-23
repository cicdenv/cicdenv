# https://wiki.alpinelinux.org/wiki/Alpine_Linux:Releases
# https://hub.docker.com/_/alpine?tab=tags
ALPINE_TAG = 3.10

# Keybase is very rigid about versioning and server compat
# We'll checkout/build the same version you have installed on the host
_KEYBASE_FULL_VERSION = $(shell keybase version -S)
KEYBASE_TAG   = v$(shell echo "$(_KEYBASE_FULL_VERSION)" | awk -F- '{print $$1}')
KEYBASE_BUILD =  $(shell echo "$(_KEYBASE_FULL_VERSION)" | awk -F- '{print $$2}')

# Hashicorp config language command line parser/query tool
# https://github.com/mattolenik/hclq/releases
HCLQ_TAG = 0.5.3

# https://www.terraform.io/downloads.html
TERRAFORM_VERSION  = 0.12.25
TERRAFORM_SHA256   = e95daabd1985329f87e6d40ffe7b9b973ff0abc07a403f767e8658d64d733fb0
TERRAFORM_RELEASES = https://releases.hashicorp.com/terraform

# https://github.com/kubernetes/kops/releases
KOPS_VERSION   = 1.18.0-alpha.3
KOPS_SHA256    = 6f20fa215aae11517a2804a788f967c09a1868d9259fd00e39ca850867f6917b
KOPS_DOWNLOADS = https://github.com/kubernetes/kops/releases/download

# https://www.packer.io/downloads.html
PACKER_VERSION  = 1.5.6
PACKER_SHA256   = 2abb95dc3a5fcfb9bf10ced8e0dd51d2a9e6582a1de1cab8ccec650101c1f9df
PACKER_RELEASES = https://releases.hashicorp.com/packer

# https://github.com/kubernetes/kubernetes/releases
KUBE_VERSION   = 1.18.2
KUBE_SHA512    = ed36f49e19d8e0a98add7f10f981feda8e59d32a8cb41a3ac6abdfb2491b3b5b3b6e0b00087525aa8473ed07c0e8a171ad43f311ab041dcc40f72b36fa78af95
KUBE_DOWNLOADS = https://dl.k8s.io

# https://github.com/kubernetes-sigs/aws-iam-authenticator/releases
AUTHENTICATOR_VERSION = 0.5.0
AUTHENTICATOR_SHA256  = 4ccb4788d60ed76e3e6a161b56e1e7d91da1fcd82c98f935ca74c0c2fa81b7a6
AUTHENTICATOR_PROJECT = https://github.com/kubernetes-sigs/aws-iam-authenticator

# https://pkg.cfssl.org/
CFSSL_VERSION    = R1.2
CFSSL_SHA256     = eb34ab2179e0b67c29fd55f52422a94fe751527b06a403a79325fed7cf0145bd
CFSSLJSON_SHA256 = 1c9e628c3b86c3f2f8af56415d474c9ed4c8f9246630bd21c3418dbe5bf6401e
CFSSL_DOWNLOADS  = https://pkg.cfssl.org
