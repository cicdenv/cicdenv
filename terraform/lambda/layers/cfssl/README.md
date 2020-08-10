## Purpose
Cloudflare's PKI and TLS toolkit
for use by lambda secrets manager secrets rotation.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> lambda/layers/cfssl:main
...
```

## Builds
```bash
cicdenv$ (cd terraform/lambda/layers/cfssl; make package)
cicdenv$ (cd terraform/lambda/layers/cfssl; make upload)
```

## Resource Policy
```bash
export AWS_PROFILE=admin-main

org_id=$(cd terraform/backend; terraform output -json organization | jq -r '.id')
version=$(aws lambda list-layer-versions \
    --layer-name "cfssl" --no-paginate --query 'sort_by(LayerVersions, &Version)[-1].Version')
aws lambda add-layer-version-permission  \
--layer-name "cfssl"                     \
--version-number "$version"              \
--statement-id xaccount-getlayerversion  \
--action lambda:GetLayerVersion          \
--principal '*'                          \
--organization-id "$org_id"              \
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
