checksum:
	_sha=$$(curl -fsSL $(JENKINS_WAR_DOWNLOAD_URL) | $(SHA256_CMD) | awk '{ print $$1 }');  \
	sed $(EDIT_IN_PLACE) "s/^JENKINS_SHA=.*$$/JENKINS_SHA=$${_sha}/" "$(CURDIR)/vars.make"

plugin-versions: cli-install
	@docker run -i --rm                                \
	    -v $(JENKINS_CLI_JAR):/jenkins-cli.jar:ro      \
	    --net host                                     \
	    openjdk:jre-alpine                             \
	    java -jar /jenkins-cli.jar                     \
	    -s $(SERVER_URL)                               \
	    -auth $(shell cat $(JENKINS_CLI_AUTH))         \
	    groovy = < plugin-versions/listPlugins.groovy  \
	| tee plugin-versions/$(SERVER_VERSION).txt
