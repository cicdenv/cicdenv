[Unit]
Description=Perform replica sourced, consistent MySQL logical backups
After=mysql-replica.service
Conflicts=mysql-replica-snapshot.timer
OnFailure=mysql-replica-dump-failed.service

[Service]
Type=oneshot
ExecStartPre=/usr/bin/timeout  \
    --foreground 500           \
    /bin/bash -c               \
        'until [[ "$(/bin/systemctl is-active mysql-replica-snapshot.service)" == "inactive" ]]; do sleep 1; done'
ExecStartPre=/usr/bin/docker run --rm  \
    --network mysql                    \
    -v /root/.my.cnf:/root/.my.cnf     \
    mysql:${image_tag}                 \
    mysqladmin stop-slave              \
    -h mysql-replica                   \
    -u root
ExecStart=/bin/bash -c \
    '/usr/local/bin/create-replica-dump.sh || (/bin/systemctl start mysql-replica.service && false)'
ExecStopPost=/usr/local/bin/wait-for-mysql.sh replica
ExecStopPost=/usr/bin/docker run --rm                  \
    --network mysql                                    \
    -v /root/.my.cnf:/root/.my.cnf mysql:${image_tag}  \
    mysqladmin start-slave                             \
    -h mysql-replica                                   \
    -u root
ExecStopPost=/bin/systemctl start mysql-replica-snapshot.timer
