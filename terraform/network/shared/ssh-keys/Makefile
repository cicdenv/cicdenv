#!make

SHELL=/bin/bash

AWS_PROFILE=admin-main
AWS_REGION=us-west-2

package: lambda.zip

lambda.zip: lambda.py rsa.py
	mkdir -p target
	pip install --upgrade -r requirements.txt --target target
	cp *.py target
	(cd target; zip ../lambda.zip -r .)

domain_config=$(CURDIR)/../../../domain.tfvars
domain=$(shell grep 'domain ' "$(domain_config)" | awk -F= '{print $$2}' | sed 's/[" ]//g' | sed 's/\./-/g')
s3_bucket=lambda-$(domain)
function_name=shared-ec2-keypair-generator

upload: lambda.zip
	$(CURDIR)/../../../../bin/cicdctl creds aws-mfa main
	aws --profile=$(AWS_PROFILE) --region=$(AWS_REGION) s3 cp "lambda.zip" "s3://$(s3_bucket)/functions/$(function_name).zip"
