## Purpose
DynamoDB tables for account specific items (kops clusters).

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> data:${WORKSPACE}
...
```

## Importing
N/A.

## Outputs
```hcl
kops_clusters_dynamodb_table = {
  "hash_key" = "FQDN"
  "name" = "kops-clusters"
}
```
