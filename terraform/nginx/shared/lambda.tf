resource "aws_lambda_function" "nginx_tls" {
  function_name = local.tls_function_name
  role          = aws_iam_role.nginx_tls.arn
  handler       = "lambda.lambda_handler"

  s3_bucket = local.lambda_bucket.id
  s3_key    = local.tls_lambda_key

  # https://github.com/terraform-providers/terraform-provider-aws/issues/7385
  # source_code_hash = base64sha256(data.aws_s3_bucket_object.lambda.etag)
  s3_object_version = data.aws_s3_bucket_object.lambda.version_id

  runtime = "python3.8"
  timeout = 15
}

resource "aws_lambda_permission" "secret_manager_call_Lambda" {
    function_name = aws_lambda_function.nginx_tls.function_name
    statement_id  = "AllowExecutionSecretManager"
    action        = "lambda:InvokeFunction"
    principal     = "secretsmanager.amazonaws.com"
}
