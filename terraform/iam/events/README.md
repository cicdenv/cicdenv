## Purpose
Main account IAM user/public-key change events.

The motivation is this enables a service running on bastion instances
to close sessions for IAM users whose host access has been revoked.

## Workspaces
N/A.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> iam/events:main
...
```
## Importing
```hcl
data "terraform_remote_state" "iam_events" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/iam_events/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
sns = {
  "topics" = {
    "iam_user_updates" = {
      "arn" = "arn:aws:sns:us-east-1:<main-acct-id>:iam-user-updates"
      "name" = "iam-user-updates"
    }
  }
}
```

## Samples
```json
{
  "source": [
    "aws.cloudtrail"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "iam.amazonaws.com"
    ],
    "eventName": [
      "DeleteUser",
      "DeleteSSHPublicKey",
      "UpdateSSHPublicKey"
    ]
  }
}
```

## Links
* https://aws.amazon.com/premiumsupport/knowledge-center/iam-cloudwatch-sns-rule/
