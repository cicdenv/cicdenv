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
