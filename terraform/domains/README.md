## Purpose
Route53 public / private DNS zones for the target account.

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> domains:${WORKSPACE}
...
```
