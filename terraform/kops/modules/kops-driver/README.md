## Purpose
The `terraform/kops/clusters/<cluster-name>/cluster-config` is
a simple generated component that uses this module to source 
the settings needed to "create" a kops cluster and generate the
`terraform/kops/clusters/<cluster-name>/<workspace>/cluster`
component.

## Exports
Cluster settings needed by:
* `terraform/kops/clusters/<cluster-name>/<workspace>/cluster`
* `terraform/kops/clusters/<cluster-name>/external-access`
