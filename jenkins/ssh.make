#
# Removed SSH access from server for now
#

ssh-test:
	ssh $(shell git config --global 'user.name')@localhost -p $(SSH_PORT) who-am-i

ssh-cli: cli-install
	@docker run -it --rm                                \
	    -v ~/.ssh:/root/.ssh                            \
	    -v $(JENKINS_CLI_JAR):/jenkins-cli.jar:ro       \
	    --net host                                      \
	    openjdk:jre-alpine                              \
	    java -jar /jenkins-cli.jar                      \
	    -s $(SERVER_URL)                                \
	    -i /root/.ssh/id_rsa -ssh                       \
	    -user $(shell git config --global 'user.name')  \
	    who-am-i
