#!/bin/bash

set -eu -o pipefail

IMDSv2_TOKEN=$(curl -X PUT -H "X-aws-ec2-metadata-token-ttl-seconds: 30" -sL "http://169.254.169.254/latest/api/token")
export AWS_DEFAULT_REGION=$(curl -H "X-aws-ec2-metadata-token:$IMDSv2_TOKEN" -m5 -sS http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/.$//')

now=$(date +%Y-%m-%d-%H%M)
instance_id=$(curl -H "X-aws-ec2-metadata-token:$IMDSv2_TOKEN" -m5 -sS http://instance-data/latest/dynamic/instance-identity/document | jq -r '.instanceId')

volume_id="$(/usr/local/bin/aws                                                     \
    ec2 describe-instances                                                          \
        --instance-id "$instance_id"                                                \
        --query 'Reservations[*].Instances[*].BlockDeviceMappings[2].Ebs.VolumeId'  \
        --output text)"
snapshot_id="$(/usr/local/bin/aws \
    ec2 create-snapshot           \
        --volume-id "$volume_id"  \
        --description="MySQL Replica ${name}-${id} $now $instance_id (/dev/xvdg)" \
        --tag-specifications "ResourceType=snapshot,Tags=[{Key=Name,Value=${name}/$${now}-${id}-$${instance_id}},{Key=Group,Value=${name}},{Key=Id,Value=${id}},{Key=Source,Value=$${instance_id}},{Key=Timestamp,Value=$${now}}]" \
        --query 'SnapshotId' --output text)"
progress=$(/usr/local/bin/aws ec2 describe-snapshots --snapshot-ids "$snapshot_id" --query "Snapshots[*].Progress" --output text)
while [ $progress != "100%" ]
do
  sleep 5
  echo "Waiting for slave snapshot $snapshot_id. $progress done"
  progress=$(/usr/local/bin/aws ec2 describe-snapshots --snapshot-ids "$snapshot_id" --query "Snapshots[*].Progress" --output text)
done
/usr/local/bin/aws ec2 wait snapshot-completed --snapshot-ids "$snapshot_id"
