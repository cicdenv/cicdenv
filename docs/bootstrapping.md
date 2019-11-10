# Pre Terraform Bootstrapping
The site-wide default terraform backend config can't be used until
the required terraform s3, kms, dynamodb resources are first created
outside of terraform.

## Steps
- [x] Manual main acct, billing setup
- [x] Manual setup of terraform state resources via root acct. access-key + cli
  * terraform/backend
  * terraform/backend/state-locking
- [x] import manually created terraform resources into terraform

```
#
# Using helper scripts
#
cicdenv$ bin/new-main-state.sh       backend
# Note: patch up providers.tf/variables.tf to be hard-wired to us-west-2

cicdenv$ bin/new-workspaced-state.sh backend/state-locking
```

## Possible Improvements
* backend, backend/state-locking, iam/organizations ` => cycle`
