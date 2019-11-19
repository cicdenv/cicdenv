## Purpose
Terraform has only limited support for creating sub-account iam items initially.

This component can be used to import / manage those resources post creation.

## Workspaces
This state is per-account.

## Setup
```
cicdenv$ cicdctl init iam/organization-account:${WORKSPACE}
cicdenv$ terraform/iam/organization-account/bin/import-resources.sh ${WORKSPACE}
cicdenv$ cicdctl apply iam/organization-account:${WORKSPACE}
```

## Usage
```
cicdenv$ cicdctl <init|plan|apply|destroy> iam/organization-account:${WORKSPACE}
...
```
