[Unit]
Description=SSH Per-Connection docker ssh container

[Service]
Type=simple
ExecStart=/usr/bin/docker run --rm -i                             \
                              --hostname ${host_name}-%i          \
                              --volume /root/.aws/sts:/root/.aws  \
                              --volume /dev/log:/dev/log          \
                              --volume /var/log/sshd-workers:/var/log/sshd-workers  \
                              --env IAM_ROLE=${assume_role_arn}   \
                              --env REMOTE_ADDR=$REMOTE_ADDR      \
                              --env REMOTE_PORT=$REMOTE_PORT      \
                              --env WORKER_ID=%i                  \
                              sshd-worker
StandardInput=socket
RuntimeMaxSec=43200

[Install]
WantedBy=multi-user.target
