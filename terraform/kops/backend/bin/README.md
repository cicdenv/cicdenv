## Purpose
The scripts in `bin/` maintain the common kubernetes cluster identities.

## Kubernetes Certificate Authority
Clusters in the same account have the same identity.

This is accomplished by pre-creating the kubernetes internal PKI (CA key/cert)
in AWS secrets manager.
Then injecting it into the kops create/update workflow.

## Kubernetes IAM Roles for Service Accounts
There is an OpenID Connect Identity Provider for each account.
