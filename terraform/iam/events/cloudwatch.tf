resource "aws_cloudwatch_event_rule" "iam_user_updates" {
  name          = "iam-user-updates"
  description   = "Detects removed IAM users and changes to ssh public keys."
  is_enabled    = true
  event_pattern = file("${path.module}/event-pattern.json")
  
  provider = aws.us-east-1
}

resource "aws_cloudwatch_event_target" "iam_user_updates" {
  rule = aws_cloudwatch_event_rule.iam_user_updates.name
  arn  = aws_sns_topic.iam_user_updates.arn
  
  provider = aws.us-east-1
}
