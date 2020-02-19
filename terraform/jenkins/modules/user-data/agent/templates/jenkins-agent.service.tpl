[Unit]
Description=Jenkins Agent
Requires=docker.service jenkins-agent-disks.service jenkins-network.service
After=docker.service jenkins-agent-disks.service jenkins-network.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=/usr/bin/docker pull ${ecr_url}:${tag}
ExecStartPre=/usr/bin/docker tag ${ecr_url}:${tag} ${image}:${tag}
ExecStartPre=/usr/bin/bash -c "/usr/bin/systemctl set-environment NODE_ID=`ec2metadata --instance-id`-`ec2metadata --local-ipv4`"
ExecStart=/usr/bin/docker run --rm                                  \
    --name jenkins-agent                                            \
    --network jenkins                                               \
    --init                                                          \
    --tmpfs /tmp                                                    \
    --env "AGENT_NAME=$${NODE_ID}"                                  \
    --env "EXECUTORS=${executors}"                                  \
    --env "SERVER_URL=${server_url}"                                \
    --env "JENKINS_INSTANCE=${jenkins_instance}"                    \
    --env "AGENT_SECRET_ARN=${agent_secrets_arn}"                   \
    -v "/var/lib/jenkins/workspace:/var/lib/jenkins/workspace"      \
    -v "/var/lib/jenkins/jar-cache:/var/lib/jenkins/jar-cache"      \
    -v "/var/lib/jenkins/cache:/var/lib/jenkins/cache"              \
    -v "/var/lib/jenkins/logs:/var/lib/jenkins/logs"                \
    -v "/var/run/docker.sock:/var/run/docker.sock"                  \
    -v "/var/lib/jenkins/.ssh:/var/lib/jenkins/.ssh"                \
    -v "/var/lib/jenkins/.docker:/var/lib/jenkins/.docker"          \
    -v "/dev/urandom:/dev/random"                                   \
    '${image}:${tag}'

[Install]
WantedBy=multi-user.target
