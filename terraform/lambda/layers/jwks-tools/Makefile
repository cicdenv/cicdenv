#!make

SHELL=/bin/bash

AWS_PROFILE=admin-main
AWS_REGION=us-west-2

package: layer.zip

layer.zip: 
	(cd "$(CURDIR)/layer"; zip "$(CURDIR)/layer.zip" -r *)
	unzip -l "$(CURDIR)/layer.zip"

domain_config=$(CURDIR)/../../../domain.tfvars
domain=$(shell grep 'domain ' "$(domain_config)" | awk -F= '{print $$2}' | sed 's/[" ]//g' | sed 's/\./-/g')
s3_bucket=lambda-$(domain)
layer_name=jwks-tools

upload: layer.zip
	$(CURDIR)/../../../../bin/cicdctl creds aws-mfa main
	aws --profile=$(AWS_PROFILE) --region=$(AWS_REGION) \
	    s3 cp "layer.zip" "s3://$(s3_bucket)/layers/$(layer_name).zip"

permissions:
	cicdctl terraform init backend:main; \
	org_id=$$(cd $(CURDIR)/../../../../terraform/backend; \
		AWS_PROFILE=$(AWS_PROFILE) terraform output -json organization | jq -r '.id'); \
	version=$$(aws --profile=$(AWS_PROFILE) --region=$(AWS_REGION) \
		lambda list-layer-versions \
	    --layer-name "$(layer_name)" --no-paginate --query 'sort_by(LayerVersions, &Version)[-1].Version'); \
	aws --profile=$(AWS_PROFILE) --region=$(AWS_REGION)      \
	    lambda add-layer-version-permission                  \
	    --layer-name "$(layer_name)"                         \
	    --version-number "$$version"                         \
	    --statement-id "xaccount-getlayerversion-$$version"  \
	    --action lambda:GetLayerVersion                      \
	    --principal '*'                                      \
	    --organization-id "$$org_id"                         \
	    --output text

build:
	mkdir -p "$(CURDIR)/layer/"{bin,lib}
	docker run --rm -v "$(CURDIR)/src:/go/src/handler" \
	                -v "$(CURDIR)/layer:/output" "lambci/lambda:build-go1.x" \
	    bash -c '\
set -x; \
go get "github.com/pkg/errors"; \
go get "gopkg.in/square/go-jose.v2"; \
go build -v -o /output/bin/jwks /go/src/handler/main.go; \
/output/bin/jwks -h; \
	'
	docker run --rm -v "$(CURDIR)/layer:/output" "lambci/yumda:2" \
	    bash -c '\
yum install -y openssh; \
ls -lh /lambda/opt/bin; \
ls -lh /lambda/opt/lib; \
cp /lambda/opt/bin/ssh-keygen /output/bin; \
cp /lambda/opt/lib/{libcrypt.so.1,libfipscheck.so.1} /output/lib; \
	'

shell:
	mkdir -p "$(CURDIR)/layer/bin"
	docker run --rm -it \
	    -v "$(CURDIR)/layer:/opt" \
	    -e PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin" \
	    "lambci/yumda:2" \
	    bash

test:
	docker run --rm -it -v "$(CURDIR)/layer:/opt" \
	    --entrypoint bash \
	    "lambci/lambda:python3.8" \
	    -c '\
/opt/bin/jwks -h; \
mkfifo /tmp/key /tmp/key.pub && cat /tmp/{key,key.pub} & \
echo "y" | /opt/bin/ssh-keygen -b 2048 -t rsa -f /tmp/key -q -N ""; \
rm /tmp/key*; \
	'
	    