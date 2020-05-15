## Purpose
Common state-store for all KOPS kubernetes clusters in all regions/accounts.

## Workspaces
N/A.  All accounts store kops state in the same bucket in main-acct/us-west-2.

## Init
Create KOPS CA.
```
cicdenv$ terraform/kops/backend/bin/create-ca.sh
...
2019/06/25 12:09:55 [INFO] signed certificate with serial number ....
```

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|output> kops/backend:main
...
```

NOTE:
```
The sub-account admin IAM role is similarly sourced to provide access to users/workspaced-terraform.
```
