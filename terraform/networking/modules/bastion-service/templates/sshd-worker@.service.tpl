[Unit]
Description=SSH Per-Connection docker ssh container

[Service]
Type=simple
ExecStart=/usr/bin/docker run --rm -i \
                              --hostname ${host_name}-%i \
                              --volume /dev/log:/dev/log \
                              --volume /opt/sshd-service:/opt:ro \
                              --volume /opt/sshd-service/sshd_config:/etc/ssh/sshd_config:ro \
                              --volume /opt/sshd-service/nsswitch.conf:/etc/nsswitch.conf:ro \
                              sshd-worker
StandardInput=socket
RuntimeMaxSec=43200

[Install]
WantedBy=multi-user.target
