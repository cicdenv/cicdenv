# cicdenv
Terraformed, multi-acct AWS, kubernetes, CI/CD, infrastructure sample w/tooling.
(3rd Generation)

## Local Install
`cicdctl` is the entrypoint for the tooling layer.

Add `cicdctl` to your current shell search path:
```bash
cicdenv$ . bin/activate
```

Running this will build or update the container for the tooling layer automatically.

Prereqs:
```bash
make, jq, keybase, docker
```

Explicit Setup and test
```bash
cicdenv$ make docker-build  # or attempt to use the 
cicdenv$ make
📦 $USER:~/cicdenv$ cicdctl
📦 $USER:~/cicdenv$ cicdctl test
```

Confirm tool versions:
```bash
cicdenv$ make versions
[Tool]                     [Version]
-----------------------------------------
bash                   --> 5.0.0(1)
python                 --> 3.7.5
make                   --> 4.2.1
terraform              --> v0.12.28
packer                 --> v1.6.0
kops                   --> 1.18.0-beta.2-6309b96
kubectl                --> v1.18.5
aws-iam-authenticator  --> 0.5.1
aws (cli)              --> 1.18.71
```

## AWS Access
`cicdctl` CLI automatically refreshes the 12-hour session tokens with 
[aws-mfa](https://github.com/dcoker/awsmfa/) as needed.

An [IAM User](terraform/iam-users.tfvars) must exist in the [main account](terraform/iam/users).

A users MFA totp secret is [stored gpg encrypted](mfa-virtual-devices).
The client system must have the corresponding gpg key loaded in keybase.

## Usage
Sample session in the `dev` account:
```bash
# Turn on private subnet NAT gateways
cicdenv$ cicdctl terraform apply network/routing:dev -auto-approve

# Do stuff
cicdenv$ cicdctl ...

# Turn off private subnet NAT gateways
cicdenv$ cicdctl terraform destroy network/routing:dev -force
```

## Host Access
Example: debug ec2 instance in the `dev` account
```bash
# Active the account local bastion service if non are running
cicdenv$ cicdctl terraform apply network/bastion:dev -auto-approve

# Linux
cicdenv$ cicdctl bastion ssh dev --jump <target host private-ip>
# Mac
cicdenv$ make
📦 $USER:~/cicdenv$ eval "$(ssh-agent)"; ssh-add ~/.ssh/kops_rsa
📦 $USER:~/cicdenv$ cicdctl bastion ssh dev --jump <target host private-ip>
```

## Interactive Sessions
Needed in some cases where tooling support is incomplete.
```bash
cicdenv$ make        # or `cicdctl console`
📦 $USER:~/cicdenv$  # run some shell script or make commands ...
```

## Base AMI
There is a single main account base AMI for all EC2 instances in all accounts.

See [packer/](packer/) for details on how to build / test / publish.
