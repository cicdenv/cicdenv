build-server: build-jenkinsci-docker
	# Build & Tag by version
	docker build -t "$(SERVER_IMAGE_NAME):$(SERVER_VERSION)"  \
	    --build-arg='FOOTER_URL=$(FOOTER_URL)'                \
	    server-image

	# Tag as latest
	docker tag "$(SERVER_IMAGE_NAME):$(SERVER_VERSION)" "$(SERVER_IMAGE_NAME):latest"

build-agent: build-server
	# Build & Tag by version
	docker build -t "$(AGENT_IMAGE_NAME):$(AGENT_VERSION)"  \
	    --build-arg='jenkinsVersion=$(JENKINS_VERSION)'     \
	    --build-arg='REMOTING_VERSION=$(REMOTING_VERSION)'  \
	    --build-arg='uid=$(JENKINS_UID)'                    \
	    --build-arg='gid=$(JENKINS_GID)'                    \
	    agent-image

	# Tag as latest
	docker tag "$(AGENT_IMAGE_NAME):$(AGENT_VERSION)" "$(AGENT_IMAGE_NAME):latest"

build-jenkinsci-docker: pull-jenkinsci-docker
	docker build -t jenkins-upstream:latest               \
	    --build-arg='uid=$(JENKINS_UID)'                  \
	    --build-arg='gid=$(JENKINS_GID)'                  \
	    --build-arg='JENKINS_VERSION=$(JENKINS_VERSION)'  \
	    --build-arg='JENKINS_SHA=$(JENKINS_SHA)'          \
	    --build-arg='agent_port=$(AGENT_PORT)'            \
	    server-image/jenkins-ci.docker                    \
	    -f server-image/jenkins-ci.docker/Dockerfile-jdk11

pull-jenkinsci-docker:
	if [[ ! -d server-image/jenkins-ci.docker ]]; then \
	    git clone --depth 1 $(JENKINS_DOCKER_GITHUB) --branch $(JENKINS_DOCKER_BRANCH) server-image/jenkins-ci.docker; \
	else \
	    if [[ ! "master" == "$(shell if [ -d server-image/jenkins-ci.docker ]; then git --git-dir server-image/jenkins-ci.docker/.git rev-parse --abbrev-ref HEAD; fi)" ]]; then \
	        rm -rf server-image/jenkins-ci.docker; git clone --depth 1 $(JENKINS_DOCKER_GITHUB) --branch $(JENKINS_DOCKER_BRANCH) server-image/jenkins-ci.docker; \
	    fi; \
	fi

push:
	if [[ ! -d "$(CURDIR)/.venv" ]]; then       \
	    virtualenv "$(CURDIR)/.venv";           \
	    source "$(CURDIR)/.venv/bin/activate";  \
	    pip install --upgrade pip;              \
	    pip install -r requirements.txt;        \
	fi
	$(eval AWS_ACCOUNT=$(shell \
	    source "$(CURDIR)/.venv/bin/activate"; \
	    aws --profile=$(AWS_PROFILE) --region=$(AWS_REGION) sts get-caller-identity --query 'Account' --output text \
	))
	$(eval ECR_URL=$(AWS_ACCOUNT).dkr.ecr.$(AWS_REGION).amazonaws.com)

	# Tag for ECR push by tag
	docker tag "$(SERVER_IMAGE_NAME):$(SERVER_VERSION)" "$(ECR_URL)/$(SERVER_IMAGE_NAME):$(SERVER_VERSION)"
	docker tag "$(AGENT_IMAGE_NAME):$(AGENT_VERSION)"   "$(ECR_URL)/$(AGENT_IMAGE_NAME):$(AGENT_VERSION)"

	# Push to ECR
	eval $$(\
	    source "$(CURDIR)/.venv/bin/activate"; \
	    aws --profile=$(AWS_PROFILE) --region=$(AWS_REGION) ecr get-login --no-include-email \
	)
	docker push "$(ECR_URL)/$(SERVER_IMAGE_NAME):$(SERVER_VERSION)"
	docker push "$(ECR_URL)/$(AGENT_IMAGE_NAME):$(AGENT_VERSION)"

local-build-agent:
	printf "\
	FROM $(AGENT_IMAGE_NAME)\n\
	USER root\n\
	RUN if echo '$(docker_group)' | grep 'daemon'; then  \\\\\n\
	    addgroup jenkins root;                           \\\\\n\
	else                                                 \\\\\n\
	    sed -i 's/:8088:/:$(docker_gid):/' /etc/group;   \\\\\n\
	fi\n\
	USER jenkins\n\
	"\
	| docker build -t "$(AGENT_IMAGE_NAME)-local" -
