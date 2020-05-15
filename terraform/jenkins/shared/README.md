## Purpose
Jenkins resources that live in sub-accounts account.

* s3 buckets
  * build cache
  * build records
* iam roles
  * servers / agents
  * colocated server+agent single instance (colo)
* security groups
  * servers / agents
  * colocated server+agent single instance (colo)

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> jenkins/common:${WORKSPACE}
...
```
