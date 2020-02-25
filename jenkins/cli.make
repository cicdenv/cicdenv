cli-install:
	mkdir -p $(shell dirname $(JENKINS_CLI_JAR))
	curl -sk $(SERVER_URL)/jnlpJars/jenkins-cli.jar -o "$(JENKINS_CLI_JAR)"

cli-help: cli-install
	@docker run -it --rm                           \
	    -v $(JENKINS_CLI_JAR):/jenkins-cli.jar:ro  \
	    openjdk:jre-alpine                         \
	    java -jar /jenkins-cli.jar                 \
	    help

plugin-versions: cli-install
	@docker run -i --rm                                       \
	    -v $(JENKINS_CLI_JAR):/jenkins-cli.jar:ro             \
	    -v $(TLS_CONFIG):/tls:ro                              \
	    --net jenkins                                         \
	    openjdk:jre-alpine                                    \
	    java                                                  \
	        "-Djavax.net.ssl.trustStore=/tls/truststore.jks"  \
	        "-Djavax.net.ssl.trustStorePassword=jenkins"      \
	        -jar /jenkins-cli.jar                             \
	        -s $(SERVER_URL)                                  \
	        -auth $(shell cat $(JENKINS_CLI_AUTH))            \
	        groovy = < plugin-versions/listPlugins.groovy     \
	| tee plugin-versions/$(SERVER_VERSION).txt
