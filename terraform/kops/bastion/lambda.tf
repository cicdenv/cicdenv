resource "aws_lambda_function" "iam_user_event_subscriber" {
  filename      = "event-subscriber/lambda.zip"
  function_name = "event-subscriber-KOPS-BASTION"
  role          = aws_iam_role.iam_user_event_subscriber.arn
  handler       = "lambda.lambda_handler"
  runtime       = "python3.7"

  source_code_hash = filebase64sha256("event-subscriber/lambda.zip")

   vpc_config {
       subnet_ids         = local.private_subnets
       security_group_ids = [local.events_security_group]
   }
}
