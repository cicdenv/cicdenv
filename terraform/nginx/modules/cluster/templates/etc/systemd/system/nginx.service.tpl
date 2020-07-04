[Unit]
Description=NGINX Plus
Requires=docker.service nginx-disks.service
After=docker.service nginx-disks.service
StartLimitIntervalSec=10
StartLimitBurst=2

[Service]
TimeoutStartSec=0
Restart=always
RestartSec=1
EnvironmentFile=/etc/systemd/system/nginx.env
ExecStartPre=-/usr/bin/env
ExecStartPre=-/usr/bin/docker stop "%p"
ExecStartPre=-/usr/bin/docker rm "%p"
ExecStartPre=/usr/bin/docker pull ${ecr_url}:$${TAG}
ExecStartPre=/usr/bin/docker tag ${ecr_url}:$${TAG} ${image}:$${TAG}
ExecStart=/usr/bin/docker run --rm                                                     \
    --name "%p"                                                                        \
    --net host                                                                         \
    --volume "/etc/localtime:/etc/localtime:ro"                                        \
    --volume "/dev/urandom:/dev/random:ro"                                             \
    --volume "/etc/nginx/nginx.conf:/etc/nginx/nginx.conf:ro,z"                        \
    --volume "/etc/nginx/conf.d:/etc/nginx/conf.d:ro,z"                                \
    --volume "/usr/share/nginx/html/index.html:/usr/share/nginx/html/index.html:ro,z"  \
    --volume "/etc/nginx/certs:/etc/nginx/certs:ro,z"                                  \
    --volume "/var/log/nginx:/var/log/nginx:z"                                         \
    '${image}:$${TAG}'
ExecReload=/usr/bin/docker exec "%p" nginx -s reload

[Install]
WantedBy=multi-user.target
