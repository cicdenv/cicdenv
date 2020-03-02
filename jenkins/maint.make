checksum:
	_sha=$$(curl -fsSL $(JENKINS_WAR_DOWNLOAD_URL) | $(SHA256_CMD) | awk '{ print $$1 }');  \
	sed $(EDIT_IN_PLACE) "s/^JENKINS_SHA=.*$$/JENKINS_SHA=$${_sha}/" "$(CURDIR)/vars.make"

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

export-config:
	export CSRF_CRUMB=$$(curl -skL                                                           \
	    -c $(CURDIR)/cli-cookies.txt                                                         \
	    -u "$(shell cat $(JENKINS_CLI_AUTH))"                                                \
	    "$(SERVER_URL)"'/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)'  \
	);                                                                                       \
	curl -skL                                                                                \
	    -b $(CURDIR)/cli-cookies.txt                                                         \
	    -u "$(shell cat $(JENKINS_CLI_AUTH))"                                                \
	    -H "$$CSRF_CRUMB"                                                                    \
	    -X POST                                                                              \
	    "$(SERVER_URL)/configuration-as-code/export"                                         \
	    | sed -E -e 's/(\s+secret:\s+)".+"/\1"..."/'                                         \
	             -e 's/(\s+password:\s+)".+"/\1"..."/'                                       \
	    | tee $(CURDIR)/server-image/jcasc/exported-jenkins.yaml
