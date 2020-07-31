## Purpose
Custom ubuntu AMIs.

There are two considerations:
* root-volume filesystem
  * `ext4` - source: ubuntu 20.04 LTS latest
  * `ZFS` - source: ubuntu 20.04 LTS latest + packer ebssurrogate custom chroot'd AMI 
* instance-stores auto-configarion (filesystem)
  * none
  * md/ext4 - `/mnt/ephemeral`
  * zfs zpool "ephemeral" - `/mnt/ephemeral`

## Usage
### Building
Build a complete set of new AMIs:
```bash
📦 $USER:~/cicdenv$ packer/bin/build-amis.sh 
```

Manually build a complete set of new AMIs in three stages:
```bash
# Create new base AMIs (root-filesystem=ext4, ephemeral-filesystem=*)
cicdenv$ for fs in none ext4 zfs; do cicdctl packer build --ephemeral-fs "$fs"; done

# Create new source AMI (root-filesytem=zfs)
cicdenv$ cicdctl packer build --builder "ebssurrogate" --root-fs "zfs"
# Create new base AMIs (root-filesystem=zfs, ephemeral-filesystem=*)
cicdenv$ for fs in none ext4 zfs; do cicdctl packer build --root-fs "zfs" --ephemeral-fs "$fs"; done
```

### Summary
```bash
📦 $USER:~/cicdenv$ packer/bin/build-amis.sh 
cicdctl packer build --ephemeral-fs none
cicdctl packer build --ephemeral-fs ext4
cicdctl packer build --ephemeral-fs zfs
cicdctl packer build --builder ebssurrogate --root-fs zfs
cicdctl packer build --root-fs zfs --ephemeral-fs none
cicdctl packer build --root-fs zfs --ephemeral-fs ext4
cicdctl packer build --root-fs zfs --ephemeral-fs zfs
```

| Build Command | AMI Name Pattern | Root FS | Instance Store<br>(Auto Configuration) | Notes |
| ------------- | ---------------- | ------- | -------------------------------------- | ----- |
| cicdctl packer build                                          | base/ubuntu-20.04-amd64-ext4-none-* | ext4 | none      | docker-ce not installed |
| cicdctl packer build --ephemeral-fs "none"                    | base/ubuntu-20.04-amd64-ext4-none-* | ext4 | none      | docker-ce not installed |
| cicdctl packer build --ephemeral-fs "ext"                     | base/ubuntu-20.04-amd64-ext4-ext4-* | ext4 | [md]+ext4 | N/A |
| cicdctl packer build --ephemeral-fs "zfs"                     | base/ubuntu-20.04-amd64-ext4-zfs-*  | ext4 | zfs pool  | N/A |
| cicdctl packer build --builder "ebssurrogate" --root-fs "zfs" | zfs/ubuntu-20.04-amd64-*            | zfs  | N/A       | (source ami for --root-fs=zfs) |
| cicdctl packer build --root-fs "zfs" --ephemeral-fs "none"    | base/ubuntu-20.04-amd64-zfs-none-*  | zfs  | none      | docker-ce not installed |
| cicdctl packer build --root-fs "zfs" --ephemeral-fs "ext"     | base/ubuntu-20.04-amd64-zfs-ext-*   | zfs  | [md+]ext4 | N/A |
| cicdctl packer build --root-fs "zfs" --ephemeral-fs "zfs"     | base/ubuntu-20.04-amd64-zfs-zfs-*   | zfs  | zfs pool  | N/A |

### Testing
```bash
# Launch an instance using the latest base AMI
cicdenv$ cicdctl console
📦 $USER:~/cicdenv$ cicdctl terraform apply test-vpc:${WORKSPACE} -auto-approve
📦 $USER:~/cicdenv$ terraform/test-vpc/bin/launch-instances.sh <ext4|zfs>/<none|ext4|zfs>:${WORKSPACE} m5dn.large
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

## New Organization Accounts
If new org accounts are added AFTER AMIs are built, run:
```bash
cicdenv$ packer/bin/set-permissions.sh
```

## Cleanup
```bash
# Turn off private subnet NAT gateways
cicdenv$ cicdctl terraform destroy network/routing:main -force

# Interactive shell
cicdenv$ make

# Remove all but the most recent AMIs
${USER}:~/cicdenv$ packer/bin/remove-old.sh

# Removal all AMIs
${USER}:~/cicdenv$ packer/bin/remove-all.sh
```

## NVMe Instance Stores
The `none` base AMI has no support for auto configuring instance stores.
It also does not install docker-ce.

These base AMIs mount all PCI-e SSDs into a single stripped pool.
* `ext4` using linux `md` if there is more than 1 instance store device
* `zfs` using Open ZFS ZOL

## Debugging
* https://packer.io/docs/provisioners/ansible.html#debugging

```bash
ssh -i packer/ec2_amazon-ebs.pem ubuntu@<public-ip>
```

## Links
* https://www.packer.io/docs/builders/amazon-ebs.html
* https://www.packer.io/docs/builders/amazon/ebssurrogate
  * https://github.com/jen20/packer-ubuntu-zfs
* https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/nvme-ebs-volumes.html
* https://russell.ballestrini.net/aws-nvme-to-block-mapping/

## Ansible packer provisioner
* https://www.packer.io/docs/provisioners/ansible.html
* https://www.packer.io/docs/provisioners/ansible-local.html
* https://pypi.org/project/ansible/
* https://docs.ansible.com/ansible/latest/index.html
* https://www.packer.io/docs/other/debugging.html
