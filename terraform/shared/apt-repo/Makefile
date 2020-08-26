#!make

SHELL=/bin/bash

AWS_PROFILE=admin-main
AWS_REGION=us-west-2

domain_config=$(CURDIR)/../../domain.tfvars
domain=$(shell grep 'domain ' "$(domain_config)" | awk -F= '{print $$2}' | sed 's/[" ]//g' | sed 's/\./-/g')
s3_bucket=apt-repo-$(domain)
S3_IAM_ROLE_ARN=arn:aws:iam::014719181291:role/apt-repo-access

tests: https-test s3-test

https-test:
	echo -e \
FROM ubuntu:20.04\\n\
RUN apt-get update \&\& apt-get install -y curl gnupg2\\n\
RUN curl -sL "https://$(s3_bucket).s3-$(AWS_REGION).amazonaws.com/repo/dists/key.asc" \| apt-key add -\\n\
RUN echo "deb https://apt-repo-cicdenv-com.s3-us-west-2.amazonaws.com repo/dists/" \> "/etc/apt/sources.list.d/s3-repos.list"\\n\
RUN apt-get update\\n\
| docker build -t apt-repo -

s3-test: sts-creds
	echo -e \
\# syntax = docker/dockerfile:experimental\\n\
FROM ubuntu:20.04\\n\
RUN apt-get update \&\& apt-get install -y curl gnupg2 python3 python3-configobj\\n\
RUN curl -sL "https://$(s3_bucket).s3-$(AWS_REGION).amazonaws.com/repo/dists/key.asc" \| apt-key add -\\n\
RUN echo "deb s3://apt-repo-cicdenv-com repo/dists/" \> "/etc/apt/sources.list.d/s3-repos.list"\\n\
RUN curl -sL -o /usr/lib/apt/methods/s3 "https://raw.githubusercontent.com/cicdenv/cicdenv/master/packer/ansible/roles/custom-apt-repo/files/apt-transport-s3.py"\\n\
RUN chmod +x /usr/lib/apt/methods/s3\\n\
RUN --mount=type=secret,id=creds,dst=/etc/apt/s3auth.conf apt-get update\\n\
| DOCKER_BUILDKIT=1 docker build --secret id=creds,src=.aws/s3auth.conf -t apt-repo -

# https://github.com/MayaraCloud/apt-transport-s3#configuration s3auth.conf
# --progress=plain
# --no-cache 
sts-creds: aws-creds
	@mkdir -p "$(CURDIR)/.aws"
	set -e; \
	sts_creds=$$(docker run --rm -i                             \
	    -v "$${HOME}/.aws:/root/.aws:ro"                        \
	    amazon/aws-cli                                          \
	        --profile=$(AWS_PROFILE)                            \
	        --region=$(AWS_REGION)                              \
	        sts assume-role                                     \
	          --role-arn "$(S3_IAM_ROLE_ARN)"                   \
	          --role-session-name s3-indexer-$(shell id -u -n)  \
	          --duration-seconds 3600                           \
	          --query 'Credentials'                             \
	); echo -e \
Region          = $(AWS_REGION)\\n\
AccessKeyId     = $$(echo "$$sts_creds" | jq -r '.AccessKeyId')\\n\
SecretAccessKey = $$(echo "$$sts_creds" | jq -r '.SecretAccessKey')\\n\
Token           = $$(echo "$$sts_creds" | jq -r '.SessionToken')\\n\
> "$(CURDIR)/.aws/s3auth.conf"
	@echo "$(CURDIR)/.aws/s3auth.conf"

aws-creds:
	$(CURDIR)/../../../bin/cicdctl creds aws-mfa main
