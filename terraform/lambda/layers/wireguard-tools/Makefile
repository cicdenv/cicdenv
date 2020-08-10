#!make

SHELL=/bin/bash

AWS_PROFILE=admin-main
AWS_REGION=us-west-2

package: layer.zip

layer.zip: 
	(cd "$(CURDIR)/layer"; zip "$(CURDIR)/layer.zip" -r *)

domain_config=$(CURDIR)/../../../domain.tfvars
domain=$(shell grep 'domain ' "$(domain_config)" | awk -F= '{print $$2}' | sed 's/[" ]//g' | sed 's/\./-/g')
s3_bucket=lambda-$(domain)
layer_name=wireguard-tools

upload: layer.zip
	$(CURDIR)/../../../../bin/cicdctl creds aws-mfa main
	aws --profile=$(AWS_PROFILE) --region=$(AWS_REGION) s3 cp "layer.zip" "s3://$(s3_bucket)/layers/$(layer_name).zip"

WG_TOOLS_VERSION = 1.0.20200513
build:
	mkdir -p "$(CURDIR)/layer/bin"
	docker run --rm -v "$(CURDIR)/layer:/output" "lambci/lambda-base-2:build" \
	    bash -c '\
cat /etc/os-release; \
yum install -y xz gcc make; \
export PATH="${PATH}:/opt/bin"; \
export LIBRARY_PATH="/opt/lib/gcc/x86_64-redhat-linux/7:/opt/lib:/usr/lib64:/usr/lib"; \
export LD_LIBRARY_PATH="/opt/lib:/usr/lib64:/usr/lib"; \
export LDFLAGS="-L/opt/lib"; \
echo "/opt/lib" > /etc/ld.so.conf.d/opt.conf; ldconfig; \
curl -Ls -o /tmp/wireguard-tools-$(WG_TOOLS_VERSION).tar.xz \
    https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-$(WG_TOOLS_VERSION).tar.xz; \
(cd /tmp; tar -xJf /tmp/wireguard-tools-$(WG_TOOLS_VERSION).tar.xz); \
(cd /tmp/wireguard-tools-$(WG_TOOLS_VERSION)/src; make); \
cp /tmp/wireguard-tools-$(WG_TOOLS_VERSION)/src/wg /output/bin; \
	'

shell:
	mkdir -p "$(CURDIR)/layer/bin"
	docker run --rm -it -v "$(CURDIR)/layer:/output" "lambci/lambda-base-2:build" bash

test:
	mkdir -p "$(CURDIR)/layer/bin"
	docker run --rm -it -v "$(CURDIR)/layer:/output" "lambci/lambda-base-2:build" \
	bash -c '/output/bin/wg genkey'
