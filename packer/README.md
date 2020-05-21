## Purpose
Custom ubuntu AMIs.

## Usage
### Building
```
cicdenv$ cicdctl packer build
```

### Testing
```
# Launch an instance using the latest base AMI
cicdenv$ cicdctl console
📦 $USER:~/cicdenv$ cicdctl terraform apply test-vpc:${WORKSPACE}
📦 $USER:~/cicdenv$ terraform/test-vpc/bin/launch-instances.sh ${WORKSPACE} m5dn.large
📦 $USER:~/cicdenv$ ssh -i /home/terraform/.ssh/manual-testing.pem ubuntu@<public-ip>

# Teardown
📦 $USER:~/cicdenv$ terraform/test-vpc/bin/terminate-instances.sh ${WORKSPACE}
📦 $USER:~/cicdenv$ cicdctl destroy test-vpc:${WORKSPACE}
```

## Releases
### Base
To make the lastest base AMI the default:
```
cicdenv$ cicdctl terraform apply shared/packer:main
```

To test with an unreleased lastest AMI (for example bastion, jenkins):
```
# Set a value in: terraform/amis.tfvars
base_ami_id = "..."

cicdenv$ cicdctl jenkins create <instance>:<workspace>
```

### KOPS
kops masters/nodes require a supported [docker version](https://github.com/kubernetes/kops/blob/master/nodeup/pkg/model/docker.go).

The version installed in the AMI must be a supported version.
For example `19.03.8`.

The version present in the AMI should be specified in the KOPS cluster spec:
* [terraform/kops/modules/kops-manifest/templates/cluster-spec.tpl](https://github.com/vogtech/cicdenv/blob/master/terraform/kops/modules/kops-manifest/templates/cluster-spec.tpl):
```yaml
docker:
  version: "19.03.8"
```

## Cleanup
```
# Interactive shell
cicdenv$ make

# Remove all but the most recent kops custom AMIs
${USER}:~/cicdenv$ packer/bin/remove-old.sh
${USER}:~/cicdenv$ packer/bin/remove-old.sh 'base/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*'

# Removal all AMIs
${USER}:~/cicdenv$ packer/bin/remove-all.sh
${USER}:~/cicdenv$ exit
```

## KOPS Images
kope.io (owner: 383156758163) images:
* https://github.com/kubernetes/kops/blob/master/docs/images.md
* https://github.com/kubernetes/kube-deploy/blob/master/imagebuilder/aws-1.11-stretch.yaml
* https://github.com/kubernetes/kube-deploy/blob/master/imagebuilder/templates/1.11-stretch.yml

```
k8s-1.11-debian-stretch-amd64-hvm-ebs-2018-05-27
```

## NVMe Instance Stores
TL;DR - with ubuntu 18.04 the root `ebs` volume might be 
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

```
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
