## Purpose
The scripts in `bin/` maintain the common kubernetes cluster identities.

### Kubernetes Certificate Authority
Clusters in the same account have the same identity.

This is accomplished by pre-creating the kubernetes internal PKI (CA key/cert)
in AWS secrets manager.
Then injecting it into the kops create/update workflow.

### Kubernetes IAM Roles for Service Accounts
There is a single OpenID Connect Identity Provider for all
clusters in all accounts.

### IRSA Setup
The oidc Idp account signing key should be created (once) and uploaded to AWS secrets manager.

```bash
📦 $USER:~/cicdenv$ terraform/kops/backend/bin/irsa-create-key.sh
📦 $USER:~/cicdenv$ terraform/kops/backend/bin/irsa-upload-key.sh
```

To setup a local environment:
```bash
📦 $USER:~/cicdenv$ terraform/kops/backend/bin/irsa-download-key.sh
```
