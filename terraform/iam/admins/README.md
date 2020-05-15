## Purpose
Master (main) account IAM admin users.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|output> iam/admins:main
```

NOTE:
```
The first time you run this you'll be using the root account keys.
See below about disabling them.
```

## Billing Access
This must be enabled by the root account.

```
[x] Enabled IAM User and Role Access to Billing Information (my account)
```
* https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_billing.html
* https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/control-access-billing.html

## Root Account Keys
https://console.aws.amazon.com/iam/home#/security_credentials

These should be removed after creating admin IAM users:
```bash
# Interactive shell
cicdenv$ make

${USER}:~/cicdenv$ terraform/iam/admins/bin/delete-root-access-keys.sh
${USER}:~/cicdenv$ exit
```

## User Secrets
* console password
* access key / secret key
* virtual-mfa-device codes

### Access Key
```
cicdenv$ cicdctl terraform output iam/admins:main -json user_access_keys | jq -r ".${USER}"
```

### Secrets
```bash
# Interactive shell
cicdenv$ make

# Initial console password and secret key
${USER}:~/cicdenv$ for output in user_passwords user_secret_keys; do \
    cicdctl terraform output iam/admins:main -json "$output" | jq -r ".${USER}" | base64 -d | keybase pgp decrypt
done
${USER}:~/cicdenv$ exit
```

### MFA
Admin creates a virtual-mfa device for a new IAM user:
```bash
# Interactive shell
cicdenv$ make

${USER}:~/cicdenv$ terraform/iam/common/bin/setup-virtual-mfa-device.sh <iam-user> <keybase-user>
...
${USER}:~/cicdenv$ exit
```
Commit created `mfa-virtual-devices/*gpg` files.

IAM user tests with:
```
# MFA Login
cicdenv$ cicdctl creds aws-mfa $WORKSPACE
```
