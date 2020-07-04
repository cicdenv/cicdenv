## Docs
- [ ] writeup cloud-init debugging instructions

## External Access
- [ ] sshd-worker image build w/secrets
- [ ] wiregaurd or OpenVPN to replace whitelisted external networks

## CI
- [ ] Jenkins SecretsManager credentials plugin
- [ ] golang 3rd party libs s3/host/workspace caching service
- [ ] run cicdctl from ec2 w/IAM role

## Workloads
- [ ] jupyter notebook server

## Multiple Contributors
- [ ] per cluster kops version
   https://github.com/kilna/kopsenv
- [ ] per component terraform version
  https://github.com/tfutils/tfenv

## Apt Repo
- [ ] py3.8 lambda layer with gnupg

## cicdctl CLI
- [ ] shell completion
  - [ ] enable in `bin/activate`
- [ ] normalize `-auto-approve|-force`
- [ ] support generating plans ?
- [ ] update deps for new shared main account components

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
- [ ] list-clusters (all accounts) command

## Accounts
- [ ] root account(s) creds/MFA support
  ```
  oathtool --base32 --totp "$(cat ~/.aws/root-${workspace}-secret.txt)"
  ```

## Modeling
- [ ] Cost Model - google sheet(s)

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

## Tools
- [ ] terraform state analyzer, dependency info

## Wiki
- [ ] pull over articles from previous repos
