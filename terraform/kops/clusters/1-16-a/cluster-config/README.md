## Purpose
One time bootstrap for a single account (workspace) KOPS kubernetes cluster.

## Workspaces
This state is per-account.

## Usage
```
cicdenv$ cicdctl <init|plan|apply|destroy|output> kops/clusters/1-16-a/cluster-config:${WORKSPACE}
...
```
