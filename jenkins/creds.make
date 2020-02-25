#
# Bummer - base64 -d (busybox / alpine) doesn't like base64 input from gnu
#
DECODE_ONELINER=import base64, sys; print(base64.b64decode(sys.stdin.read()).decode())
ssh-key:
	mkdir -p "$(HOME)/.jenkins"
	if [[ ! -f "$(GITHUB_SSHKEY)" ]]; then   \
	    aws --profile=$(AWS_PROFILE)         \
	        --region=$(AWS_REGION)           \
	        secretsmanager get-secret-value  \
	        --secret-id "$(ENV_SECRET_ARN)"  \
	    | jq -r '.SecretString'              \
	    | jq -r '.["id_rsa"]'                \
	    | python -c '$(DECODE_ONELINER)'     \
	    > "$(GITHUB_SSHKEY)";                \
	fi

agent-auth:
	$(eval AGENT_AUTH := $(shell               \
		aws --profile=$(AWS_PROFILE)           \
	        --region=$(AWS_REGION)             \
	        secretsmanager get-secret-value    \
	        --secret-id "$(AGENT_SECRET_ARN)"  \
	    | jq -r '.SecretString'                \
	    | jq -r '.["agent-auth"]'))
	echo "$(AGENT_AUTH)" > "$(JENKINS_CLI_AUTH).agent"
	echo "$(JENKINS_CLI_AUTH).agent"

aws-creds:
	@mkdir -p "$(AWS_CONFIG_OPTIONS)/"{server,agent}
	@set -e; \
	sts_creds=$$(                                                         \
		aws --profile=$(AWS_PROFILE)                                      \
		    --region=$(AWS_REGION)                                        \
	        sts assume-role                                               \
	          --role-arn $(SERVER_IAM_ROLE_ARN)                           \
	          --role-session-name jenkins-server-local-$(shell id -u -n)  \
	          --duration-seconds 3600                                     \
	| jq '.Credentials'); echo -e \
[default]\\n\
aws_access_key_id     = $$(echo "$$sts_creds" | jq -r '.AccessKeyId')\\n\
aws_secret_access_key = $$(echo "$$sts_creds" | jq -r '.SecretAccessKey')\\n\
aws_session_token     = $$(echo "$$sts_creds" | jq -r '.SessionToken')\\n\
expiration            = $$(echo "$$sts_creds" | jq -r '.Expiration')\
> "$(AWS_CONFIG_OPTIONS)/server/credentials"
	@echo "$(AWS_CONFIG_OPTIONS)/server/credentials"
	@echo -e \
[default]\\n\
region = $(AWS_REGION)\\n\
output = json\
> "$(AWS_CONFIG_OPTIONS)/server/config"
	@echo "$(AWS_CONFIG_OPTIONS)/server/config"
	@set -e; \
	sts_creds=$$(                                                        \
		aws --profile=$(AWS_PROFILE)                                     \
		    --region=$(AWS_REGION)                                       \
	        sts assume-role                                              \
	          --role-arn $(AGENT_IAM_ROLE_ARN)                           \
	          --role-session-name jenkins-agent-local-$(shell id -u -n)  \
	          --duration-seconds 3600                                    \
	| jq '.Credentials'); echo -e \
[default]\\n\
aws_access_key_id     = $$(echo "$$sts_creds" | jq -r '.AccessKeyId')\\n\
aws_secret_access_key = $$(echo "$$sts_creds" | jq -r '.SecretAccessKey')\\n\
aws_session_token     = $$(echo "$$sts_creds" | jq -r '.SessionToken')\\n\
expiration            = $$(echo "$$sts_creds" | jq -r '.Expiration')\
> "$(AWS_CONFIG_OPTIONS)/agent/credentials"
	@echo "$(AWS_CONFIG_OPTIONS)/agent/credentials"
	@echo -e \
[default]\\n\
region = $(AWS_REGION)\\n\
output = json\
> "$(AWS_CONFIG_OPTIONS)/agent/config"
	@echo "$(AWS_CONFIG_OPTIONS)/agent/config"
