## Purpose
Main account IAM user/public-key change events.

The motivation is this enables a service running on bastion instances
to close sessions for IAM users whose host access has been revoked.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> iam/events:main
...
```
