# cicdenv
Terraformed, multi-acct AWS, kubernetes, ci/cd, infrastructure sample w/tooling.

```
Generation: 3
```

## Install
This demonstrator uses docker to ensure portable:
* tools envinronment
* absolute file paths in terraform statefile(s)

Prereqs:
```
make, jq, keybase, docker
```

Setup:
```
cicdenv$ make docker-build
```

Test:
```
cicdenv$ make
📦 fvogt:~/cicdenv$ cicdctl
```

Confirm tool versions:
```
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

## Usage
### Terraform
```
# Create kubernetes shared resources for [dev, test] accounts
cicdenv$ cicdctl apply kops/shared:{dev,test}

# Build base AMI
cicdenv$ cicdctl packer build

# Create kubernetes 1.12 clusters for [dev, test] accounts
cicdenv$ cicdctl apply-cluster 1.12:{dev,test}
cicdenv$ cicdctl validate-cluster 1.12:{dev,test}

# Inspect with bastion service
cicdenv$ cicdctl apply kops/bastion:{dev,test}
cicdenv$ cicdctl bastion ssh dev

# Cleanup [dev, test] accounts
cicdenv$ cicdctl destroy-cluster 1.12:{dev,test}
cicdenv$ cicdctl destroy kops/shared:{dev,test}
```

### Interactive
```
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
