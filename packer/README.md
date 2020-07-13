## Purpose
Custom ubuntu AMIs.

## Usage
### Building
```bash
# Create a new base AMI
cicdenv$ cicdctl packer build

# Turn off private subnet NAT gateways
cicdenv$ cicdctl terraform destroy network/routing:main
```

### Testing
```bash
# Launch an instance using the latest base AMI
cicdenv$ cicdctl console
📦 $USER:~/cicdenv$ cicdctl terraform apply test-vpc:${WORKSPACE}
📦 $USER:~/cicdenv$ terraform/test-vpc/bin/launch-instances.sh ${WORKSPACE} m5dn.large
📦 $USER:~/cicdenv$ ssh -i /home/terraform/.ssh/manual-testing.pem ubuntu@<public-ip>

# Teardown
📦 $USER:~/cicdenv$ terraform/test-vpc/bin/terminate-instances.sh ${WORKSPACE}
📦 $USER:~/cicdenv$ cicdctl terraform destroy test-vpc:${WORKSPACE}
```

## Releases
### Base
To make the lastest base AMI the default:
```bash
cicdenv$ cicdctl terraform apply shared/packer:main
```

Take diffs:
```bash
cicdenv$ packer/bin/diff-ami-info.sh
```

To test with an unreleased lastest AMI (for example bastion, jenkins):
```
# Set a value in: terraform/amis.tfvars
base_ami_id = "..."

cicdenv$ cicdctl jenkins create <instance>:<workspace>
```

## Cleanup
```bash
# Interactive shell
cicdenv$ make

# Remove all but the most recent kops custom AMIs
${USER}:~/cicdenv$ packer/bin/remove-old.sh
${USER}:~/cicdenv$ packer/bin/remove-old.sh 'base/hvm-ssd/ubuntu-focal-20.04-amd64-server-*'

# Removal all AMIs
${USER}:~/cicdenv$ packer/bin/remove-all.sh
${USER}:~/cicdenv$ exit
```

## NVMe Instance Stores
TL;DR - with ubuntu 18.04+ the root `ebs` volume might be 
`/dev/nvme0n1*` or `/dev/nvme1n1` or the last listed nvme device 
(when 2 or more are present).

The embedded scripts in the base AMI handle this.

```
# lsblk | tail +2 | grep -v 'loop'
nvme0n1     259:0    0    75G  0 disk 
└─nvme0n1p1 259:1    0    75G  0 part /
nvme1n1     259:2    0 139.7G  0 disk

or 

# lsblk | tail +2 | grep -v 'loop'
nvme0n1     259:2    0 139.7G  0 disk
nvme1n1     259:0    0    75G  0 disk 
└─nvme1n1p1 259:1    0    75G  0 part /
```

The embedded scripts use amazon linux's `ebsnvme-id.py` to filter out EBS NVMe devices:
```
# ebsnvme-id.py /dev/nvme0n1
Volume ID: vol-07a2d1fac62b933db
sda1                            
root@ip-10-16-60-230:~# echo $?
0
---
# ebsnvme-id.py /dev/nvme1n1
[ERROR] Not an EBS device: '/dev/nvme1n1'
root@ip-10-16-60-230:~# echo $?
1
```

## Debugging
* https://packer.io/docs/provisioners/ansible.html#debugging

```bash
ssh -i packer/ec2_amazon-ebs.pem ubuntu@<public-ip>
```

## Links
* https://www.packer.io/docs/builders/amazon-ebs.html
* https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/nvme-ebs-volumes.html
* https://russell.ballestrini.net/aws-nvme-to-block-mapping/

## Ansible packer provisioner
* https://www.packer.io/docs/provisioners/ansible.html
* https://www.packer.io/docs/provisioners/ansible-local.html
* https://pypi.org/project/ansible/
* https://docs.ansible.com/ansible/latest/index.html
* https://www.packer.io/docs/other/debugging.html
