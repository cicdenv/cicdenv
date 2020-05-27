## Purpose
Main acct cloudtrail setup.

Primary use is generate iam events for cloudwatch rules.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> cloudtrail:main
...
```
## Importing
N/A.

## Outputs
```hcl
cloudtrail_logs = {
  "bucket" = {
    "arn" = "arn:aws:s3:::cloudtrail-<domain>"
    "id" = "cloudtrail-<domain>"
    "name" = "cloudtrail-<domain>"
  }
  "key" = {
    "alias" = "alias/cloudtrail"
    "arn" = "arn:aws:kms:<region>:<main-acct-id>:key/<guid>"
    "key_id" = "<guid>"
  }
}
```

## Links
* https://github.com/trussworks/terraform-aws-cloudtrail
