include $(CURDIR)/vars.make

builds: build-server build-agent

run-agent: local-build-agent network
	docker run --rm --name 'jenkins-agent' --init              \
	    --network '$(DOCKER_NETWORK)'                          \
	    -p $(DEBUGGER_PORT):$(AGENT_DEBUGGER_PORT)             \
	    --env "AGENT_NAME=$(AGENT_NAME)"                       \
	    --env "EXECUTORS=4"                                    \
	    --env "SERVER_URL=$(SERVER_URL)"                       \
	    --env "JENKINS_INSTANCE=$(JENKINS_INSTANCE)"           \
	    --env "AGENT_SECRET_ARN=$(AGENT_SECRET_ARN)"           \
	    --env "EXTRA_CLIENT_OPTS=$(EXTRA_CLIENT_OPTS)"         \
	    --env "EXTRA_AGENT_OPTS=$(EXTRA_AGENT_OPTS)"           \
	    -v jenkins-agent-workspace:/var/lib/jenkins/workspace  \
	    -v jenkins-agent-cache:/var/lib/jenkins/cache          \
	    -v $(GITHUB_SSHKEY):/tmp/.ssh/id_rsa:ro                \
	    -v $(AWS_CONFIG_OPTIONS)/agent:/var/lib/jenkins/.aws   \
	    -v $(TLS_CONFIG)/truststore.jks:$(TRUST_STORE)         \
	    -v /var/run/docker.sock:/var/run/docker.sock           \
	    -h 'jenkins-agent'                                     \
	    "$(AGENT_IMAGE_NAME)-local"

run-server: network
	docker run --rm --name 'jenkins-server'                                     \
	    --network '$(DOCKER_NETWORK)'                                           \
	    -p $(HTTP_PORT):$(HTTP_PORT)                                            \
	    -p $(HTTPS_PORT):$(HTTPS_PORT)                                          \
	    -p $(HTTP2_PORT):$(HTTP2_PORT)                                          \
	    -p $(DEBUGGER_PORT):$(SERVER_DEBUGGER_PORT)                             \
	    --env "SERVER_URL=$(SERVER_URL)"                                        \
	    --env "RESOURCE_URL=$(RESOURCE_URL)"                                    \
	    --env "JENKINS_INSTANCE=$(JENKINS_INSTANCE)"                            \
	    --env "GITHUB_SECRET_ARN=$(GITHUB_SECRET_ARN)"                          \
	    --env "GITHUB_ORGANIZATION=$(GITHUB_ORGANIZATION)"                      \
	    --env "GITHUB_AGENT_USER=$(GITHUB_AGENT_USER)"                          \
	    --env "EXTRA_JAVA_OPTS=$(EXTRA_SERVER_OPTS)"                            \
	    -v jenkins-server-home:/var/jenkins_home                                \
	    -v $(CURDIR)/server-image/init-scripts:/var/jenkins_home/init.groovy.d  \
	    -v $(GITHUB_SSHKEY):/var/lib/jenkins/.ssh/id_rsa:ro                     \
	    -v $(AWS_CONFIG_OPTIONS)/server:/var/jenkins_home/.aws                  \
	    -v $(TLS_CONFIG):/var/jenkins_home/tls                                  \
	    -h 'jenkins-server'                                                     \
	    "$(SERVER_IMAGE_NAME)"

network:
	if ! docker network inspect '$(DOCKER_NETWORK)' &>/dev/null; then \
	    docker network create '$(DOCKER_NETWORK)'; \
	fi

ui:
	$(DEFAULT_BROWSER) $(SERVER_URL)

include $(CURDIR)/creds.make
include $(CURDIR)/certs.make
include $(CURDIR)/disks.make
include $(CURDIR)/plugs.make
include $(CURDIR)/build.make
include $(CURDIR)/debug.make
include $(CURDIR)/maint.make
include $(CURDIR)/clean.make
include $(CURDIR)/cli.make
include $(CURDIR)/mac.make
