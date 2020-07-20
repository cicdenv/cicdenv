data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # systemd units and host sshd configuration
  part {
    merge_type   = "list(append)+dict(recurse_array)+str()"
    content      = <<EOF
#cloud-config
---
write_files:
- path: "/usr/local/bin/mysql"
  content: |
    ${indent(4, "${data.template_file.bin_mysql.rendered}")}
- path: "/usr/local/bin/wait-for-mysql.sh"
  content: |
    ${indent(4, "${data.template_file.bin_wait_for_mysql.rendered}")}
- path: "/usr/local/bin/mysql-set-security.sh"
  content: |
    ${indent(4, "${data.template_file.bin_mysql_set_security.rendered}")}
- path: "/etc/systemd/system/mysql-primary.service"
  content: |
    ${indent(4, "${data.template_file.mysql_primary_service.rendered}")}
- path: "/etc/systemd/system/mysql-replica.service"
  content: |
    ${indent(4, "${data.template_file.mysql_replica_service.rendered}")}
- path: "/usr/local/bin/mysql-disks.sh"
  content: |
    ${indent(4, file("${path.module}/files/usr/local/bin/mysql-disks.sh"))}
- path: "/etc/systemd/system/mysql-network.service"
  content: |
    ${indent(4, file("${path.module}/files/etc/systemd/system/mysql-network.service"))}
- path: "/etc/systemd/system/mysql-disks.service"
  content: |
    ${indent(4, file("${path.module}/files/etc/systemd/system/mysql-disks.service"))}
- path: "/etc/systemd/system/phpmyadmin-primary.service"
  content: |
    ${indent(4, file("${path.module}/files/etc/systemd/system/phpmyadmin-primary.service"))}
- path: "/etc/systemd/system/phpmyadmin-replica.service"
  content: |
    ${indent(4, file("${path.module}/files/etc/systemd/system/phpmyadmin-replica.service"))}
- path: "/usr/local/bin/create-replica-dump.sh"
  content: |
    ${indent(4, "${data.template_file.bin_create_replica_dump.rendered}")}
- path: "/etc/systemd/system/mysql-replica-dump.timer"
  content: |
    ${indent(4, "${data.template_file.mysql_replica_dump_timer.rendered}")}
- path: "/etc/systemd/system/mysql-replica-dump-failed.service"
  content: |
    ${indent(4, "${data.template_file.mysql_replica_dump_failed_service.rendered}")}
- path: "/etc/systemd/system/mysql-replica-dump.service"
  content: |
    ${indent(4, "${data.template_file.mysql_replica_dump_service.rendered}")}
- path: "/usr/local/bin/create-replica-snapshot.sh"
  content: |
    ${indent(4, "${data.template_file.bin_create_replica_snapshot.rendered}")}
- path: "/etc/systemd/system/mysql-replica-snapshot.timer"
  content: |
    ${indent(4, "${data.template_file.mysql_replica_snapshot_timer.rendered}")}
- path: "/etc/systemd/system/mysql-replica-snapshot-failed.service"
  content: |
    ${indent(4, "${data.template_file.mysql_replica_snapshot_failed_service.rendered}")}
- path: "/etc/systemd/system/mysql-replica-snapshot.service"
  content: |
    ${indent(4, file("${path.module}/files/etc/systemd/system/mysql-replica-snapshot.service"))}
EOF
  }

  part {
    content_type = "text/x-shellscript"
    content      = <<EOF
#!/bin/bash
set -eu -o pipefail

set -x

IMDSv2_TOKEN=$(curl -X PUT -H "X-aws-ec2-metadata-token-ttl-seconds: 30" -sL "http://169.254.169.254/latest/api/token")
export AWS_DEFAULT_REGION=$(curl -H "X-aws-ec2-metadata-token:$IMDSv2_TOKEN" -m5 -sS http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/.$//')

chmod +x /usr/local/bin/mysql
chmod +x /usr/local/bin/*.sh

# Time
timedatectl set-ntp yes

systemctl daemon-reload

# Create a container bridge network
systemctl enable mysql-network.service
systemctl start  mysql-network.service

# Configure disks
systemctl enable mysql-disks.service
systemctl start  mysql-disks.service

# Debug Disks
lsblk
find /mnt

docker pull mysql:${local.mysql_version}

# Set users / permissions
/usr/local/bin/mysql-set-security.sh

# Primary config
cat <<EOFF > /mnt/mysql-primary/conf/my.cnf
[mysqld]
pid-file=/var/run/mysqld/mysqld.pid
socket=/var/run/mysqld/mysqld.sock
datadir=/var/lib/mysql
symbolic-links=0

server_id=10000
binlog_format=ROW
log_bin=binlog
gtid_mode=ON
enforce_gtid_consistency=1
expire_logs_days=7
EOFF

# Replica config
cat <<EOFF > /mnt/mysql-replica/conf/my.cnf
[mysqld]
pid-file=/var/run/mysqld/mysqld.pid
socket=/var/run/mysqld/mysqld.sock
datadir=/var/lib/mysql
symbolic-links=0

server_id=10001
binlog_format=ROW
log_bin=binlog
log_slave_updates=1
gtid_mode=ON
enforce_gtid_consistency=1
relay_log=relay-bin
expire_logs_days=7
read_only=ON
EOFF

# Start the primary
systemctl enable mysql-primary.service
systemctl start  mysql-primary.service

# Wait for the primary to accept connections
/usr/local/bin/wait-for-mysql.sh 'primary'

# Start the replica
systemctl enable mysql-replica.service
systemctl start  mysql-replica.service

# Wait for the replica to accept connections
/usr/local/bin/wait-for-mysql.sh 'replica'

# Setup replication on the replica
/usr/local/bin/mysql -h mysql-replica -u root <<EOFF
stop slave;
reset slave;
reset master;
EOFF

# phpMyAdmin units
docker pull phpmyadmin/phpmyadmin
systemctl enable phpmyadmin-primary.service
systemctl start  phpmyadmin-primary.service
systemctl enable phpmyadmin-replica.service
systemctl start  phpmyadmin-replica.service
EOF
  }
}
