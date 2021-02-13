# cicdenv
Terraformed, multi-acct AWS, kubernetes, CI/CD, infrastructure sample w/tooling.
(3rd Generation)

* [Current Documentation](https://github.com/cicdenv/cicdenv/wiki)
  * [Overview Slides](https://docs.google.com/presentation/d/1zqD1LQgQZK1_uJGTdZ64SRYV2dtpdqbiJrH-Ekr7JKs/)
  * [Account Architecture](https://github.com/cicdenv/cicdenv/wiki#accounts)
  * [Terraform Architecture](https://github.com/cicdenv/cicdenv/wiki#terraform)
  * [AWS - EC2 Resource Data/Cost](https://docs.google.com/spreadsheets/d/1D9WSyOVBW8kTfA97Ucx4X4G8q0j2lJbTjKL6Uzu8brg/)
  * [AWS - Sample Cost Models](https://docs.google.com/spreadsheets/d/1f5KpwT0FVM6el1KJLpqSFVZLV-587K36JfXiOzzx0z0/)
  * [Repo Stats](https://github.com/cicdenv/cicdenv/wiki/cloc-output#2020-07)
  * [Private Backlog](https://github.com/vogtech/cicdenv/issues)

## Getting Started
[cicdctl](bin/cicdctl) is the entrypoint for the tooling layer.

The tooling layer automatically manages its own container on launch.

`cicdctl` prereqs:
* [make](https://www.gnu.org/software/make/manual/make.html), [jq](https://stedolan.github.io/jq/), [keybase](https://keybase.io/), [docker](https://docs.docker.com/reference/)


Add `cicdctl` to your current shell search path:
```bash
cicdenv$ . bin/activate
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
bash                   ->  5.0.17(1)
python                 ->  3.8.5
make                   ->  4.3
aws (cli)              ->  1.18.216
terraform              ->  v0.13.6
packer                 ->  v1.6.6
kops                   ->  1.20.0-alpha.2
kubectl                ->  v1.20.2
aws-iam-authenticator  ->  0.5.2
cfssl                  ->  Version: 1.4.1
```

## AWS Access
`cicdctl` CLI automatically refreshes the 12-hour session tokens with 
[aws-mfa](https://github.com/dcoker/awsmfa/) as needed
(main / org accounts).

An [IAM User](terraform/iam-users.tfvars) must exist in the [main account](terraform/iam/users).

A users MFA totp secret is [stored gpg encrypted](mfa-virtual-devices/) and
their [gpg key](terraform/iam-users.tfvars) must be imported into their keybase client.

`~/.aws/credentials` required setup (values from - AWS IAM/users console):
* `https://console.aws.amazon.com/iam/home#/users/${IAM_USER}?section=security_credentials`:
```
[default-long-term]
aws_secret_access_key = ...
aws_access_key_id     = ...
aws_mfa_device        = ...
```

## Usage
<details>
  <summary>Basics</summary>

Sample terraform only session in the `dev` account  
```bash
# Turn on main account transit gateways
$ cicdctl terraform apply network/routing -auto-approve

# Turn on sub-account transit gateway attachments
$ cicdctl terraform apply network/routing/attachments:dev -auto-approve

# Bring up services
$ cicdctl terraform <apply|create|...> <component>:<account>

# Turn down services
$ cicdctl terraform <destroy> <component>:<account>

# Turn off sub-account transit gateway attachements
$ cicdctl terraform destroy network/routing/attachments:dev -force

# Turn off main account transit gateways
$ cicdctl terraform destroy network/routing -force
```

</details>

<details>
  <summary>Kubernetes Clusters (kOps)</summary>

* [Kubernetes as a Service Overview](https://docs.google.com/presentation/d/12OyOXtvkYO4D6Y85AVPfGZQY1yVOoho8xhEFiDBino4/)

Example: kOps v1.20.0-alpha.2 cluster in the `dev` account with default settings
```bash
# Create a new v1.20.0-aplpha1 kops kubernetes cluster
$ cicdctl cluster create 1-20a2:dev -auto-approve
$ cicdctl cluster validate 1-20a2:dev --wait 10m --count 10
$ cicdctl kubectl 1-20a2:dev ...

# Dispose of the new kops kubernetes cluster 
$ cicdctl cluster destroy 1-20a2:dev -force
```

Example: Large cluster - 18 node, 1000GB+ mem, 144 vCPUs, 90TB storage
```bash
# Create the kubernetes cluster
$ cicdctl cluster create 1-20a2-large:dev -auto-approve  \
    master_instance_type=c5d.xlarge                      \
    node_instance_type=i3en.2xlarge                      \
    nodes_per_az=6
$ cicdctl cluster validate 1-20a2-large:dev --wait 10m --count 20
...

INSTANCE GROUPS
NAME      ROLE  MACHINETYPE MIN MAX SUBNETS
master-us-west-2a Master  c5d.xlarge  1  1  private-us-west-2a
master-us-west-2b Master  c5d.xlarge  1  1  private-us-west-2b
master-us-west-2c Master  c5d.xlarge  1  1  private-us-west-2c
nodes-us-west-2a  Node  i3en.2xlarge  6 30  private-us-west-2a
nodes-us-west-2b  Node  i3en.2xlarge  6 30  private-us-west-2b
nodes-us-west-2c  Node  i3en.2xlarge  6 30  private-us-west-2c

NODE STATUS
NAME            ROLE  READY
ip-... node    True
ip-... node    True
ip-... node    True
ip-... master  True
ip-... node    True
ip-... node    True
ip-... node    True
ip-... node    True
ip-... node    True
ip-... node    True
ip-... node    True
ip-... master  True
ip-... node    True
ip-... node    True
ip-... node    True
ip-... master  True
ip-... node    True
ip-... node    True
ip-... node    True
ip-... node    True
ip-... node    True

Your cluster 1-20a2-large-kops.dev.cicdenv.com is ready

$ cicdctl kubectl 1-20a2-large:dev ...

# Dispose
$ cicdctl cluster destroy 1-20a2-large:dev -force

# Turn off private subnet NAT gateways
$ cicdctl terraform destroy network/routing:dev -force
```

</details>

<details>
  <summary>Clustered Redis 6</summary>

* [Redis as a Service Overview](https://docs.google.com/presentation/d/1ToFI-Ooa2M4Ap1eKzkM2Ts2ERLhgaQN_S7JoG_Kog4o/)


Example: `cache` cluster in `dev` account  
```bash
# Bring up 'm5dn.4xlarge' mutli-zone cluster
$ cicdctl redis create cache:dev -auto-approve instance_type=m5dn.4xlarge

# Turn off cluster
$ cicdctl redis destroy cache:dev -force

# Turn off private subnet NAT gateways
$ cicdctl terraform destroy network/routing:dev -force
```

</details>

<details>
  <summary>NGINX Plus Clusters</summary>

* [NGINX Plus as a Service Overview](https://docs.google.com/presentation/d/1wMTN74nX_8IqR3Q4_dVD31QKlsjrdL4FswWry0ZHz9k/)

Example: `web` cluster in `dev` account  
```bash
# Bring up 'm5dn.2xlarge' mutli-zone cluster
$ cicdctl nginx create web:dev -auto-approve instance_type=m5dn.2xlarge

# Turn off cluster
$ cicdctl nginx destroy web:dev -force

# Turn off private subnet NAT gateways
$ cicdctl terraform destroy network/routing:dev -force
```

</details>

<details>
  <summary>Dedicated Jenkins instances</summary>
  
* [Jenkins as a Service Overview](https://docs.google.com/presentation/d/1OjWUfC8R4ty7fspi5A1BPYFhTqreb2EsLAo85lRw3os/)

Example: `dev` account, `dist`, `test` Jenkins instances:
```bash
# Create Jenkins instances
$ cicdctl jenkins create dist:dev --type distributed -auto-approve
$ cicdctl jenkins create test:dev --type colocated   -auto-approve

# Cleanup
$ cicdctl jenkins destroy dist:dev --type distributed -force
$ cicdctl jenkins destroy test:dev --type colocated   -force

# Turn off jenkins ingresses
$ cicdctl terraform destroy jenkins/routing:dev -force

# Turn off private subnet NAT gateways
$ cicdctl terraform destroy network/routing:dev -force
```

</details>

<details>
  <summary>Bastion Services</summary>

* [Bastion Service Overview](https://docs.google.com/presentation/d/19ytRvaBg0QrlciX1pEgoqATQSfBkOHdcAI-9S9lG_Kg/)

```bash
# Bring up bastion routing
$ cicdctl terraform apply network/bastion/routing:main -auto-approve

# Bring up bastion cluster
$ cicdctl terraform apply network/bastion:main -auto-approve

# Turn off bastion cluster
$ cicdctl terraform destroy network/bastion:main -force
```

</details>

## Host Access
Example: debug ec2 instance in the `dev` account
```bash
# Hop thru the bastion service to get ssh access to the target instance
$ cicdctl bastion ssh --ip <target host private-ip>
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

## Maintenance
Slow tool start ?
```bash
cicdenv$ cicdctl console
📦 $USER:~/cicdenv$ docker system prune

# Optional
cicdenv$ make clean

# Extreme
docker system prune --all --volumes
```

Check .gitnored files:
```bash
cicdenv$ git clean -xnd
cicdenv$ # git clean -xdf
```