## Purpose
GnuPG is a complete implementation of the OpenPGP standard as defined by 
[RFC4880](https://tools.ietf.org/html/rfc4880) 
(also known as PGP).

* https://gnupg.org/

The lambda python 3.8+ (Amazon Linux 2) runtime no longer includes gnupg2.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> lambda/layers/gnupg2:main
...
```

## Builds
```bash
# Generate the layer archive
cicdenv$ (cd terraform/lambda/layers/gnupg2; make build test package)

# Publish
📦 $USER:~/cicdenv$ (cd terraform/lambda/layers/gnupg2; make upload)

# Push new version
cicdenv$ cicdctl terraform apply lambda/layers/gnupg2:main -auto-approve

# Update cross account perms
📦 $USER:~/cicdenv$ (cd terraform/lambda/layers/gnupg2; make permissions)
```

## Importing
```hcl
data "terraform_remote_state" "gnupg2_layer" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/lambda_layers_gnupg2/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
layer = {
  "arn" = "arn:aws:lambda:<region>:<main-acct-id>:layer:gnupg2:2"
  "compatible_runtimes" = [
    "python3.8",
  ]
  "id" = "arn:aws:lambda:<region>:<main-acct-id>:layer:gnupg2:2"
  "layer_name" = "gnupg2"
  "license_info" = "MIT"
  "version" = "2"
}
```
