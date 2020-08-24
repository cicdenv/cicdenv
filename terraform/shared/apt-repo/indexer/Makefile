#!make

SHELL=/bin/bash

AWS_PROFILE=admin-main
AWS_REGION=us-west-2

LAMBDA_IAM_ROLE_ARN=arn:aws:iam::014719181291:role/s3apt-indexer

package: lambda.zip

lambda.zip: target
	(cd target; zip ../lambda.zip -r .)

target: lambda.py     \
	    checksums.py  \
	    control.py    \
	    gpg.py        \
	    package.py    \
	    release.py    \
	    secrets.py    \
	    requirements.txt
	mkdir -p target
	cp *.py target
	pip install --upgrade -r requirements.txt --target target

domain_config=$(CURDIR)/../../../domain.tfvars
domain=$(shell grep 'domain ' "$(domain_config)" | awk -F= '{print $$2}' | sed 's/[" ]//g' | sed 's/\./-/g')
s3_bucket=apt-repo-$(domain)
function_name=s3apt-indexer

aws-creds:
	$(CURDIR)/../../../../bin/cicdctl creds aws-mfa main

upload: lambda.zip aws-creds
	aws --profile=$(AWS_PROFILE) --region=$(AWS_REGION) s3 cp "lambda.zip" "s3://$(s3_bucket)/$(function_name).zip"

DOCKER_RUN_CMD=\
set -eu; \
gnupg2=$$(cd "$(CURDIR)/../../../lambda/layers/gnupg2/layer"; pwd); \
home=$$(docker run -i --rm --entrypoint=bash lambci/lambda:python3.8 -c 'echo $$HOME'); \
docker run --rm -it \
    -v "$${gnupg2}:/opt" \
    -v "$(CURDIR)/target:/var/task" \
    -v "${CURDIR}/.aws:$${home}/.aws:ro" \
    -v "${CURDIR}/../../apt-packages/libnss-iam/libnss-iam-0.1.deb:/tmp/libnss-iam-0.1.deb:ro" \
    -e "SECRET_ID=apt-repo-gpg" \
    -e "BUCKET=$(s3_bucket)" \
    -e "CACHE_PREFIX=repo/control-data-cache" \
    --entrypoint bash \
    --workdir "/var/task" \
    "lambci/lambda:python3.8" \
    -c

test-lambda: target aws-creds lambda-creds
	$(DOCKER_RUN_CMD) 'python lambda.py'

test-release: target aws-creds lambda-creds
	$(DOCKER_RUN_CMD) 'python release.py'

test-package: target aws-creds lambda-creds
	$(DOCKER_RUN_CMD) 'python package.py'

test-control: target aws-creds lambda-creds
	$(DOCKER_RUN_CMD) 'python control.py'

test-checksums: target aws-creds lambda-creds
	$(DOCKER_RUN_CMD) 'python checksums.py'

test-gpg: target aws-creds lambda-creds
	$(DOCKER_RUN_CMD) 'python gpg.py'

test-secrets: target aws-creds lambda-creds
	$(DOCKER_RUN_CMD) 'python secrets.py'

lambda-creds:
	@mkdir -p "$(CURDIR)/.aws"
	set -e; \
	sts_creds=$$(docker run --rm -i                             \
	    -v "$${HOME}/.aws:/root/.aws:ro"                        \
	    amazon/aws-cli                                          \
	        --profile=$(AWS_PROFILE)                            \
	        --region=$(AWS_REGION)                              \
	        sts assume-role                                     \
	          --role-arn "$(LAMBDA_IAM_ROLE_ARN)"               \
	          --role-session-name s3-indexer-$(shell id -u -n)  \
	          --duration-seconds 3600                           \
	          --query 'Credentials'                             \
	); echo -e \
[default]\\n\
aws_access_key_id     = $$(echo "$$sts_creds" | jq -r '.AccessKeyId')\\n\
aws_secret_access_key = $$(echo "$$sts_creds" | jq -r '.SecretAccessKey')\\n\
aws_session_token     = $$(echo "$$sts_creds" | jq -r '.SessionToken')\\n\
expiration            = $$(echo "$$sts_creds" | jq -r '.Expiration')\
> "$(CURDIR)/.aws/credentials"
	@echo "$(CURDIR)/.aws/credentials"
	@echo -e \
[default]\\n\
region = $(AWS_REGION)\\n\
output = json\
> "$(CURDIR)/.aws/config"
	@echo "$(CURDIR)/.aws/config"
