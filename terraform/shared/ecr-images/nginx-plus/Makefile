SHELL=/bin/bash

AWS_PROFILE=admin-main
AWS_REGION=us-west-2

IMAGE_NAME=nginx-plus

help:
	@echo "Targets:"
	@echo "  build - build the $(IMAGE_NAME) docker image"
	@echo "  push  - upload the image to ECR"

build:
	# --progress=plain
	DOCKER_BUILDKIT=1                           \
	docker build                                \
	    --secret id=crt,src=./nginx-repo.crt    \
	    --secret id=key,src=./nginx-repo.key    \
	    --secret id=geo,src=./geoipupdate.conf  \
	    --tag "$(IMAGE_NAME)"                   \
	    .
push:
	$(eval AWS_ACCOUNT=$(shell aws --profile=$(AWS_PROFILE) sts get-caller-identity --query 'Account' --output text))
	$(eval ECR_URL=$(AWS_ACCOUNT).dkr.ecr.$(AWS_REGION).amazonaws.com)
	$(eval IMAGE_REPO=$(014719181291).dkr.ecr.$(AWS_REGION).amazonaws.com/$(IMAGE_NAME))
	$(eval IMAGE_VERSION=$(shell make nginx-version | awk '{print $$4}' | sed -E 's/\(nginx-plus-(r\d+)\)/\1/'))

	# Tag for ECR push by tag
	docker tag "$(IMAGE_NAME)"                  "$(IMAGE_NAME):$(IMAGE_VERSION)"
	docker tag "$(IMAGE_NAME):$(IMAGE_VERSION)" "$(ECR_URL)/$(IMAGE_NAME):$(IMAGE_VERSION)"

	# Push to ECR
	eval $$(aws --profile=$(AWS_PROFILE) --region $(AWS_REGION) ecr get-login --no-include-email)
	docker push "$(ECR_URL)/$(IMAGE_NAME):$(IMAGE_VERSION)"

shell: build
	docker run -it --rm                                            \
	    --volume "$(CURDIR)/nginx-repo.crt:/etc/ssl/nginx/crt:ro"  \
	    --volume "$(CURDIR)/nginx-repo.key:/etc/ssl/nginx/key:ro"  \
	    --volume "$(CURDIR)/geoipupdate.conf:/etc/GeoIP.conf:ro"   \
	    --entrypoint=/bin/bash                                     \
	    "$(IMAGE_NAME)"

nginx-version:
	@docker run -it --rm    \
	    --entrypoint=nginx  \
	    "$(IMAGE_NAME)"     \
	    -v
