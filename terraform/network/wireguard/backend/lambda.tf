resource "aws_lambda_function" "wireguard_keys" {
  function_name = local.keys_function_name
  role          = aws_iam_role.wireguard_keys.arn
  handler       = "lambda.lambda_handler"

  s3_bucket = local.lambda_bucket.id
  s3_key    = local.keys_lambda_key

  # https://github.com/terraform-providers/terraform-provider-aws/issues/7385
  # source_code_hash = base64sha256(data.aws_s3_bucket_object.lambda.etag)
  s3_object_version = data.aws_s3_bucket_object.lambda.version_id

  runtime = "python3.8"
  timeout = 15
  
  layers = [
    local.wireguard-tools_layer.arn,
  ]
}

resource "aws_lambda_permission" "secret_manager_call_Lambda" {
    function_name = aws_lambda_function.wireguard_keys.function_name
    statement_id  = "AllowExecutionSecretManager"
    action        = "lambda:InvokeFunction"
    principal     = "secretsmanager.amazonaws.com"
}
