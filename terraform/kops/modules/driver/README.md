## Purpose
The `terraform/kops/clusters/<cluster-name>/kops` is
a simple generated component that uses this module to source 
the settings needed to "create" a kops cluster and generate the
`terraform/kops/clusters/<cluster-name>/cluster/<workspace>`
component.

## Exports
Cluster settings needed by:
* `terraform/kops/clusters/<cluster-name>/cluster/<workspace>`
* `terraform/kops/clusters/<cluster-name>/external-access`
