## Purpose
Route53 public / private DNS zones for the target account.

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> domains:${WORKSPACE}
...
```

## Importing
```hcl
data "terraform_remote_state" "domains" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/domains/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
account_public_zone = {
  "domain" = "<workspace>.<domain>"
  "name" = "<workspace>.<domain>."
  "zone_id" = "..."
}
main_public_zone = {
  "domain" = "<domain>"
  "name" = "<domain>."
  "zone_id" = "..."
}
```
