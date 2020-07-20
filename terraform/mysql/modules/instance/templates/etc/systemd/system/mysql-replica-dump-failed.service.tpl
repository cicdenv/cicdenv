[Unit]
Description=Failure handling for mysql-replica-dump.service

[Service]
Type=oneshot
#ExecStartPre=-/usr/local/bin/systemd-send-email.sh  \
#    "replica dump failed"                           \
#    "mysql-replica-dump.service"                    \
#    "${from}"                                       \
#    "${to}"
ExecStart=/usr/bin/docker run --rm   \
     --network mysql                 \
     -v /root/.my.cnf:/root/.my.cnf  \
     mysql:${image_tag}              \
     mysqladmin start-slave          \
     -h mysql-replica                \
     -u root
ExecStopPost=/bin/systemctl start mysql-replica-snapshot.timer
