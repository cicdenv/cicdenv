#!make

SHELL=/bin/bash

AWS_PROFILE=admin-main
AWS_REGION=us-west-2

domain_config=$(CURDIR)/../../../domain.tfvars
domain=$(shell grep 'domain ' "$(domain_config)" | awk -F= '{print $$2}' | sed 's/[" ]//g' | sed 's/\./-/g')
s3_bucket=apt-repo-$(domain)

REPO=https://github.com/gfleury/libnss-iam
VERSION=0.1
DISTRO=bionic

deb:
	curl -sL -o libnss-iam-$(VERSION).deb "$(REPO)/releases/download/v$(VERSION)/libnss-iam-$(DISTRO)-$(VERSION).deb"

upload:
	$(CURDIR)/../../../../bin/cicdctl creds aws-mfa main
	for deb in *.deb; do \
	    aws --profile=$(AWS_PROFILE) --region=$(AWS_REGION) s3 cp "$$deb" "s3://$(s3_bucket)/repo/dists/$${deb}"; \
	done
