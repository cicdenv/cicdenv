## Purpose
Closes open SSH sessions on a bastion service instance an
IAM user's access is revoked.

Registers with the [terraform/iam/events] `iam-user-updates` SNS topic.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> shared/ecr-images/bastion-sns-subscriber:main
...
```

## Created
```bash
📦 $USER:~/cicdenv/shared/ecr-images/bastion-sns-subscriber$ make
```
