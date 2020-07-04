## Purpose
Works around a dependency cycle.
Uses the per account NGINX TLS key to obtain a per account 
wildcard TLS server cert from letsencrypt.

## Workspaces
This state is per-account.

## Secrets
```bash
# Fetch into local checkout - needed for every account being targeted
📦 $USER:~/cicdenv$ terraform/nginx/shared/tls/bin/nginx-tls-download.sh ${WORKSPACE}
```

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> nginx/shared/tls:${WORKSPACE}
...
```

## Importing
```hcl
data "terraform_remote_state" "nginx_shared_tls" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/nginx_shared_tls/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
acme = {
  "certificate" = {
    "bundle" = "...BEGIN CERTIFICATE...\n...\n...END CERTIFICATE...\n\n...BEGIN CERTIFICATE...\n...\n...END CERTIFICATE...\n\n"
    "certificate_pem" = "...BEGIN CERTIFICATE...\n...\n...END CERTIFICATE...\n"
    "id" = "https://acme-v02.api.letsencrypt.org/acme/cert/0368c3b60e39a86ec34212fd6c2d663fbe19"
    "issuer_pem" = "...BEGIN CERTIFICATE...\n...\n...END CERTIFICATE...\n"
  }
}
```
