## Purpose
IAM Roles for (Kubernetes) Service Accounts integration.

## One Time Setup
* [bin/irsa-create-key.sh]
* [bin/irsa-encrypt-key.sh]
* commit files ...
or:
* [bin/decrypt-key.sh]
* use files ...

## Verify
```bash
curl https://oidc-irsa-cicdenv-com.s3.amazonaws.com/.well-known/openid-configuration
curl https://oidc-irsa-cicdenv-com.s3.amazonaws.com/jwks.json
```
