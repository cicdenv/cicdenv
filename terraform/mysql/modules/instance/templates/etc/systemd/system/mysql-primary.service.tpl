[Unit]
Description=MySQL Primary
After=docker.service mysql-disks.service mysql-network.service
Requires=docker.service mysql-disks.service mysql-network.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=/usr/bin/docker pull mysql:${image_tag}
ExecStart=/usr/bin/docker run --rm                                 \
    --name %p                                                      \
    --network mysql                                                \
    --publish 3306:3306                                            \
    --volume "/mnt/mysql-primary/conf:/etc/mysql/mysql.conf.d"     \
    --volume "/mnt/mysql-primary/data:/var/lib/mysql"              \
    --volume "/mnt/mysql-primary/sql:/docker-entrypoint-initdb.d"  \
    --volume "/root/.my.cnf:/root/.my.cnf"                         \
    mysql:${image_tag}
#ExecStartPost=-/usr/local/bin/systemd-send-email.sh "started" "%n" "${from}" "${to}"
#ExecStopPost=-/usr/local/bin/systemd-send-email.sh  "stopped" "%n" "${from}" "${to}"

[Install]
WantedBy=multi-user.target
