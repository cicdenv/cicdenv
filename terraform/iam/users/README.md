## Purpose
Master (main) account IAM admin users.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|output> iam/users:main
```

NOTE:
```
The first time you run this you'll be using the root account keys.
See below about disabling them.
```

## Importing
```hcl
data "terraform_remote_state" "iam_users" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/iam_users/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
admins = {
  "$USER" = "arn:aws:iam::<main-acct-id>:user/users/$USER"
}
credentials = {
  "fvogt" = {
    "access_key" = "<[A-Z0-9]*20>"
    "password" = "<gpg-encrypted>"
    "secret_key" = "<gpg-encrypted>"
  }
}
iam = {
  "main_admin" = {
    "role" = {
      "arn" = "arn:aws:iam::<main-acct-id>:role/users/main-admin"
      "name" = "main-admin"
      "path" = "/users/"
    }
  }
}
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

${USER}:~/cicdenv$ terraform/iam/users/bin/delete-root-access-keys.sh
${USER}:~/cicdenv$ exit
```

## User Secrets
* console password
* access key / secret key
* virtual-mfa-device codes

### Access Key
```
cicdenv$ cicdctl terraform output iam/users:main -json user_access_keys | jq -r ".${USER}"
```

### Secrets
```bash
# Interactive shell
cicdenv$ cicdctl console

# Initial console password and secret key
${USER}:~/cicdenv$ cicdctl terraform init iam/users:main
${USER}:~/cicdenv$ for key in password secret_key; do (          \
    cd terraform/iam/users;                                      \
    echo "${key} ...";                                           \
    AWS_PROFILE=admin-main terraform output -json "credentials"  \
        | jq -r ".$(id -u -n) | .${key}"                         \
        | base64 -d                                              \
        | keybase pgp decrypt;                                   \
    echo
)
done
(cd terraform/iam/users;                                      \
 echo "access_key ...";                                       \
 AWS_PROFILE=admin-main terraform output -json "credentials"  \
 | jq -r ".$(id -u -n) | .access_key")
${USER}:~/cicdenv$ access_key
${USER}:~/cicdenv$ exit
```

### MFA
Admin creates a virtual-mfa device for a new IAM user:
```bash
# Interactive shell
cicdenv$ cicdctl console

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

IAM User self MFA management, while requiring MFA codes for console/CLI access:
* https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_users-self-manage-mfa-and-creds.html
