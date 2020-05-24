## Purpose
Applies the kops update generated `kubernetes.tf` file 
for a single account (workspace) KOPS kubernetes cluster.

## Workspaces
This state is hard-wired to a single account/region.

## Usage
```
cicdenv$ cicdctl terraform <init|plan|apply|destroy> kops/clusters/${cluster_name}/cluster/${workspace}:${workspace}
...
```
