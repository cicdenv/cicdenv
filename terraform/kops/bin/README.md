# KOPS State Generator

## Purpose
Each kops kubernetes cluster has two workspaced states per cluster.

This script generates the `cluster-config` and `external-access` states.

Running the `cluster-config` state uses kops terraform output to create
a cluster state for each workspace.

## Usage
```
cicdenv$ terraform/kops/bin/generate-cluster-states.sh 1-12
```
