resource "aws_lambda_function" "iam_user_event_subscriber" {
  filename      = "event-subscriber/lambda.zip"
  function_name = local.event_subscriber_function_name
  role          = aws_iam_role.iam_user_event_subscriber.arn
  handler       = "lambda.lambda_handler"
  runtime       = "python3.7"

  source_code_hash = filebase64sha256("event-subscriber/lambda.zip")

  vpc_config {
    subnet_ids         = values(module.shared_vpc.subnets["private"]).*.id
    security_group_ids = [aws_security_group.events.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.iam_user_event_subscriber,
  ]
}
