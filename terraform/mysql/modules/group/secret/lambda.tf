resource "aws_lambda_function" "rotator" {
  function_name = local.function_name
  role          = aws_iam_role.lambda.arn
  handler       = "lambda.lambda_handler"

  s3_bucket = local.lambda_bucket.id
  s3_key    = local.lambda_key

  # https://github.com/terraform-providers/terraform-provider-aws/issues/7385
  # source_code_hash = base64sha256(data.aws_s3_bucket_object.lambda.etag)
  s3_object_version = data.aws_s3_bucket_object.lambda.version_id

  filename         = var.filename
  source_code_hash = filebase64sha256(var.filename)

  runtime = "python3.8"
  timeout = 15

  depends_on = [
    aws_iam_role_policy_attachment.lambda, 
    aws_cloudwatch_log_group.lambda,
  ]
}

resource "aws_lambda_permission" "secret_manager_call_Lambda" {
    function_name = aws_lambda_function.rotator.function_name
    statement_id  = "AllowExecutionSecretManager"
    action        = "lambda:InvokeFunction"
    principal     = "secretsmanager.amazonaws.com"
}
