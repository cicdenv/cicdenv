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
KOPS_VERSION   = 1.19.0-alpha.2-33722a9
KOPS_SHA256    = fadc3b5ae6dd05147a377757735127b9f51c2063cee7402eb8a4f42231a69c8f
#KOPS_DOWNLOADS = https://github.com/kubernetes/kops/releases/download
 KOPS_DOWNLOADS = https://github.com/fred-vogt/kops/releases/download

# https://www.packer.io/downloads.html
PACKER_VERSION  = 1.6.0
PACKER_RELEASES = https://releases.hashicorp.com/packer

# https://github.com/kubernetes/kubernetes/releases
# https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-<version>.md (checksums)
KUBE_VERSION   = 1.19.0-beta.2
KUBE_SHA512    = e2cc7819974316419a8973f0d77050b3262c4e8d078946ff9f6f013d052ec1dd82893313feff6e4493ae0fd3fb62310e6ce4de49ba6e80f8b9979650debf53f2
KUBE_DOWNLOADS = https://dl.k8s.io

# https://github.com/kubernetes-sigs/aws-iam-authenticator/releases
AUTHENTICATOR_VERSION = 0.5.1
AUTHENTICATOR_SHA256  = afb16f35071c977554f1097cbb84ca4f38f9ce42142c8a0612716ae66bb9fdb9
AUTHENTICATOR_PROJECT = https://github.com/kubernetes-sigs/aws-iam-authenticator

# https://pkg.cfssl.org/
CFSSL_VERSION    = R1.2
CFSSL_SHA256     = eb34ab2179e0b67c29fd55f52422a94fe751527b06a403a79325fed7cf0145bd
CFSSLJSON_SHA256 = 1c9e628c3b86c3f2f8af56415d474c9ed4c8f9246630bd21c3418dbe5bf6401e
CFSSL_DOWNLOADS  = https://pkg.cfssl.org
