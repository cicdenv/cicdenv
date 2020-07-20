#!/bin/bash

set -eu -o pipefail

# MySQL container name {primary|replica}
name=$${1?"<name> required.  One of: {primary|replica}"}; shift

retries=30
sleep=1 # secs

timeout --foreground $(( $retries * $sleep ))  \
docker run --rm --init                         \
    --network=mysql                            \
    --volume "/root/.my.cnf:/root/.my.cnf"     \
    mysql:${image_tag}                         \
bash -c "echo 'waiting for mysql $${name}...';
until mysql -h mysql-$${name} -u root --execute=status &>/dev/null; do 
    echo -n '.'; sleep $sleep;
done"
echo ""
