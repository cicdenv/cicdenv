[Unit]
Description=SSH AWS NLB target group health-check docker ssh container

[Service]
ExecStart=/usr/bin/docker run --rm      \
    --init                              \
    --name sshd-healthcheck             \
    --volume /root/.aws/sts:/root/.aws  \
    --env IAM_ROLE=${assume_role_arn}   \
    --publish ${healthcheck_port}:22    \
    sshd-worker                         \
    /opt/bin/sshd-healthcheck.sh
Restart=always

[Install]
WantedBy=multi-user.target
