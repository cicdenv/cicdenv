## Purpose
Custom ubuntu AMIs.

## Usage
### Building
```bash
# Create new base AMIs
cicdenv$ for fs in none ext4 zfs; do cicdctl packer build --fs "$fs"; done
# Or build just one base AMI
cicdenv$ cicdctl packer build --fs zfs

# Turn off private subnet NAT gateways
cicdenv$ cicdctl terraform destroy network/routing:main
```

### Testing
```bash
# Launch an instance using the latest base AMI
cicdenv$ cicdctl console
📦 $USER:~/cicdenv$ cicdctl terraform apply test-vpc:${WORKSPACE}
📦 $USER:~/cicdenv$ terraform/test-vpc/bin/launch-instances.sh ${WORKSPACE} <none|ext4|zfs> m5dn.large
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
cicdenv$ packer/bin/diff-ami-info.sh <ext4,zfs>
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
${USER}:~/cicdenv$ packer/bin/remove-old.sh 'base/ubuntu-20.04-amd64-*'

# Removal all AMIs
${USER}:~/cicdenv$ packer/bin/remove-all.sh
${USER}:~/cicdenv$ exit
```

## NVMe Instance Stores
The `none` base AMI has no support for configuring instance stores.
It also does not install docker-ce.

These base AMIs mount all PCI-e SSDs into a single stripped pool.
* `ext4` using linux `md`
* `zfs` using Open ZFS ZOL

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
