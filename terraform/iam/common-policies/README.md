## Purpose
Policies cannot be shared between accounts.

This is used to define the custom IAM policies that all accounts should have.

## Workspaces
This state is per-account.

## Usage
```
cicdenv$ cicdctl <init|plan|apply|destroy> iam/common-policies:${WORKSPACE}
...
```
