include $(CURDIR)/vars.make

builds: build-server build-agent

run-agent: local-build-agent
	docker run --rm --name 'jenkins-agent' --init              \
	    --network host                                         \
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

run-server:
	docker run --rm --name 'jenkins-server'                     \
	    --network host                                          \
	    --env "SERVER_URL=$(SERVER_URL)"                        \
	    --env "RESOURCE_URL=$(RESOURCE_URL)"                    \
	    --env "JENKINS_INSTANCE=$(JENKINS_INSTANCE)"            \
	    --env "GITHUB_SECRET_ARN=$(GITHUB_SECRET_ARN)"          \
	    --env "GITHUB_AGENT_USER=$(GITHUB_AGENT_USER)"          \
	    --env "AWS_ACCOUNT_NAME=$(AWS_ACCOUNT_NAME)"            \
	    --env "AWS_MAIN_ACCOUNT_ID=$(AWS_MAIN_ACCOUNT_ID)"      \
	    --env "AWS_DEFAULT_REGION=$(AWS_REGION)"                \
	    --env "EXTRA_SERVER_OPTS=$(EXTRA_SERVER_OPTS)"          \
	    -v jenkins-server-home:/var/jenkins_home                \
	    -v $(HOOK_SCRIPTS):/var/jenkins_home/init.groovy.d      \
	    -v $(CASC_CONFIG):/var/jenkins_home/jenkins.yaml        \
	    -v $(GITHUB_SSHKEY):/var/lib/jenkins/.ssh/id_rsa:ro     \
	    -v $(AWS_CONFIG_OPTIONS)/server:/var/jenkins_home/.aws  \
	    -v $(TLS_CONFIG):/var/jenkins_home/tls                  \
	    -h 'jenkins-server'                                     \
	    "$(SERVER_IMAGE_NAME)"

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
