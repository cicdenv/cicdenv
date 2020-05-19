[Unit]
Description=SSH Per-Connection docker ssh container

[Service]
Type=simple
ExecStart=/usr/bin/docker run --rm -i                            \
                              --hostname ${host_name}-%i         \
                              --volume /dev/log:/dev/log         \
                              --env IAM_ROLE=${assume_role_arn}  \
                              sshd-worker
StandardInput=socket
RuntimeMaxSec=43200

[Install]
WantedBy=multi-user.target
