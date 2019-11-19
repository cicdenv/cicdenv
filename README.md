# cicdenv
Terraformed, multi-acct AWS, kubernetes, ci/cd, infrastructure sample w/tooling.
(3rd Generation)

## Install
This demonstrator uses docker to ensure portable:
* tools envinronment
* absolute file paths in terraform statefile(s)

Prereqs:
```bash
make, jq, keybase, docker
```

Setup:
```bash
cicdenv$ make docker-build
```

Test:
```bash
cicdenv$ make
📦 fvogt:~/cicdenv$ cicdctl
```

Confirm tool versions:
```bash
cicdenv$ make versions
[Tool]                     [Version]
-----------------------------------------
bash                   --> 5.0.0(1)
python                 --> 3.7.3
make                   --> 4.2.1
terraform              --> v0.12.2
packer                 --> v1.4.1
kops                   --> 1.12.1
kubectl                --> v1.11.10
aws-iam-authenticator  --> 0.4.0
aws (cli)              --> 1.16.179
```

Add to search path:
```
cicdenv$ . bin/activate
```

## Setup
```bash
# Build base AMI (main account)
cicdenv$ cicdctl apply kops/shared:main
cicdenv$ cicdctl packer build
cicdenv$ cicdctl destroy kops/shared:main

# PKI - decrpt CA private key
cicdenv$ make
📦 fvogt:~/cicdenv$ terraform/kops/backend/bin/decrypt-ca-key.sh
📦 fvogt:~/cicdenv$ exit
```

## Usage
Example: `dev` account
```bash
# Create kubernetes shared resource
cicdenv$ cicdctl apply kops/shared:dev -auto-approve

# Create kubernetes cluster
cicdenv$ cicdctl apply-cluster 1-16:dev -auto-approve
cicdenv$ cicdctl validate-cluster 1-16:dev

# Cleanup
cicdenv$ cicdctl destroy-cluster 1-16:dev -force
cicdenv$ cicdctl destroy kops/bastion:dev -force
cicdenv$ cicdctl destroy kops/shared:dev -force
```

## Host Access
```bash
# Inspect with bastion service
cicdenv$ cicdctl apply kops/bastion:dev -auto-approve
# Linux
cicdenv$ cicdctl bastion ssh dev --user $USER
# Mac
cicdenv$ make
📦 fvogt:~/cicdenv$ eval "$(ssh-agent)"; ssh-add ~/.ssh/kops_rsa
📦 fvogt:~/cicdenv$ cicdctl bastion ssh dev --user $USER
```

### Interactive
```bash
cicdenv$ make
📦 fvogt:~/cicdenv$
```

## Conventions
### AWS Access
Expects [aws-mfa]() `admin-*-long-term` assume-role config sections 
in the shared credentials file default location: `~/.aws/credentials` for each account.

The `cicdctl` CLI automatically refreshes the 1-hour session tokens with `aws-mfa` as needed.
The decrypted `${SUER}-secret.txt` (virtual MFA device secret) must be in `~/.aws/` folder.

Example:
```
[admin-production-long-term]
aws_access_key_id = <main-acct-key-id>
aws_secret_access_key = <main-acct-secret-key>
aws_mfa_device = arn:aws:iam::<main-acct-id>:mfa/users/${USER}/${USER}MFADevice
assume_role = arn:aws:iam::<prod-acct-id>:role/production-admin

[admin-test-long-term]
aws_access_key_id = <main-acct-key-id>
aws_secret_access_key = <main-acct-secret-key>
aws_mfa_device = arn:aws:iam::<main-acct-id>:mfa/users/${USER}/${USER}MFADevice
assume_role = arn:aws:iam::<prod-acct-id>:role/test-admin
```

### Terraform Variables
Terraform 0.12.0+ is particular about variable bindings on the command line
matching defined `variable`s in the state.

The `cicdctl` CLI automatically binds variables from the default tfvar directory `terraform/*.tfvars`
to the terraform command line used for various sub-commands.

For example, to locate the terraform backend statefile location for
importing another states outputs, you want to source the `region/bucket` being used:

variables.tf
```
variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars
```
The comment informs `cicdctl` CLI as to which tfvar file to obtain the values from.
