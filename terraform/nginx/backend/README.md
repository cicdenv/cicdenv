## Purpose
Main account nginx ACME account registration.

## Workspaces
N/A.

## Secrets
```bash
# Create / Rotate
📦 $USER:~/cicdenv$ terraform/nginx/backend/bin/create-acme-key.sh
📦 $USER:~/cicdenv$ terraform/nginx/backend/bin/secrets-upload.sh

# Fetch into local checkout
📦 $USER:~/cicdenv$ terraform/nginx/backend/bin/secrets-download.sh
```

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> nginx/backend:main
...
```

## Importing
```hcl
data "terraform_remote_state" "nginx_backend" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/nginx_backend/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```
acme = {
  "registration" = {
    "id" = "https://acme-v02.api.letsencrypt.org/acme/acct/<[a-z0-9]*8>"
    "registration_url" = "https://acme-v02.api.letsencrypt.org/acme/acct/<[a-z0-9]*8>"
  }
}
secrets = {
  "key" = {
    "alias" = "alias/nginx-secrets"
    "arn" = "arn:aws:kms:<region>:<main-acct-id>:key/<guid>"
    "key_id" = "<guid>"
  }
  "nginx" = {
    "arn" = "arn:aws:secretsmanager:<region>:<main-acct-id>:secret:nginx-<[a-z0-9]*6>"
    "name" = "nginx"
  }
}
```
