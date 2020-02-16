include $(CURDIR)/vars.make

debug: load-creds
	@echo "GITHUB_OAUTH_CLIENT_ID      = $(GITHUB_OAUTH_CLIENT_ID)"
	@echo "GITHUB_OAUTH_CLIENT_SECRET  = $(GITHUB_OAUTH_CLIENT_SECRET)"
	
	@echo "GITHUB_ACCESS_USER          = $(GITHUB_ACCESS_USER)"
	@echo "GITHUB_ACCESS_TOKEN         = $(GITHUB_ACCESS_TOKEN)"
	@echo "GITHUB_WEBHOOKS_TOKEN       = $(GITHUB_WEBHOOKS_TOKEN)"
	
	@echo "GITHUB_AGENT_USER           = $(GITHUB_AGENT_USER)"
	@echo "GITHUB_AGENT_TOKEN          = $(GITHUB_AGENT_TOKEN)"

	@echo "FOOTER_URL                  = $(FOOTER_URL)"
	@echo "user_id                     = $(user_id)"
	@echo "CURRENT_VERSION             = $(SERVER_VERSION)"

build-plugins: build-scriptler-plugin

builds: build-server build-agent

run-agent: load-creds local-build-agent network
	docker run --rm --name 'jenkins-agent' --init                 \
	    --network '$(DOCKER_NETWORK)'                             \
	    --env "AGENT_NAME=$(AGENT_NAME)"                          \
	    --env "EXECUTORS=4"                                       \
	    --env "SERVER_URL=$(INTERNAL_URL)"                        \
	    --env "TUNNELING_URL=$(TUNNELING_URL)"                    \
	    --env "JENKINS_INSTANCE=$(JENKINS_INSTANCE)"              \
	    -v jenkins-agent-workspace:/var/lib/jenkins/workspace     \
	    -v jenkins-agent-cache:/var/lib/jenkins/cache             \
	    -v ~/.ssh/$(GITHUB_SSHKEY):/tmp/.ssh/id_rsa:ro            \
	    -v /var/run/docker.sock:/var/run/docker.sock              \
	    -h 'jenkins-agent'                                        \
	    "$(AGENT_IMAGE_NAME)-local"

run-server: load-creds network
	docker run --rm --name 'jenkins-server'                                     \
	    --network '$(DOCKER_NETWORK)'                                           \
	    -p $(HTTP_PORT):$(HTTP_PORT)                                            \
	    -p $(AGENT_PORT):$(AGENT_PORT)                                          \
	    -p $(SSH_PORT):$(SSH_PORT)                                              \
	    --env "SERVER_URL=$(SERVER_URL)"                                        \
	    --env "JENKINS_INSTANCE=$(JENKINS_INSTANCE)"                            \
	    -v jenkins-server-home:/var/jenkins_home                                \
	    -v $(CURDIR)/server-image/init-scripts:/var/jenkins_home/init.groovy.d  \
	    -v ~/.ssh/$(GITHUB_SSHKEY):/tmp/.ssh/id_rsa:ro                          \
	    -h 'jenkins-server'                                                     \
	    "$(SERVER_IMAGE_NAME)"

ui:
	$(DEFAULT_BROWSER) $(SERVER_URL)

include $(CURDIR)/setup.make
include $(CURDIR)/creds.make
include $(CURDIR)/build.make
include $(CURDIR)/debug.make
include $(CURDIR)/maint.make
include $(CURDIR)/clean.make
