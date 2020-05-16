resource "aws_cloudwatch_event_rule" "iam_user_updates" {
  name = "detect-iam-user-updates"
  description = "A CloudWatch Event Rule that detects remove IAM users and changes to IAM users ssh public keys."
  is_enabled = true
  event_pattern = <<PATTERNS
{
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
PATTERNS
}

resource "aws_cloudwatch_event_target" "iam_user_updates" {
  rule = aws_cloudwatch_event_rule.iam_user_updates.name
  arn = aws_sns_topic.iam_user_updates.arn
}
