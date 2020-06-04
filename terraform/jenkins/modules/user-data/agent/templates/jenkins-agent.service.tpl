[Unit]
Description=Jenkins Agent
Requires=docker.service jenkins-agent-disks.service jenkins-network.service
After=docker.service jenkins-agent-disks.service jenkins-network.service
StartLimitIntervalSec=10
StartLimitBurst=2

[Service]
TimeoutStartSec=0
Restart=always
RestartSec=1
EnvironmentFile=/etc/systemd/system/jenkins-agent.env
ExecStartPre=/usr/bin/docker pull ${ecr_url}:$${TAG}
ExecStartPre=/usr/bin/docker tag ${ecr_url}:$${TAG} ${image}:$${TAG}
ExecStartPre=/bin/bash -c "/bin/systemctl set-environment NODE_ID=`/usr/local/bin/ec2-metadata --instance-id | awk '{print $$2}'`-`/usr/local/bin/ec2-metadata --local-ipv4 | awk '{print $$2}'`"
ExecStart=/usr/bin/docker run --rm                                  \
    --name jenkins-agent                                            \
    --network jenkins                                               \
    --init                                                          \
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
    -v "/var/lib/jenkins/.aws:/var/lib/jenkins/.aws"                \
    -v "/dev/urandom:/dev/random"                                   \
    '${image}:$${TAG}'

[Install]
WantedBy=multi-user.target
