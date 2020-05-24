## Purpose
Creates a kops cluster for a workspace (account), and
produces a terraform component for it in:
* `terraform/kops/clusters/<cluster-name>/<workspace>/cluster`

This process "creates" a kops cluster in the state store.
"Updates" that cluster into a `kubernetes.tf` terraform file.
The cluster gets realized in AWS when the
`terraform/kops/clusters/<cluster-name>/<workspace>/cluster`
component is applied.

Also this module produces admin token and user kubeconfig files
used by `cicdctl kops|kubectl` commands.

## Exports
Some kops command lines.
