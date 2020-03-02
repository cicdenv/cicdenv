cli-install:
	mkdir -p $(shell dirname $(JENKINS_CLI_JAR))
	curl -sk $(SERVER_URL)/jnlpJars/jenkins-cli.jar -o "$(JENKINS_CLI_JAR)"

cli-help: cli-install
	@docker run -it --rm                           \
	    -v $(JENKINS_CLI_JAR):/jenkins-cli.jar:ro  \
	    openjdk:jre-alpine                         \
	    java -jar /jenkins-cli.jar                 \
	    help
