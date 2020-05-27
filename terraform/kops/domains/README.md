## Purpose
Shared public AWS Route53 hosted zone for kops kubernetes clusters.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy|output> kops/domains:main
...
```

## Importing
```hcl
data "terraform_remote_state" "domains" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/kops_domains/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
kops_public_zone = {
  "domain" = "kops.<domain>"
  "name" = "kops.<domain>."
  "zone_id" = "Z<[A-Z0-9]*20>"
}
```
