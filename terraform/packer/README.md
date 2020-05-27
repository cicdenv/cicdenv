## Purpose
AWS Resources needed by packer (not VPC+subnets however).

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> packer:main
...
```

## Importing
N/A.

## Outputs
```hcl
allowed_account_ids = <account-id>,...
iam = {
  "instance_profile" = {
    "arn" = "arn:aws:iam::<main-acct-id>:instance-profile/packer-build"
  }
  "policy" = {
    "arn" = "arn:aws:iam::<main-acct-id>:policy/PackerBuild"
    "name" = "PackerBuild"
    "path" = "/"
  }
  "role" = {
    "arn" = "arn:aws:iam::<main-acct-id>:role/packer-build"
    "name" = "packer-build"
  }
}
key = {
  "alias" = "alias/ebs"
  "arn" = "arn:aws:kms:<region>:<main-acct-id>:key/<guid>"
  "key_id" = "<guid>"
}
```

## Encrypted Boot Volumes
For now not supported correctly by current packer versions.
* https://github.com/hashicorp/packer/issues/6212
* https://github.com/hashicorp/packer/issues/7346

```
      "encrypt_boot": true,
      "kms_key_id": "{{user `key_id`}}"
```
Packer encrypts using the "non CMK" (amazon managed default account+region key) that makes the
AMI unshareable between accounts.

* https://www.packer.io/docs/builders/amazon-ebs.html

* https://aws.amazon.com/blogs/aws/new-encrypted-ebs-boot-volumes/
* https://aws.amazon.com/blogs/aws/protect-your-data-with-new-ebs-encryption/
* https://aws.amazon.com/blogs/security/how-to-share-encrypted-amis-across-accounts-to-launch-encrypted-ec2-instances/
* https://aws.amazon.com/blogs/security/create-encrypted-amazon-ebs-volumes-custom-encryption-keys-launch-amazon-ec2-instance-2/

* https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CopyImage.html

IAM role perms to boot w/encrypted volume:
```json
{
    "Effect": "Allow",
    "Action": [
        "kms:DescribeKey",
        "kms:ReEncrypt*",
        "kms:CreateGrant",
        "kms:Decrypt"
    ],
    "Resource": [
        "<kms-key-arn>"
    ]                                                    
}
```
