#!make

SHELL=/bin/bash

AWS_PROFILE=admin-main
AWS_REGION=us-west-2

IMAGE_NAME=bastion-sshd-worker
IMAGE_VERSION=latest

$(eval AWS_ACCOUNT=$(shell aws --profile=$(AWS_PROFILE) sts get-caller-identity --query 'Account' --output text))
$(eval ECR_URL=$(AWS_ACCOUNT).dkr.ecr.$(AWS_REGION).amazonaws.com)
IMAGE_REPO=$(014719181291).dkr.ecr.$(AWS_REGION).amazonaws.com/$(IMAGE_NAME)

domain_config=$(CURDIR)/../../../domain.tfvars
domain=$(shell grep 'domain ' "$(domain_config)" | awk -F= '{print $$2}' | sed 's/[" ]//g' | sed 's/\./-/g')
s3_bucket=apt-repo-$(domain)

LIBNSS_IAM_VERSION=0.1

help:
	@echo "Targets:"
	@echo "  build - build the $(IMAGE_NAME) docker image"
	@echo "  push  - upload the image to ECR"
	@echo ""
	@echo "Variables:"
	@echo "  AWS_ACCOUNT => $(AWS_ACCOUNT)"
	@echo "  ECR_URL     => $(ECR_URL)"

build: files/libnss-iam.deb
	docker build -t $(IMAGE_NAME) .

files/libnss-iam.deb:
	$(CURDIR)/../../../../bin/cicdctl creds aws-mfa main
	aws --profile=$(AWS_PROFILE) --region=$(AWS_REGION) \
	    s3 cp "s3://$(s3_bucket)/repo/dists/libnss-iam-$(LIBNSS_IAM_VERSION).deb" files/libnss-iam.deb

push:
	# Tag for ECR push by tag
	docker tag "$(IMAGE_NAME):$(IMAGE_VERSION)" "$(ECR_URL)/$(IMAGE_NAME):$(IMAGE_VERSION)"

	# Push to ECR
	eval $$(aws --profile=$(AWS_PROFILE) --region $(AWS_REGION) ecr get-login --no-include-email)
	docker push "$(ECR_URL)/$(IMAGE_NAME):$(IMAGE_VERSION)"

debug:
	docker run -it --rm $(IMAGE_NAME) bash
