## Purpose
Terraform+KOPS helper modules.

These do the heavy lifting for the terraform kops "cluster home"
components generated from [terraform/kops/bin](../bin)

`cicdctl cluster create ...`

## Cluster ID
```
${name}                         =>  "cluster name"
${name}:${workspace}            =>  "cluster instance name"
${name}-${workspace}.${domain}  =>  "cluster instance fqdn"
```

Example:  `name=1-18a3`
```
1-18a3
1-18a3:dev
1-18a3-dev.kops.cicdenv.com
```

## Overiview
There are 3+ terraform components that go into a kops cluster:
* `terraform/kops/clusters/<cluster-name>/kops`
* `terraform/kops/clusters/<cluster-name>/cluster/<workspace>`
* `terraform/kops/clusters/<cluster-name>/external-access`

The middle "component" above has the `kubernetes.tf` output
from kops - there will be one of these per cluster+workspace (account)
where the cluster has been launched.

`cicdctl cluster create|destroy ...` knows how to order operations
on thes components.

```
KOPS module                    Terraform component
* driver                       <cluster-home>/kops
  * manifest
  * cluster     --> creates    <cluster-home>/<workspace>/cluster
    * commands
    * user kubeconfig
  * addons
* external-access              <cluster-home>/external-access
```