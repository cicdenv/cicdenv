resource "aws_cloudwatch_log_group" "iam_user_event_subscriber" {
  name              = "/aws/lambda/${local.event_subscriber_function_name}"
  retention_in_days = 14
}
