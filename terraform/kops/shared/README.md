## Purpose
Common resources for all KOPS kubernetes clusters in the same region/account.

## Workspaces
This state is per-account.

## Usage
```
cicdenv$ cicdctl <init|plan|apply|destroy|output> kops/shared:${WORKSPACE}
...
```
