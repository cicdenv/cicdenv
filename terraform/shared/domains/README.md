## Purpose
The main account maintains Route53, ACM resources for the main domain.

NOTE: 
```
The main domain is "registered" with Route53 and not created/managed by terraform
```

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> shared/domains:main
...
```

## Importing
```hcl
data "terraform_remote_state" "acm" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared_domains/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
wildcard_site_cert = {
  "arn" = "arn:aws:acm:us-east-1:<main-acct-id>:certificate/<guid>"
}
```
