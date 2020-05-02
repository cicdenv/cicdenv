run-server-bash:
	docker run --rm -it --entrypoint=/bin/bash "$(SERVER_IMAGE_NAME)"

run-agent-bash:
	docker run --rm -it --network=host --entrypoint=/bin/bash "$(AGENT_IMAGE_NAME)-local"

debug-agent:
	docker exec -it --user $(JENKINS_UID) -w '/var/lib/jenkins' "$(AGENT_IMAGE_NAME)-local" /bin/bash

debug-server:
	docker exec -it --user $(JENKINS_UID) -w '/var/jenkins_home' "$(SERVER_IMAGE_NAME)" /bin/bash
