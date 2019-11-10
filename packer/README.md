## Purpose
Custom ubuntu AMIs.

## Usage
### Building
```
cicdenv$ cicdctl packer build
```

### Terraform
```hcl
data "aws_ami" "custom" {
  most_recent = true

  filter {
    name   = "name"
    values = ["base/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  owners = ["<master-account-id>"]
}

# => data.aws_ami.custom.id
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

Links:
* https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/nvme-ebs-volumes.html
* https://russell.ballestrini.net/aws-nvme-to-block-mapping/
