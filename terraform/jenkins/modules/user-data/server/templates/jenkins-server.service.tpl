[Unit]
Description=Jenkins Server
Requires=docker.service jenkins-server-disks.service jenkins-network.service
After=docker.service jenkins-server-disks.service jenkins-network.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=/usr/bin/docker pull ${ecr_url}:${tag}
ExecStartPre=/usr/bin/docker tag ${ecr_url}:${tag} ${image}:${tag}
ExecStart=/usr/bin/docker run --rm                                                              \
    --name jenkins-server                                                                       \
    --network jenkins                                                                           \
    --init                                                                                      \
    --tmpfs /tmp                                                                                \
    -p 8080:8080                                                                                \
    -p 5000:5000                                                                                \
    -p 16022:16022                                                                              \
    --env "SERVER_URL=${server_url}"                                                            \
    --env "JENKINS_INSTANCE=${jenkins_instance}"                                                \
    --env "GITHUB_SECRET_ARN=${github_secret_arn}"                                              \
    -v "/var/jenkins_workspace:/var/jenkins_home/workspace"                                     \
    -v "/var/jenkins_builds:/var/jenkins_home/builds"                                           \
    -v "/var/jenkins_home/logs:/var/jenkins_home/logs                                           \
    -v "/var/jenkins_home/userContent:/var/jenkins_home/userContent                             \
    -v "/var/jenkins_home/jobs:/var/jenkins_home/jobs                                           \
    -v "/var/jenkins_home/nodes:/var/jenkins_home/nodes                                         \
    -v "/var/jenkins_home/users:/var/jenkins_home/users                                         \
    -v "/var/jenkins_home/secrets:/var/jenkins_home/secrets                                     \
    -v "/var/jenkins_home/identity.key.enc:/var/jenkins_home/identity.key.enc"                  \
    -v "/var/jenkins_home/secret.key:/var/jenkins_home/secret.key"                              \
    -v "/var/jenkins_home/secret.key.not-so-secret:/var/jenkins_home/secret.key.not-so-secret"  \
    -v "/var/lib/jenkins/.ssh:/var/lib/jenkins/.ssh"                                            \
    -v "/dev/urandom:/dev/random"                                                               \
    '${image}:${tag}'

[Install]
WantedBy=multi-user.target
