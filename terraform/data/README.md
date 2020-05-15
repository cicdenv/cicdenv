## Purpose
DynamoDB tables for account specific items (kops clusters).

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> data:${WORKSPACE}
...
```
