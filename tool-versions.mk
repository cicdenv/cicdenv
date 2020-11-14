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
TERRAFORM_VERSION  = 0.13.5
TERRAFORM_RELEASES = https://releases.hashicorp.com/terraform

# https://github.com/kubernetes/kops/releases
KOPS_VERSION   = 1.19.0-beta.1
KOPS_SHA256    = cb5452c00586371a6b7a3ebd67f28dd5aa34046a9a279b6ec3392748a46a9026
KOPS_DOWNLOADS = https://github.com/kubernetes/kops/releases/download
#KOPS_DOWNLOADS = https://github.com/fred-vogt/kops/releases/download

# https://www.packer.io/downloads.html
PACKER_VERSION  = 1.6.5
PACKER_RELEASES = https://releases.hashicorp.com/packer

# https://github.com/kubernetes/kubernetes/releases
# https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-<version>.md (checksums)
KUBE_VERSION   = 1.19.3
KUBE_SHA512    = d9a6b28cddb673e1ad9e5e8befb98f1ff8ab25778c2aa4c7c377ade84c07fa484aa35b43a32b802e9e9cd5945b3219a2b28a87e02717a5dcb39acadb4ea52ae3
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
