## VPN
- [ ] IAM user removed lambda - close active bastion ssh session
- [ ] wiregaurd or OpenVPN to replace whitelisted external networks

## CI
- [ ] dedicated ec2 instances containerized Jenkins
- [ ] golang 3rd party libs s3/host/workspace caching service
- [ ] run cicdctl from ec2 w/IAM role

## Multiple Contributors
- [ ] "un-listify" hotspots
- [ ] external data store for items
- [ ] per cluster kops version
   https://github.com/kilna/kopsenv
- [ ] per component terraform version
  https://github.com/tfutils/tfenv

## KOPS
- [ ] custom docker runtime version
  https://github.com/kubernetes/kops/blob/master/docs/cluster_spec.md#docker
- [ ] {kops, kubernetes, instance-type} setable from cicdctl

## Apt Repo
- [ ] py3.8 lambda layer with gnupg

## cicdctl CLI
- [ ] consistent output {default, verbose, silent, dry-run (print commands)}
  `-v --verbose, -s --silent, -dr --dry-run`
- [ ] Print custom env vars along with commands being run
- [ ] shell completion
  - [ ] enable in `bin/activate`
- [ ] refactor ArgParse to click
- [ ] terraform fmt
- [ ] automatic background AWS credential refreshing (on/off)

### Sanity checks
- [ ] check for the existance of AWS environment variables in cicdctl launcher
  `AWS_PROFILE, ... - these break aws-mfa`
- [ ] check basic requirements
  - [ ] `~/.aws/credentials`
  - [ ] `~/.ssh`
- [ ] check totp secret is present
- [ ] assert file paths (states match expected conventions)
- [ ] detect stale console session (image rebuild needed)
- [ ] `Makefile` warn on trying to build the docker image from a console session
- [ ] list-cluster command
  `terraform/kops/shared/data/*/clusters.txt`

## Accounts
- [ ] root account(s) creds/MFA support
  ```
  oathtool --base32 --totp "$(cat ~/.aws/root-${workspace}-secret.txt)"
  ```

## Modeling
- [ ] Cost Model - google sheet(s)

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

## Wiki
- [ ] pull over articles from previous repos
