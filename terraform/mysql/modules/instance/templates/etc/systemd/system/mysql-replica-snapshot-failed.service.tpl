[Unit]
Description=Failure handling for mysql-replica-snapshot.service

[Service]
Type=oneshot
#ExecStartPre=-/usr/local/bin/systemd-send-email.sh  \
#    "replica snapshot failed"                       \
#    "mysql-replica-snapshot.service"                \
#    "${from}"                                       \
#    "${to}"
ExecStartPre=/bin/systemctl start mysql-replica.service
ExecStart=/usr/local/bin/wait-for-mysql.sh replica
ExecStopPost=/bin/systemctl start mysql-replica-dump.timer
