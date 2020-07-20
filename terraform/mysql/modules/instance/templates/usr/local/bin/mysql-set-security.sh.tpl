#!/bin/bash

set -eu -o pipefail

function get_secret () {
    /usr/local/bin/aws secretsmanager  \
        get-secret-value               \
        --secret-id "${secret_arn}"    \
        --version-stage 'AWSCURRENT'   \
        --query  'SecretString'        \
    | jq -r "fromjson | .[\"$${1}\"]"
}

#
# Start password-less MySQL
#
function start_mysql () {
    docker run --rm -d                                               \
        --name "mysql-$${1}"                                         \
        --env MYSQL_ALLOW_EMPTY_PASSWORD=true                        \
        --network mysql                                              \
        --volume "/mnt/mysql-$${1}/conf:/etc/mysql/mysql.conf.d"     \
        --volume "/mnt/mysql-$${1}/data:/var/lib/mysql"              \
        --volume "/mnt/mysql-$${1}/sql:/docker-entrypoint-initdb.d"  \
        mysql:${image_tag}
}

#
# Wait for the MySQL to accept connections
#
function wait_for_mysql () {
    retries=30
    sleep=1 # secs
    
    timeout --foreground $(( $retries * $sleep ))  \
    docker run --rm --init                         \
        --network=mysql                            \
        mysql:${image_tag}                         \
    bash -c "echo 'waiting for mysql $${1}...';
    until mysql -h 'mysql-$${1}' -u root --execute=status &>/dev/null; do 
        echo -n '.'; sleep $sleep;
    done"
    echo ""
}

#
# Set MySQL users / permissions
#
function set_security () {
    docker run -i --rm --network mysql  \
        mysql:${image_tag}              \
        mysql -h "mysql-$${1}" -u root <<EOF
use mysql;

-- root user
alter user 'root'@'localhost' identified with caching_sha2_password by '$${root_passwd}';
alter user 'root'@'%'         identified with caching_sha2_password by '$${root_passwd}';
update mysql.user set host='172.18.0.%' where user='root' and host='%';

-- replication user
create user 'replication'@'172.18.0.%' identified with caching_sha2_password by '$${replication_passwd}';
grant replication slave on *.* to 'replication'@'172.18.0.%';

-- backup user
create user 'backup'@'172.18.0.%' identified with caching_sha2_password by '$${backup_passwd}';
grant select, lock tables, show view, event, trigger on *.*        to 'backup'@'172.18.0.%';
grant reload, replication client                     on *.*        to 'backup'@'172.18.0.%';

flush privileges;
EOF
}

#
# Stop MySQL using password-less client config
#
function stop_mysql () {
    docker run --rm --network mysql             \
        --volume "/root/.my.cnf:/root/.my.cnf"  \
        mysql:${image_tag}                      \
        mysqladmin shutdown -h "mysql-$${1}" -u root
}

       root_passwd=$(get_secret 'root-password')
replication_passwd=$(get_secret 'replication-password')
     backup_passwd=$(get_secret 'backup-password')

# Password-less client, mysqldump connections for local root linux user
cat <<EOF > /root/.my.cnf
[client]
password=$${root_passwd}

[mysqldump]
user=backup
password=$${backup_passwd}
EOF
chmod go-rwx /root/.my.cnf

for mysql_instance in 'primary' 'replica'; do
    start_mysql    "$mysql_instance"
    wait_for_mysql "$mysql_instance"
    set_security   "$mysql_instance"
    stop_mysql     "$mysql_instance"
done
