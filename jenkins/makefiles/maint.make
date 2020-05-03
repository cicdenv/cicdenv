EDIT_IN_PLACE=$(shell if uname -s | grep Darwin > /dev/null; then echo '-i' \'\'; else echo '-i'; fi)
SHA256_CMD=$(shell if uname -s | grep Darwin > /dev/null; then echo 'shasum -a 256'; else echo sha256sum; fi)

checksum:
	_sha=$$(curl -fsSL $(JENKINS_WAR_DOWNLOAD_URL) | $(SHA256_CMD) | awk '{ print $$1 }');  \
	sed $(EDIT_IN_PLACE) "s/^JENKINS_SHA=.*$$/JENKINS_SHA=$${_sha}/" "$(CURDIR)/vars.make"

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
	             -e 's/(\s+clientSecret:\s+)".+"/\1"..."/'                                   \
	    | tee $(CURDIR)/config-versions/exported-jenkins-$(SERVER_VERSION).yaml
