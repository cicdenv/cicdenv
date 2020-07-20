#!/bin/bash

set -eu -o pipefail

IMDSv2_TOKEN=$(curl -X PUT -H "X-aws-ec2-metadata-token-ttl-seconds: 30" -sL "http://169.254.169.254/latest/api/token")
export AWS_DEFAULT_REGION=$(curl -H "X-aws-ec2-metadata-token:$IMDSv2_TOKEN" -m5 -sS http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/.$//')

now=$(date +%Y-%m-%d-%H%M)
instance_id=$(curl -H "X-aws-ec2-metadata-token:$IMDSv2_TOKEN" -m5 -sS http://instance-data/latest/dynamic/instance-identity/document | jq -r '.instanceId')
key="/dumps/${name}/$${now}-${id}-$${instance_id}.sql"

/usr/bin/docker run -i --rm               \
    --network mysql                       \
    --volume /root/.my.cnf:/root/.my.cnf  \
    mysql:${image_tag}                    \
    mysqldump -h mysql-replica            \
        --databases ${databases}          \
        --add-drop-database               \
        --complete-insert                 \
        --extended-insert                 \
        --compress                        \
        --hex-blob                        \
        --events                          \
        --routines                        \
        --master-data=2                   \
        --single-transaction              \
        --set-gtid-purged=ON              \
| /usr/local/bin/aws s3 cp - "s3://${bucket}/$${key}"

/usr/local/bin/aws s3api put-object-tagging \
--bucket ${bucket} \
--key $${key} \
--tagging "TagSet=[{Key=Group,Value=${name}},{Key=Id,Value=${id}},{Key=Source,Value=$${instance_id}},{Key=Timestamp,Value=$${now}}]"
