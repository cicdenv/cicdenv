## Host Config
```
# template: /usr/local/bin/mysql
# template: /usr/local/bin/mysql-set-security.sh
# template: /usr/local/bin/wait-for-mysql.sh

# files: /usr/local/bin/mysql-disks.sh
# files: /etc/systemd/system/mysql-network.service
# files: /etc/systemd/system/mysql-disks.service
# files: /etc/systemd/system/phpmyadmin-primary.service
# files: /etc/systemd/system/phpmyadmin-replica.service

# MySQL Core Services
# template: /etc/systemd/system/mysql-primary.service
# template: /etc/systemd/system/mysql-replica.service

# Dumps
# template: /usr/local/bin/create-replica-dump.sh
# template: /etc/systemd/system/mysql-replica-dump.timer
# template: /etc/systemd/system/mysql-replica-dump-failed.service
# template: /etc/systemd/system/mysql-replica-dump.service

# Snapshots
# template: /usr/local/bin/create-replica-snapshot.sh
# template: /etc/systemd/system/mysql-replica-snapshot.timer
# template: /etc/systemd/system/mysql-replica-snapshot-failed.service
# file:     /etc/systemd/system/mysql-replica-snapshot.service
```
