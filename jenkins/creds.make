load-creds: load-oauth-creds load-access-creds load-agent-creds

load-oauth-creds:
	$(eval GITHUB_OAUTH_CLIENT_ID     := $(shell ...))
	$(eval GITHUB_OAUTH_CLIENT_SECRET := $(shell ...))

load-access-creds:
	$(eval GITHUB_ACCESS_USER         := $(shell ...))
	$(eval GITHUB_ACCESS_TOKEN        := $(shell ...))
	$(eval GITHUB_WEBHOOKS_TOKEN      := $(shell ...))
	$(eval GITHUB_SSHKEY              := $(GITHUB_ACCESS_USER))

load-agent-creds:
	$(eval GITHUB_AGENT_USER  :=$(shell ...))
	$(eval GITHUB_AGENT_TOKEN :=$(shell ...))
