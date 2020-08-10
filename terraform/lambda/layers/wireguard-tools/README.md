## Purpose
Tools for configuring WireGuard (/usr/bin/wg)
for use in lambda secrets manager secret rotation.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> lambda/layers/wireguard-tools:main
...
```

## Builds
```bash
cicdenv$ (cd terraform/lambda/layers/wireguard-tools; make build package)
cicdenv$ (cd terraform/lambda/layers/wireguard-tools; make upload)
```

## Resource Policy
```bash
export AWS_PROFILE=admin-main

org_id=$(cd terraform/backend; terraform output -json organization | jq -r '.id')
version=$(aws lambda list-layer-versions \
    --layer-name "wireguard-tools" --no-paginate --query 'sort_by(LayerVersions, &Version)[-1].Version')
aws lambda add-layer-version-permission  \
--layer-name "wireguard-tools"           \
--version-number "$version"              \
--statement-id xaccount-getlayerversion  \
--action lambda:GetLayerVersion          \
--principal '*'                          \
--organization-id "$org_id"              \
--output text
```

## Importing
```hcl
data "terraform_remote_state" "wireguard-tools_layer" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/lambda_layers_wireguard-tools/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
layer = {
  "arn" = "arn:aws:lambda:<region>:<main-acct-id>:layer:wireguard-tools:2"
  "compatible_runtimes" = [
    "python3.8",
  ]
  "id" = "arn:aws:lambda:<region>:<main-acct-id>:layer:wireguard-tools:2"
  "layer_name" = "wireguard-tools"
  "license_info" = "MIT"
  "version" = "2"
}
```
