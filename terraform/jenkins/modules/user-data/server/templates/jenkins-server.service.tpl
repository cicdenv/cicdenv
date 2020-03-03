[Unit]
Description=Jenkins Server
Requires=docker.service jenkins-server-disks.service jenkins-network.service
After=docker.service jenkins-server-disks.service jenkins-network.service

[Service]
TimeoutStartSec=0
Restart=always
Environment=IIDENC_FILE=/var/jenkins_home/identity.key.enc
Environment=SECKEY_FILE=/var/jenkins_home/secret.key
Environment=NSSKEY_FILE=/var/jenkins_home/secret.key.not-so-secret
ExecStartPre=/usr/bin/docker pull ${ecr_url}:${tag}
ExecStartPre=/usr/bin/docker tag ${ecr_url}:${tag} ${image}:${tag}
ExecStart=/usr/bin/docker run --rm                                    \
    --name jenkins-server                                             \
    --network jenkins                                                 \
    --init                                                            \
    -p 443:8443                                                       \
    -p 9443:9443                                                      \
    --env "SERVER_URL=${server_url}"                                  \
    --env "RESOURCE_URL=${content_url}"                               \
    --env "JENKINS_INSTANCE=${jenkins_instance}"                      \
    --env "GITHUB_SECRET_ARN=${github_secrets_arn}"                   \
    --env "GITHUB_OAUTH_REDIRECT_URI=${github_oauth_redirect_uri}"    \
    --env "AWS_MAIN_ACCOUNT_ID=${aws_main_account_id}"                \
    --env "AWS_DEFAULT_REGION=${aws_region}"                          \
    --env "AWS_ACCOUNT_NAME=${aws_account_alias}"                     \
    -v "/var/jenkins_workspace:/var/jenkins_home/workspace"           \
    -v "/var/jenkins_builds:/var/jenkins_home/builds"                 \
    -v "/var/jenkins_home/logs:/var/jenkins_home/logs"                \
    -v "/var/jenkins_home/userContent:/var/jenkins_home/userContent"  \
    -v "/var/jenkins_home/jobs:/var/jenkins_home/jobs"                \
    -v "/var/jenkins_home/nodes:/var/jenkins_home/nodes"              \
    -v "/var/jenkins_home/users:/var/jenkins_home/users"              \
    -v "/var/jenkins_home/secrets:/var/jenkins_home/secrets"          \
    -v "$${IIDENC_FILE}:$${IIDENC_FILE}"                              \
    -v "$${SECKEY_FILE}:$${SECKEY_FILE}"                              \
    -v "$${NSSKEY_FILE}:$${NSSKEY_FILE}"                              \
    -v "/var/lib/jenkins/.ssh:/var/lib/jenkins/.ssh"                  \
    -v "/var/lib/jenkins/tls:/var/jenkins_home/tls"                   \
    -v "/dev/urandom:/dev/random"                                     \
    '${image}:${tag}'

[Install]
WantedBy=multi-user.target
