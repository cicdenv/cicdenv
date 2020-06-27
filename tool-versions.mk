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
TERRAFORM_VERSION  = 0.12.28
TERRAFORM_RELEASES = https://releases.hashicorp.com/terraform

# https://github.com/kubernetes/kops/releases
# NOTE: node local dns is broken in '1.18.0-beta.1', so avoid
KOPS_VERSION   = 1.18.0-beta.2-6309b96
KOPS_SHA256    = 05e8c81a185473c91669ed47b2762a8af4393e066cf1b8a197460aec3bc57f7a
#KOPS_DOWNLOADS = https://github.com/kubernetes/kops/releases/download
 KOPS_DOWNLOADS = https://github.com/fred-vogt/kops/releases/download

# https://www.packer.io/downloads.html
PACKER_VERSION  = 1.6.0
PACKER_RELEASES = https://releases.hashicorp.com/packer

# https://github.com/kubernetes/kubernetes/releases
KUBE_VERSION   = 1.18.3
KUBE_SHA512    = cfcb89a706eb8ddc7aa8225e3f0eb76a0d973faa1c82b1bec0a457cd8b44b7bd5c154b7ed1f7cdabfdee84af8a33fd7fff83970a6ee5a97d661a806b69da968b
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
