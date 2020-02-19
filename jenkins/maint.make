checksum:
	_sha=$$(curl -fsSL $(JENKINS_WAR_DOWNLOAD_URL) | $(SHA256_CMD) | awk '{ print $$1 }');  \
	sed $(EDIT_IN_PLACE) "s/^JENKINS_SHA=.*$$/JENKINS_SHA=$${_sha}/" "$(CURDIR)/vars.make"

plugin-versions: cli-install
	@docker run -i --rm                                             \
	    -v $(JENKINS_CLI_JAR):/jenkins-cli.jar:ro                   \
	    -v $(TLS_CONFIG):/tls:ro                                    \
	    -v $(CURDIR)/debug-logging.properties:/dl.properties:ro     \
	    --net host                                                  \
	    openjdk:jre-alpine                                          \
	    java                                                        \
	        "-Djavax.net.ssl.trustStore=/tls/agent-truststore.jks"  \
	        "-Djavax.net.ssl.trustStorePassword=jenkins"            \
	        -Djava.util.logging.config.file=/dl.properties          \
	        -Djavax.net.debug=all                                   \
	        -jar /jenkins-cli.jar                                   \
	        -s $(EXTERNAL_URL)                                      \
	        -websockets                                             \
	        -auth $(shell cat $(JENKINS_CLI_AUTH))                  \
	        groovy = < plugin-versions/listPlugins.groovy           \
	| tee plugin-versions/$(SERVER_VERSION).txt
