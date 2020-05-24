## Purpose
Terraform+KOPS helper modules.

These do the heavy lifting for the terraform kops "cluster home"
components generated from [terraform/kops/bin](../bin)

`cicdctl cluster create ...`

## Overiview
There are 3+ terraform components that go into a kops cluster:
* `terraform/kops/clusters/<cluster-name>/cluster-config`
* `terraform/kops/clusters/<cluster-name>/<workspace>/cluster`
* `terraform/kops/clusters/<cluster-name>/external-access`

The middle "component" above has the `kubernetes.tf` output
from kops - there will be one of these per cluster+workspace (account)
where the cluster has been launched.

`cicdctl cluster create|destroy ...` knows how to order operations
on thes components.

```
KOPS module                    Terraform component
* driver                       <cluster-home>/cluster-config
  * manifest
  * cluster     --> creates    <cluster-home>/<workspace>/cluster
    * commands
    * user kubeconfig
  * addons
* external-access              <cluster-home>/external-access
  * apiserver external-access
```