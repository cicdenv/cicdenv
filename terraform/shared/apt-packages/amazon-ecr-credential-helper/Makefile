#!make

SHELL=/bin/bash

AWS_PROFILE=admin-main
AWS_REGION=us-west-2

domain_config=$(CURDIR)/../../../domain.tfvars
domain=$(shell grep 'domain ' "$(domain_config)" | awk -F= '{print $$2}' | sed 's/[" ]//g' | sed 's/\./-/g')
s3_bucket=apt-repo-$(domain)

DPKG_NAME=amazon-ecr-credential-helper
DPKG_VERSION=0.4.1
DPKG_ROOT=$(DPKG_NAME)-$(DPKG_VERSION)

# Official builds
# - https://github.com/awslabs/amazon-ecr-credential-helper/issues/215
EXECUTABLE=docker-credential-ecr-login
#DOWNLOAD_URL=https://$(DPKG_NAME)-releases.s3.$(AWS_REGION).amazonaws.com/$(DPKG_VERSION)/linux-amd64/$(EXECUTABLE)
#SHA256=2c8fc418fe1b5195388608c1cfb99ba008645f3f1beb312772c9490c39aa5904  docker-credential-ecr-login
DOWNLOAD_URL=https://github.com/fred-vogt/amazon-ecr-credential-helper/releases/download/v0.4.1/docker-credential-ecr-login
PREFIX=$(DPKG_ROOT)/usr/bin
deb:
	mkdir -p "$(DPKG_ROOT)/DEBIAN"
	
	echo -e \
Package: $(DPKG_NAME)                                                          \\n\
Version: $(DPKG_VERSION)                                                       \\n\
Architecture: amd64                                                            \\n\
Maintainer: samuelkarp \<samuel.karp@aws.com\>                                 \\n\
Original-Maintainer: Samuel Karp \<skarp@amazon.com\>                          \\n\
Depends: libc6 \(\>= 2.4\), ca-certificates                                    \\n\
Section: misc                                                                  \\n\
Priority: optional                                                             \\n\
Homepage: https://github.com/awslabs/amazon-ecr-credential-helper              \\n\
Description: Automatically gets credentials for Amazon ECR on docker push/pull \\n\
> "$(DPKG_ROOT)/DEBIAN/control"
	
	mkdir -p "$(PREFIX)"
	if [ ! -f $(EXECUTABLE) ]; then                   \
	    curl -sL -o $(EXECUTABLE) "$(DOWNLOAD_URL)";  \
	fi

	cp "$(EXECUTABLE)" "$(PREFIX)"
	chmod 755 "$(PREFIX)/$(EXECUTABLE)"

	dpkg-deb --build "$(DPKG_ROOT)"

upload:
	$(CURDIR)/../../../../bin/cicdctl creds aws-mfa main
	for deb in *.deb; do \
	    aws --profile=$(AWS_PROFILE) --region=$(AWS_REGION) s3 cp "$$deb" "s3://$(s3_bucket)/repo/dists/$${deb}"; \
	done
