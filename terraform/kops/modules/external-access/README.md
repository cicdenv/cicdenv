## Purpose
The `terraform/kops/clusters/<cluster-name>/external-access` is
a simple generated component that uses this module to create a
custom "external" ingresses to the kops cluster master nodes which
reside in private subnets.

Currently generates 1 Classic load balancer per
`cluster-name:workspace`.

## Exports
The load balancer DNS info where kuberenetes API server can be
reached for the `cluster-name:workspace`.
