resource "aws_lambda_permission" "iam_user_event_subscriber" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.iam_user_event_subscriber.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = local.iam_user_updates_sns_topic.arn
}

resource "aws_sns_topic_subscription" "iam_user_event_subscriber" {
  topic_arn = local.iam_user_updates_sns_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.iam_user_event_subscriber.arn
  
  provider = aws.us-east-1

  # Ensures lambda before perms are set
  depends_on = [
    aws_iam_role_policy_attachment.iam_user_event_subscriber,
  ]
}
