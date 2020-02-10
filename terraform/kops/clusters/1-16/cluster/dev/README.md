## Purpose
Applies the generated terraform for a single account (workspace) KOPS kubernetes cluster.

## Workspaces
This state is hard-wired to a single account/region.

## Usage
```
cicdenv$ cicdctl <init|plan|apply|destroy> kops/clusters/1-16/cluster/dev:dev
...
```