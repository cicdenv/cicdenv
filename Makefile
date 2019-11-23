#!make

SHELL=/bin/bash
MAKEFLAGS += --no-print-directory

image_name=cicdenv
image_tag=$(shell bash -c 'source image-tag.inc; echo $$image_tag')

user_name=$(shell whoami)
user_id=$(shell id -u)
docker_group=$(shell                         \
if uname -s | grep Darwin > /dev/null; then  \
    echo wheel;                              \
else                                         \
    echo docker;                             \
fi)
docker_gid=$(shell grep '^$(docker_group):' /etc/group | awk -F: '{print $$3}')

timezone=$(shell if [[ -f /etc/timezone ]]; then cat /etc/timezone; else echo 'America/Los_Angeles'; fi)

# Get the real git repository shortname.
#   /home/terraform/cicdenv
# For terraform state captured absolute paths.
repo=$(shell git config --get remote.origin.url | sed -E 's!.*/([^.]+).git$$!\1!')

include tool-versions

_PATH=/home/$(user_name)/$(repo)/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
_PS1='📦 \[\033[1;36m\]\u:\[\033[1;34m\]\w\[\033[0;35m\]\[\033[1;36m\]$$ \[\033[0m\]'

shell:
	@if [[ ! -d ~/.local                  ]]; then mkdir -p ~/.local;               fi
	@if [[ ! -f ~/.jenkins.conf           ]]; then touch ~/.jenkins.conf;           fi
	@if [[ ! -f ~/.jenkins-local.auth     ]]; then touch ~/.jenkins-local.auth;     fi
	@if [[ ! -f "$(CURDIR)/.bash_history" ]]; then touch "$(CURDIR)/.bash_history"; fi
	@docker run -it --rm                                                            \
	    --cap-add SYS_PTRACE                                                        \
        --volume "/var/run/docker.sock:/var/run/docker.sock"                        \
	    --volume "$(HOME)/.aws:/home/terraform/.aws"                                \
	    --volume "$(HOME)/.ssh:/home/terraform/.ssh"                                \
	    --volume "$(HOME)/.cache:/home/terraform/.cache"                            \
	    --volume "$(HOME)/.config:/home/terraform/.config"                          \
	    --volume "$(HOME)/.gnupg:/home/terraform/.gnupg"                            \
	    --volume "$(HOME)/.local:/home/terraform/.local"                            \
	    $(shell if [[ $$(uname -s) == "Linux" ]]; then                              \
	      echo '--volume "/run/user/$(user_id):/run/user/$(user_id)"';              \
	    fi)                                                                         \
	    --volume "$(CURDIR):/home/terraform/$(repo)"                                \
	    --volume "$(CURDIR)/.bash_history:/home/terraform/.bash_history"            \
	    --volume "$(HOME)/.gitconfig:/home/terraform/.gitconfig"                    \
	    --volume "$(HOME)/.jenkins.conf:/home/terraform/.jenkins.conf"              \
	    --volume "$(HOME)/.jenkins-local.auth:/home/terraform/.jenkins-local.auth"  \
	    --user $(user_name)                                                         \
	    --workdir=/home/terraform/$(repo)                                           \
	    $(shell if [[ $$(uname -s) == "Linux" ]]; then                              \
	      echo '--env XDG_RUNTIME_DIR="/run/user/$(user_id)"';                      \
	    fi)                                                                         \
	    --env TZ=$(timezone)                                                        \
	    --env PATH=$(_PATH)                                                         \
        --env "HOST_PATH=$(CURDIR)"                                                 \
        --env "HOST_HOME=$(HOME)"                                                   \
	    --env PS1=$(_PS1)                                                           \
	    --entrypoint /bin/bash                                                      \
	    $(image_name):$(image_tag)

versions:
	@docker run -it --rm                              \
	    --volume "$(CURDIR):/home/terraform/$(repo)"  \
	    --user $(user_name)                           \
	    --workdir=/home/terraform/$(repo)             \
	    --entrypoint /bin/bash                        \
	    $(image_name):$(image_tag)                    \
	    bin/versions.sh

docker-build:
	docker build -t "$(image_name):$(image_tag)"                      \
	    --build-arg                     tag=$(ALPINE_TAG)             \
	    --build-arg         keybase_version=$(KEYBASE_TAG)            \
	    --build-arg           keybase_build=$(KEYBASE_BUILD)          \
	    --build-arg                hcql_tag=$(HCLQ_TAG)               \
	    --build-arg            nonroot_user=$(user_name)              \
	    --build-arg             nonroot_uid=$(user_id)                \
	    --build-arg              docker_gid=$(docker_gid)             \
	    --build-arg       terraform_version=$(TERRAFORM_VERSION)      \
	    --build-arg     terraform_sha256=$(TERRAFORM_SHA256)          \
	    --build-arg      terraform_releases=$(TERRAFORM_RELEASES)     \
	    --build-arg            kops_version=$(KOPS_VERSION)           \
	    --build-arg               kops_sha256=$(KOPS_SHA256)          \
	    --build-arg           kops_releases=$(KOPS_DOWNLOADS)         \
	    --build-arg          packer_version=$(PACKER_VERSION)         \
	    --build-arg        packer_sha256=$(PACKER_SHA256)             \
	    --build-arg         packer_releases=$(PACKER_RELEASES)        \
	    --build-arg            kube_version=$(KUBE_VERSION)           \
	    --build-arg             kube_sha512=$(KUBE_SHA512)            \
	    --build-arg          kube_downloads=$(KUBE_DOWNLOADS)         \
	    --build-arg   authenticator_version=$(AUTHENTICATOR_VERSION)  \
	    --build-arg authenticator_sha256=$(AUTHENTICATOR_SHA256)      \
	    --build-arg   authenticator_project=$(AUTHENTICATOR_PROJECT)  \
	    --build-arg           cfssl_version=$(CFSSL_VERSION)          \
	    --build-arg         cfssl_sha256=$(CFSSL_SHA256)              \
	    --build-arg     cfssljson_sha256=$(CFSSLJSON_SHA256)          \
	    --build-arg         cfssl_downloads=$(CFSSL_DOWNLOADS)        \
	    .
	docker tag "$(image_name):$(image_tag)" "$(image_name):latest"
