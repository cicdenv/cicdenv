## Purpose
...

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> nginx/backend:main
...
```

## Secrets
```bash
📦 $USER:~/cicdenv$ terraform/nginx/backend/bin/secrets-upload.sh

📦 $USER:~/cicdenv$ terraform/nginx/backend/bin/secrets-download.sh
```

## Outputs
```
acme = {
  "registration" = {
    "id" = "https://acme-v02.api.letsencrypt.org/acme/acct/90372376"
    "registration_url" = "https://acme-v02.api.letsencrypt.org/acme/acct/90372376"
  }
}
secrets = {
  "key" = {
    "alias" = "alias/nginx-secrets"
    "arn" = "arn:aws:kms:us-west-2:014719181291:key/6d404c00-25d2-4789-b768-2c85c710ba4c"
    "key_id" = "6d404c00-25d2-4789-b768-2c85c710ba4c"
  }
  "nginx" = {
    "arn" = "arn:aws:secretsmanager:us-west-2:014719181291:secret:nginx-4PCFVB"
    "name" = "nginx"
  }
}
```
