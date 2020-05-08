## Purpose
Creates external API server access for a single account (workspace) KOPS kubernetes external-access.

## Workspaces
This state is per-account.

## Usage
```
cicdenv$ cicdctl <init|plan|apply|destroy|output> kops/clusters/1-18a/external-access:${WORKSPACE}
...
```
