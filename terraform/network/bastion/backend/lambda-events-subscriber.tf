resource "aws_lambda_function" "iam_user_event_subscriber" {
  function_name = local.event_subscriber_function_name
  role          = aws_iam_role.iam_user_event_subscriber.arn
  handler       = "lambda.lambda_handler"

  s3_bucket = local.lambda_bucket.id
  s3_key    = local.event_subscriber_lambda_key

  # https://github.com/terraform-providers/terraform-provider-aws/issues/7385
  # source_code_hash = base64sha256(data.aws_s3_bucket_object.event_subscriber_lambda.etag)
  s3_object_version = data.aws_s3_bucket_object.event_subscriber_lambda.version_id

  runtime = "python3.7"

  vpc_config {
    subnet_ids         = values(local.subnets["private"]).*.id
    security_group_ids = [aws_security_group.events.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.iam_user_event_subscriber,
  ]
}
