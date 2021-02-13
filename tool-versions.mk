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
TERRAFORM_VERSION  = 0.13.6
TERRAFORM_RELEASES = https://releases.hashicorp.com/terraform

# https://github.com/kubernetes/kops/releases
KOPS_VERSION   = 1.20.0-alpha.2
KOPS_SHA256    = 56f48d9d1a6a347b568e9bcd491fb2fc87f46c2b44336e974d7eabba337a1a74
KOPS_DOWNLOADS = https://github.com/kubernetes/kops/releases/download
#KOPS_DOWNLOADS = https://github.com/fred-vogt/kops/releases/download

# https://www.packer.io/downloads.html
PACKER_VERSION  = 1.6.6
PACKER_RELEASES = https://releases.hashicorp.com/packer

# https://github.com/kubernetes/kubernetes/releases
# https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-<version>.md (checksums)
KUBE_VERSION   = 1.20.2
KUBE_SHA512    = e4513cdd65ed980d493259cc7eaa63c415f97516db2ea45fa8c743a6e413a0cdaf299d03dd799286cf322182bf9694204884bb0dd0037cf44592ddfa5e51f183
KUBE_DOWNLOADS = https://dl.k8s.io

# https://github.com/kubernetes-sigs/aws-iam-authenticator/releases
AUTHENTICATOR_VERSION = 0.5.2
AUTHENTICATOR_SHA256  = 5bbe44ad7f6dd87a02e0b463a2aed9611836eb2f40d7fbe8c517460a4385621b
AUTHENTICATOR_PROJECT = https://github.com/kubernetes-sigs/aws-iam-authenticator

# https://github.com/cloudflare/cfssl/releases/ (cfssl_*-checksums.txt)
CFSSL_VERSION    = 1.4.1
CFSSL_SHA256     = d01a26bc88851aab4c986e820e7b3885cedf1316a9c26a98fbba83105cfd7b87
CFSSLJSON_SHA256 = 05d67e05cacb8b2e78e737637acdcf9127b0732f0c4104403e9e9b74032fd685
CFSSL_DOWNLOADS  = https://github.com/cloudflare/cfssl/releases/download
