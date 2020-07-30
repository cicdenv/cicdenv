#!make

SHELL=/bin/bash

AWS_PROFILE=admin-main
AWS_REGION=us-west-2

package: layer.zip

layer.zip: 
	zip layer.zip /bin/{cfssl,cfssljson}

domain_config=$(CURDIR)/../../../domain.tfvars
domain=$(shell grep 'domain ' "$(domain_config)" | awk -F= '{print $$2}' | sed 's/[" ]//g' | sed 's/\./-/g')
s3_bucket=lambda-$(domain)
layer_name=cfssl

upload: layer.zip
	$(CURDIR)/../../../../bin/cicdctl creds aws-mfa main
	aws --profile=$(AWS_PROFILE) --region=$(AWS_REGION) s3 cp "layer.zip" "s3://$(s3_bucket)/layers/$(layer_name).zip"
