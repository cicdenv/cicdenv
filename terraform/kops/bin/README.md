## Purpose
This is a simple dynamic terraform component generator.

For each kops cluster we generate 2 workspaced states in the
"cluster home" folder:
`terraform/kops/clusters/<cluster-name>`

This script generates the `kops` and `external-access` states:
* `terraform/kops/clusters/<cluster-name>/kops`
* `terraform/kops/clusters/<cluster-name>/external-access`

Running the `kops` state uses `kops update` terraform output to create
a `cluster` state for each workspace when applied:
* `terraform/kops/clusters/<cluster-name>/<workspace>/cluster`

The `cluster` state being per workspace (account) - but not "workspaced" may seem
odd at first.
This is necessary because kops generates a "literal" `kubernetes.tf` terraform
component that is hard-wired to one accounts `network/shared` VPC.

## Usage
NOTE: generally us `cicdctl cluster create ...` for creating kops clusters
```bash
cicdenv$ terraform/kops/bin/generate-cluster-states.sh 1-18a3
cicdenv$ terraform/kops/bin/generate-cluster-states.sh 1-18a3 node_instance_type=r5dn.2xlarge node_count=6
```
