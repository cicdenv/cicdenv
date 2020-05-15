## Purpose
Master (main) account assumable roles.

These roles are use by the other accounts to access resources in the main account.

Roles:
* `identity-resolver` - for reading IAM users and ssh public keys
* `ses-sender` - for sending email via SES

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|output> iam/assumed-roles:main
```
