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
	aws --profile=$(AWS_PROFILE) --region=$(AWS_REGION) \
	    s3 cp "layer.zip" "s3://$(s3_bucket)/layers/$(layer_name).zip"

permissions:
	org_id=$$(cd $(CURDIR)/../../../../terraform/backend; \
		AWS_PROFILE=$(AWS_PROFILE) terraform output -json organization | jq -r '.id'); \
	version=$$(aws --profile=$(AWS_PROFILE) --region=$(AWS_REGION) \
		lambda list-layer-versions \
	    --layer-name "wireguard-tools" --no-paginate --query 'sort_by(LayerVersions, &Version)[-1].Version'); \
	aws --profile=$(AWS_PROFILE) --region=$(AWS_REGION)      \
	    lambda add-layer-version-permission                  \
	    --layer-name "wireguard-tools"                       \
	    --version-number "$$version"                         \
	    --statement-id "xaccount-getlayerversion-$$version"  \
	    --action lambda:GetLayerVersion                      \
	    --principal '*'                                      \
	    --organization-id "$$org_id"                         \
	    --output text

build:
	mkdir -p "$(CURDIR)/layer/bin"
	docker run --rm -v "$(CURDIR)/layer:/output" "lambci/yumda:2" \
	    bash -c '\
yum install -y wireguard-tools; \
cp /lambda/opt/bin/wg /output/bin; \
	'

shell:
	mkdir -p "$(CURDIR)/layer/bin"
	docker run --rm -it -v "$(CURDIR)/layer:/output" "lambci/yumda:2" bash

test:
	docker run --rm -it -v "$(CURDIR)/layer:/opt" \
	    --entrypoint wg \
	    "lambci/lambda:python3.8" \
	    genkey
