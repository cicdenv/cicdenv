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
private_dns_zone = {
  "domain" = "<workspace>.<domain>"
  "name" = "<workspace>.<domain>."
  "name_servers" = [
    "ns-<N*>.awsdns-00.com.",
    "ns-<N*>.awsdns-00.org.",
    "ns-<N*>.awsdns-00.co.uk.",
    "ns-<N*>.awsdns-00.net.",
  ]
  "zone_id" = "Z<[A-Z0-9]*20>"
}
```
