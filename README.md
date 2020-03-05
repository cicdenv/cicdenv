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
📦 $USER:~/cicdenv$ cicdctl
```

Confirm tool versions:
```bash
cicdenv$ make versions
[Tool]                     [Version]
-----------------------------------------
bash                   --> 5.0.0(1)
python                 --> 3.7.5
make                   --> 4.2.1
terraform              --> v0.12.21
packer                 --> v1.5.4
kops                   --> 1.17.0-beta.1
kubectl                --> v1.17.3
aws-iam-authenticator  --> 0.5.0
aws (cli)              --> 1.18.13
```

Add to search path:
```
cicdenv$ . bin/activate
```

## One Time Setup
```bash
cicdenv$ cicdctl apply kops/shared:${WORKSPACE}
```

## Setup
```bash
# Build base AMI (main account)
cicdenv$ cicdctl apply kops/nat-gateways:main

cicdenv$ cicdctl packer build

cicdenv$ cicdctl destroy kops/nat-gateways:main

# PKI - decrpt CA private key
cicdenv$ make
📦 $USER:~/cicdenv$ terraform/kops/backend/bin/decrypt-ca-key.sh
📦 $USER:~/cicdenv$ exit
```

## Usage
Example: `dev` account
```bash
# Turn on private subnet NAT gateways
cicdenv$ cicdctl apply kops/nat-gateways:dev -auto-approve

# Create kubernetes cluster
cicdenv$ cicdctl apply-cluster 1-16:dev -auto-approve
cicdenv$ cicdctl validate-cluster 1-16:dev

# Cleanup
cicdenv$ cicdctl destroy-cluster 1-16:dev -force

# Turn off private subnet NAT gateways
cicdenv$ cicdctl destroy kops/nat-gateways:dev -force
```

## Host Access
```bash
# Inspect with bastion service
cicdenv$ cicdctl apply kops/bastion:dev -auto-approve
# Linux
cicdenv$ cicdctl bastion ssh dev # --user $USER
# Mac
cicdenv$ make
📦 $USER:~/cicdenv$ eval "$(ssh-agent)"; ssh-add ~/.ssh/kops_rsa
📦 $USER:~/cicdenv$ cicdctl bastion ssh dev # --user $USER
```

## Jenkins
```bash
# Turn on private subnet NAT gateways
cicdenv$ cicdctl apply kops/nat-gateways:dev -auto-approve

# Create Jenkins instances
cicdenv$ cicdctl apply-jenkins dist:dev --type distributed -auto-approve
cicdenv$ cicdctl apply-jenkins test:dev --type colocated   -auto-approve

# Cleanup
cicdenv$ cicdctl destroy-jenkins dist:dev --type distributed -auto-approve
cicdenv$ cicdctl destroy-jenkins test:dev --type colocated   -auto-approve

# Turn off private subnet NAT gateways
cicdenv$ cicdctl destroy kops/nat-gateways:dev -force
```

### Interactive
```bash
cicdenv$ make
📦 $USER:~/cicdenv$
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
