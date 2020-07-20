## Purpose
Main account mysql ACME account registration.

## Workspaces
N/A.

## Secrets
```bash
# Create / Rotate
📦 $USER:~/cicdenv$ terraform/mysql/backend/bin/create-acme-key.sh
📦 $USER:~/cicdenv$ terraform/mysql/backend/bin/secrets-upload.sh

# Fetch into local checkout
📦 $USER:~/cicdenv$ terraform/mysql/backend/bin/secrets-download.sh
```

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> mysql/backend:main
...
```

## Importing
```hcl
data "terraform_remote_state" "mysql_backend" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/mysql_backend/terraform.tfstate"
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
    "alias" = "alias/mysql-secrets"
    "arn" = "arn:aws:kms:<region>:<main-acct-id>:key/<guid>"
    "key_id" = "<guid>"
  }
  "mysql" = {
    "arn" = "arn:aws:secretsmanager:<region>:<main-acct-id>:secret:mysql-<[a-z0-9]*6>"
    "name" = "mysql"
  }
}
```
