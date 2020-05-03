plugin-versions: cli-install
	@docker run -i --rm                                       \
	    -v $(JENKINS_CLI_JAR):/jenkins-cli.jar:ro             \
	    -v $(TLS_CONFIG):/tls:ro                              \
	    --net host                                            \
	    openjdk:jre-alpine                                    \
	    java                                                  \
	        "-Djavax.net.ssl.trustStore=/tls/truststore.jks"  \
	        "-Djavax.net.ssl.trustStorePassword=jenkins"      \
	        -jar /jenkins-cli.jar                             \
	        -s $(SERVER_URL)                                  \
	        -auth $(shell cat $(JENKINS_CLI_AUTH))            \
	        groovy = < plugin-versions/listPlugins.groovy     \
	| tee plugin-versions/$(SERVER_VERSION).txt
