## Purpose
Creates a "user" kubeconfig file for accessing one kops cluster.

This file is kept in `terraform/kops/clusters/<cluster-name>/<workspace>/cluster`.

A "user" kubeconfig uses AWS sts and `aws-iam-authenticator` to create a non-admin
JWT for accessing kubernetes API server.

## Exports
None.
