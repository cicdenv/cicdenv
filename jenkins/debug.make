run-server-bash:
	docker run --rm -it --entrypoint=/bin/bash "$(SERVER_IMAGE_NAME)"

run-agent-bash:
	docker run --rm -it --network=host --entrypoint=/bin/bash "$(AGENT_IMAGE_NAME)-local"

debug-agent:
	docker exec -it --user $(JENKINS_UID) -w '/var/lib/jenkins' "$(AGENT_IMAGE_NAME)-local" /bin/bash

debug-server:
	docker exec -it --user $(JENKINS_UID) -w '/var/jenkins_home' "$(SERVER_IMAGE_NAME)" /bin/bash

cli-install:
	mkdir -p $(shell dirname $(JENKINS_CLI_JAR))
	curl -sk $(EXTERNAL_URL)/jnlpJars/jenkins-cli.jar -o "$(JENKINS_CLI_JAR)"

cli-help: cli-install
	@docker run -it --rm                           \
	    -v $(JENKINS_CLI_JAR):/jenkins-cli.jar:ro  \
	    openjdk:jre-alpine                         \
	    java -jar /jenkins-cli.jar                 \
	    help

ssh-test:
	ssh $(shell git config --global 'user.name')@localhost -p $(SSH_PORT) who-am-i

ssh-cli: cli-install
	@docker run -it --rm                                \
	    -v ~/.ssh:/root/.ssh                            \
	    -v $(JENKINS_CLI_JAR):/jenkins-cli.jar:ro       \
	    --net host                                      \
	    openjdk:jre-alpine                              \
	    java -jar /jenkins-cli.jar                      \
	    -s $(EXTERNAL_URL)                              \
	    -i /root/.ssh/id_rsa -ssh                       \
	    -user $(shell git config --global 'user.name')  \
	    who-am-i

console:
	screen ~/Library/Containers/com.docker.docker/Data/vms/0/tty

host:
	docker run --rm -it \
	    --privileged \
	    --pid=host \
	    --env PS1=$(_PS1) \
	    debian \
	    nsenter -t 1 -m -u -n -i bash
