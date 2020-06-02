resource "aws_cloudwatch_log_group" "iam_user_event_subscriber" {
  name              = "/aws/lambda/${aws_lambda_function.iam_user_event_subscriber.function_name}"
  retention_in_days = 14
}
