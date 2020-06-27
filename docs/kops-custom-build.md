## Why ?
KOPS only provides tagged releases.  
To test with the latest from master or a release branch you'll have to build 
and upload the client binary and cloud assets.

Example: [release-1.18 branch](https://github.com/kubernetes/kops/tree/release-1.18)

## Build Setup
```bash
# aws cli - install with pyenv+venv
pyenv local 3.8.3
virtualenv .venv
. .venv/bin/activate
pip install awscli

# checkout
git clone --single-branch --branch "release-1.18" "https://github.com/kubernetes/kops.git"
cd kops
kops$

# golang tooling - gvm
# gvm use go1.4
kops$ gvm install "$(grep 'GOVERSION=' Makefile | cut -d= -f2)"
kops$ gvm use "go$(grep 'GOVERSION=' Makefile | cut -d= -f2)"

# bazel
curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -
echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" \
    | sudo tee /etc/apt/sources.list.d/bazel.list
kops$ sudo apt install "bazel-$(cat .bazelversion)" 
```

## Build
```bash
kops$ make CI=yes STATIC_BUILD=yes

export S3_BUCKET_NAME="kops-builds-cicdenv-com"
kops$ AWS_PROFILE=admin-main make dev-upload  CI=yes STATIC_BUILD=yes "S3_BUCKET=s3://${S3_BUCKET_NAME}/"
```

## Release in Github Fork
For easy inclusion in container builds.
As an alternative: upload the client binary to `kops-builds-cicdenv-com/kops/<version>/kops`.
	
* https://github.com/fred-vogt/kops/releases/tag/v1.18.0-beta.2-6309b96

```bash
kops$ which kops
${HOME}/.gvm/pkgsets/go1.13.9/global/bin/kops

sha256sum "$(which kops)"
cp "$(which kops)" /tmp/kops-linux-amd64

# Create a release in github
v1.18.0-beta-2-<git-sha>
Comment: sha256
Attach /tmp/kops-linux-amd64
```

## Run
* tool-versions.mk
```
KOPS_VERSION   = 1.18.0-beta.2-6309b96
KOPS_SHA256    = 05e8c81a185473c91669ed47b2762a8af4393e066cf1b8a197460aec3bc57f7a
KOPS_DOWNLOADS = https://github.com/fred-vogt/kops/releases/download
```
* terraform/kops/modules/commands/locals.tf
```hcl
# NOTE: remove 'KOPS_BASE_URL' when not running a custom build
kops_vars = {
  ...
  KOPS_BASE_URL = "https://s3-${var.terraform_state.region}.amazonaws.com/${local.builds.bucket.name}/kops/${urlencode(local.kops_version)}/"
}
```

```bash
export AWS_REGION="us-west-2"
export S3_BUCKET_NAME="kops-builds-cicdenv-com"

# 1.18.0-beta.2
# export KOPS_VERSION="$(bazel run //cmd/kops version -- --short)"
export KOPS_VERSION="$($(which kops) version --short)"
export KOPS_BASE_URL=https://s3-${AWS_REGION}.amazonaws.com/${S3_BUCKET_NAME}/kops/${KOPS_VERSION}/
kops create cluster ...
```

## Links
* https://github.com/kubernetes/kops/blob/master/docs/development/building.md
* https://kubernetes-kops.netlify.app/development/adding_a_feature/
