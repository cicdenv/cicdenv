## Purpose
...

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> lambda/layers/cfssl:main
...
```

## Resource Policy
```bash
export AWS_PROFILE=admin-main

org_id=$(cd terraform/backend; terraform output -json organization | jq -r '.id')

aws lambda add-layer-version-permission \
--layer-name "cfssl" \
--version-number 2 \
--statement-id xaccount-getlayerversion \
--action lambda:GetLayerVersion \
--principal '*' \
--organization-id "$org_id" \
--output text
```

## Importing
```hcl
data "terraform_remote_state" "cfssl_layer" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/lambda_layers_cfssl/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
layer = {
  "arn" = "arn:aws:lambda:<region>:<main-acct-id>:layer:cfssl:2"
  "compatible_runtimes" = [
    "python3.8",
  ]
  "id" = "arn:aws:lambda:<region>:<main-acct-id>:layer:cfssl:2"
  "layer_name" = "cfssl"
  "license_info" = "MIT"
  "version" = "2"
}
```
