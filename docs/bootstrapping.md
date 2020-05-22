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
