## Purpose
Creates sub-accounts.

NOTE: 
```
Terraform AWS Organizations support is currently limited.
Hence the shell scripts for creating OUs and moving sub-accounts into them.
```

## Workspaces
N/A.

## Usage
```
cicdenv$ cicdctl <init|plan|apply|output> iam/organizations:main
```

## CLI Usage
NOTE: must target `us-east-1` API endpoint using main acct creds:
```
# Interactive shell
cicdenv$ make

${USER}:~/cicdenv$ aws --profile=admin-main --region=us-east-1 ...
${USER}:~/cicdenv$ exit
```
