[Unit]
Description=SSH AWS NLB target group health-check docker ssh container
After=network.target

[Service]
Type=notify
ExecStart=/usr/bin/docker run --rm -i                                   \
                              --volume /root/.aws/sts:/root/.aws        \
                              --volume /dev/log:/dev/log                \
                              --env IAM_ROLE=${assume_role_arn}         \
                              --publish 0.0.0.0:${healthcheck_port}:22  \
                              sshd-worker                               \
                              /opt/bin/sshd-healthcheck.sh

[Install]
WantedBy=multi-user.target
