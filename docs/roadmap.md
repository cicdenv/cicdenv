## Assumptions
- [ ] separate unix user from IAM_USER

## cicdctl CLI
- [ ] {shutdown|startup|list}-cluster commands
  `terraform/kops/shared/data/*/clusters.txt`
- [ ] common (verbose, silent, dry-run)
  `-v --verbose, -s --silent, -dr --dry-run`
  - [ ] Print custom env vars
- [ ] cloc sub-command
- [ ] check for the existance of AWS environment variables in cicdctl launcher
  `AWS_PROFILE, ... - these break aws-mfa`
- [ ] check basic requirements
  - [ ] `~/.aws/credentials`
  - [ ] `~/.ssh`
- [ ] check totp secret is present
- [ ] assert file paths (states match expected conventions)
- [ ] shell completion
  - [ ] enable in `bin/activate`
- [ ] detect stale console session (image rebuild needed)

## Accounts
- [ ] root account(s) creds/MFA support
  ```
  oathtool --base32 --totp "$(cat ~/.aws/root-${workspace}-secret.txt)"
  ```

## Modeling
- [ ] Cost Model - google sheet

## Makefile
- [ ] warn on trying to build the docker image from a console session

## cicdctl Features
- [ ] terraform fmt
- [ ] automatic AWS credential refreshing (on/off)

## Terraform 0.12.x
- [ ] Use structured variables to implement user data model
  - [ ] iam/admins
- [ ] Use of structured outputs
  - [ ] iam/admins
  - [ ] iam/organizations
  - [ ] kops/shared

## Infrastructure
- [ ] cloudtrail
- [ ] s3/LB logging
- [ ] multi-region
- [ ] ECR images - main account, w/cross acount access
- [ ] packer - support more than one AMI
- [ ] sshd logs on bastion - aws cloudwatch logs `=>` docker logdriver
- [ ] SES config: basic setup w/validations

### Permissions
- [ ] review sub-account state bucket permissions
- [ ] review sub-account kops state-store permissions
- [ ] review KMS permissions (kops state-store, ebs-key)
  ```
  "kms:*"  => "kms:Encrypt",
              "kms:Decrypt"
  ```
