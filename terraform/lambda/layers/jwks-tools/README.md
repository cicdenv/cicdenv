## Purpose
Tools for creating JSON web key sets (jwks) key + config
for use in lambda secrets manager secret rotation.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> lambda/layers/jwks:main
...
```

## Builds
```bash
# Generate the layer archive
cicdenv$ (cd terraform/lambda/layers/jwks-tools; make build test package)

# Publish
📦 $USER:~/cicdenv$ (cd terraform/lambda/layers/jwks-tools; make upload)

# Push new version
cicdenv$ cicdctl terraform apply lambda/layers/jwks:main -auto-approve

# Update cross account perms
📦 $USER:~/cicdenv$ (cd terraform/lambda/layers/jwks-tools; make permissions)
```

## Importing
```hcl
data "terraform_remote_state" "jwks-tools_layer" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/lambda_layers_jwks-tools/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
layer = {
  "arn" = "arn:aws:lambda:<region>:<main-acct-id>:layer:jwks-tools:2"
  "compatible_runtimes" = [
    "python3.8",
  ]
  "id" = "arn:aws:lambda:<region>:<main-acct-id>:layer:jwks-tools:2"
  "layer_name" = "jwks-tools"
  "license_info" = "MIT"
  "version" = "2"
}
```
