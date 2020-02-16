## Docs
- [ ] writeup cloud-init debugging instructions

## External Access
- [ ] IAM user removed lambda - close active bastion ssh session
- [ ] sshd-worker image build w/secrets
- [ ] wiregaurd or OpenVPN to replace whitelisted external networks

## CI
- [ ] dedicated ec2 instances w/containerized Jenkins
  - [ ] ansible playbook for pushing updated jenkins processes
- [ ] SecretsManager credentials plugin
- [ ] golang 3rd party libs s3/host/workspace caching service
- [ ] run cicdctl from ec2 w/IAM role

## Terraform 0.12+
- [ ] Refactor count(list) to for_each set/map
- [ ] Refactor to structured outputs

## Packer
- [ ] 1.5.0+ config json to hcl

## AWS
- [ ] enable instance metadata service v2

## Workloads
- [ ] jupyter notebook server

## Multiple Contributors
- [ ] external data store for items
- [ ] per cluster kops version
   https://github.com/kilna/kopsenv
- [ ] per component terraform version
  https://github.com/tfutils/tfenv
- [ ] kube2iam alternatives
  https://aws.amazon.com/about-aws/whats-new/2019/09/amazon-eks-adds-support-to-assign-iam-permissions-to-kubernetes-service-accounts/

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
- [ ] list-cluster command
  `terraform/kops/shared/data/*/clusters.txt`

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
