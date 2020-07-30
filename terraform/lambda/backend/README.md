## Purpose
Main account lambda support.

* shared zip archive bucket

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> lambda/backend:main
...
```

## Importing
```hcl
data "terraform_remote_state" "lambda" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/lambda_backend/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
lambda = {
  "bucket" = {
    "arn" = "arn:aws:s3:::lambda-<domain->"
    "id" = "lambda-<domain->"
    "name" = "lambda-<domain->"
  }
}
```
