resource "aws_lambda_function" "ssh_keys" {
  function_name = local.ssh_keys_function_name
  role          = aws_iam_role.ssh_keys.arn
  handler       = "lambda.lambda_handler"

  s3_bucket = local.lambda_bucket.id
  s3_key    = local.ssh_keys_lambda_key

  # https://github.com/terraform-providers/terraform-provider-aws/issues/7385
  # source_code_hash = base64sha256(data.aws_s3_bucket_object.ssh_keys_lambda.etag)
  s3_object_version = data.aws_s3_bucket_object.ssh_keys_lambda.version_id

  runtime = "python3.8"
  timeout = 30
}

resource "aws_lambda_permission" "ssh_keys" {
    function_name = aws_lambda_function.ssh_keys.function_name
    statement_id  = "AllowExecutionSecretManager"
    action        = "lambda:InvokeFunction"
    principal     = "secretsmanager.amazonaws.com"
}
