## Purpose
NOTE:
```
CA per workspace isn't implemented yet.
```

The scripts in `bin/` maintain the common kubernetes cluster identities.

Our approach here is that all clusters in the same account have the same identity.

This is accomplished by pre-creating the kubernetes PKI (CA key/cert),
injecting into the kops create/update workflow.

We need to store the key in version control hence the need to use 
aws cli `kms` to encrypt / decrypt.

## Usage
This is automatic if using `cicdctl apply-cluster ...`.

## Resetting
```
cicdenv$ rm -rf terraform/kops/backend/pki/*/ca*
```
