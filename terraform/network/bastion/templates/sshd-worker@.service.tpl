[Unit]
Description=SSH Per-Connection docker ssh container
After=redis-server.service

[Service]
ExecStart=/usr/bin/docker run --rm -i                              \
    --name sshd-worker-%i                                          \
    --hostname ${host_name}-%i                                     \
    --volume /root/.aws/sts/credentials:/root/.aws/credentials:ro  \
    --volume /dev/log:/dev/log                                     \
    --volume /var/run/redis/sock:/var/run/redis/sock               \
    --env IAM_ROLE=${assume_role_arn}                              \
    --env REMOTE_ADDR=$REMOTE_ADDR                                 \
    --env REMOTE_PORT=$REMOTE_PORT                                 \
    --env WORKER_ID=%i                                             \
    --log-driver none                                              \
    sshd-worker

StandardInput=socket
RuntimeMaxSec=43200

[Install]
WantedBy=multi-user.target
