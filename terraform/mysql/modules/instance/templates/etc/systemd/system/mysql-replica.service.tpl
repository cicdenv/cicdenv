[Unit]
Description=MySQL Replica
After=docker.service mysql-disks.service mysql-network.service
Requires=docker.service mysql-disks.service mysql-network.service mysql-primary.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=/usr/bin/docker pull mysql:${image_tag}
ExecStart=/usr/bin/docker run --rm                                 \
    --name %p                                                      \
    --network mysql                                                \
    --publish 3307:3306                                            \
    --volume "/mnt/mysql-replica/conf:/etc/mysql/mysql.conf.d"     \
    --volume "/mnt/mysql-replica/data:/var/lib/mysql"              \
    --volume "/mnt/mysql-replica/sql:/docker-entrypoint-initdb.d"  \
    --volume "/root/.my.cnf:/root/.my.cnf"                         \
    mysql:${image_tag}

[Install]
WantedBy=multi-user.target
